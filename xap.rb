#!/home/chitselb/bin/ruby
#
# xap.rb - Ruby script used by xap.sh to built PETTIL
#

    require 'json'

    # Grind through a group of 6502 source code files and spew out nextline
    # after nextline of source
    class PettilSource
        def initialize(filenames)
            @files=filenames.split(' ').to_enum
        end

        # returns :eof at end of file, nil at the end of the last file
        def nextline
            # handle last file
            @curr=File.open "./src/"+@files.next rescue nil  if @curr.nil?
            if @curr.nil?       # Still Nil?
                return nil
            end
            # handle EOF
            if (line = @curr.gets).nil?
                @curr=nil
                :eof
            else
                line.chomp
            end
        end
    end

    # Assembler code segments look like this
    # Parse through all the source code files and parse them, throwing
    # things into the forth_words hash as we go
    # * wordname (the key)                      name=;
    # * stack, stack diagram for the wiki       stack=( -- )
    # * tags, for the wiki and processing       tags=compiler,fig,forth-79,forth-83
    # * flags, for the symbol table             flags=immediate
    # * vocabulary, unused for now              vocab=1
    #
    # * text, for the wiki
    #       Grab everything between `#if 0`
    #       and `#endif` that isn't one of
    #       those other things
    # * label, the first line following #endif  _semi
    # * code, for the wiki code button
    #       The label plus all lines up
    #       to the ;----------- line that
    #       aren't #include page.i65 chaff
=begin

;--------------------------------------------------------------
#if 0
name=;
stack=( -- )
tags=compiler,fig,forth-79,forth-83
flags=immediate
 An immediate word which terminates a colon-definition and
 stops further compilation. Compiles the run-time `exit`

!!! pronounced: "semi"

```
: ;   ( -- )
     ?csp
     ['] exit compile   latest smudge [ ; immediate

```
#endif
_semi
#include "enter.i65"
    .word _qcsp
#include "page.i65"
    .word _compile
    .word exit
#include "page.i65"
    .word _latest
#include "page.i65"
    .word smudge
#include "page.i65"
    .word _lbracket
#include "page.i65"
    .word exit

;--------------------------------------------------------------
=end

    # One of these is created for every `#if 0` in the input stream.
    class ForthWord
        def initialize
            @desc = ''
        end
        # accepts lines from the input stream that are potentially out of
        # order and evolves the object as more information is received
        def feed(line, labelhash)
            @skip = false

            # this goes first
            is_done? line
            return if @done

            is_name? line
            is_flags? line
            is_tags? line
            is_stack? line
            is_code? line,labelhash

            # this goes last
            is_desc? line
        end

        def is_done?(line)
            # ;(row of dashes), eof, or end of input stream finishes a word
            if line =~ /^;-*$/ || line.nil? || line == :eof
                @done = true
                @skip = true
                @tags += @flags   unless @flags.nil?
                @code += "\n```\n"   unless @code.nil?
            end
        end

        def is_name?(line)
            if t = line.split(/^name=/)[1]
                @name = t
                @skip = true
            end
            if t = line.split(/^wikiname=/)[1]
				# an alternative name for use in the wiki
                @wikiname = t
                @skip = true
            end

        end

        def is_flags?(line)
            if t = line.split(/^flags=/)[1]
                @flags = t.split(',')
                @skip = true
            end
        end

        def is_tags?(line)
            if t = line.split(/^tags=/)[1]
                @tags = t.split(',')
                @skip = true
            end
        end

        def is_stack?(line)
            if t = line.split(/^stack=/)[1]
                @stack = t
                @skip = true
            end
        end

        # captures desc += line unless code trigger is set or skip is true
        def is_desc?(line)
            @desc += "\n"+line   unless @skip or @to_code
        end

        #  at `#endif`, set the code trigger and cancel desc trigger
        # capture code += line if code trigger is set
        def is_code?(line,labelhash)
            if @to_code
                if @code.nil?
                    # first line is special, the label
                    unless @tags.index("nolabel") || @tags.index("nosymbol")
                        @label = line
                        @addr = labelhash[@label]
                    end

                    # start with a code quote and a slider button
                    @code = 
                        "\n\n\n<$button popup=\"$:/state/codeSlider\">code</$button>"\
                        "<$reveal type=\"nomatch\" text=\"\" default=\"\" "\
                        "state=\"$:/state/codeSlider\" animate=\"yes\">\n\n```"
                end
                # append code line, filter chaff
                @code += "\n"+line   unless line =~ /#include "(page|enter|pad).i65"/
            end
            # turn on code trigger after checking, to avoid capturing the `#endif`
            if (line =~ /^\#endif$/)    # non-`#if 0` should have a comment after #endif in source
                @to_code = true
            end
        end

        def addr
            @addr
        end

        def desc
            @desc
        end

        def code
            @code
        end

        def flags
            @flags
        end

        def tags
            @tags
        end

        def name
            @name
        end

        def wikiname
            (@wikiname.nil?) ? @name : @wikiname
        end
        
        def label
            @label
        end

        def done?
            @done
        end

		def tiddler
			text = "!!!#{@name}"
			text += ((@stack.nil?) ? '' : "&nbsp;&nbsp;&nbsp;#{@stack}\n\n")
			text += ((@desc.nil?) ? '' : @desc)
			text += ((@code.nil?) ? '' : @code)
			return "\{ \"title\":#{wikiname.to_json},"\
					"\"text\":#{text.to_json},"\
					"\"tags\":#{@tags.to_json}\},\n"
		end

        def symbol_table_entry
			if @addr.nil?
				return nil
			else
				length = @name.length
				length |= 0x80   if @flags.index("immediate")  unless @flags.nil?
				# length |= 0x40   if ....  add vocabulary support ~
				
				# a String, 
				# - 2 byte address
				# - 1 byte length|flags
				# - n byte name
				return [@addr].pack("S<")+[length].pack("C")+@name.bytes.pack("C*")
			end
        end
    end

    # given a string (name) and address (symbol), construct and
    # return a hash with a symbol table entry in it
    def make_symbol(name="", cfa=0, nfaflags, desc, tags)
        # values calculated by pearson.rb
        # 14..22        102 162 3 150 98 88 207 149
        # 27, 120, 229, 241, 111, 44, 47, 141
        #
        pearson = [231, 8, 197, 27, 61, 59, 64, 192]
        psize=pearson.length-1

        c1 = [cfa.to_i].pack("S<")
        c2 = [name.length].pack("C")
    #   puts c2
        c3 = name.bytes.pack("C")
        namelen = name.length
        namelen |= nfaflags
        nfa = [namelen].pack("C")+name
        data = [cfa.to_i].pack("S<")+nfa

        # the vocabulary identifier byte (if present) is part of the hash
        # the length bits (and psize) are the seed of the hash

        hash=name.length&31
        name.each_byte { |char|
            hash ^= pearson[char&psize]
        }



 #       hash=name.length
 #       name.each_byte { |char|
 #           hash = char^pearson[hash&psize]
 #       }
        eornybble = (hash & 15)^((hash ^ 240)/16)
        t = {
        name: name ,
        data: data ,
        len: name.length ,
        hash1: eornybble,
        desc: desc,
        tags: tags }
        return t
    end

    def add_labels(filename)
        labels = Hash.new
        if File.exist? "./build/"+filename
            result = File.open("./build/"+filename,'r') do |f|
                while (line = f.gets) do
                    line.chomp!
                    a = line.split(",")
                    labels[a[0]] = a[1].hex
                end
            end
        end
        return labels
    end

    def suppress_symbol(arrayoftags)
        return arrayoftags.index("nosymbol") || arrayoftags.index("general")
    end

    # outputs a label file for the xpet monitor
    def write_xpet_monfile(outputfile,labels)
        monfile = File.open("./build/"+outputfile,'w') do |file|
            labels.each do |label, addr|
                file.write("al C:#{addr.to_s(16).rjust(4,'0')} .#{label}\n")
            end
        end
    end

    # outputs a definitions file for the transient dictionary
    def write_core_defs(outputfile,labels)
        # these labels have an address that conflicts with a keyword,
        # e.g. addresses containing 'bc' or 'add' used by Sweet-16
        bogus = " usersp0 slashmod "
        always_use_decimal = false
        symfile = File.open("./build/"+outputfile,'w') do |file|
            labels.each do |label, addr|
                addr_out = "$"+addr.to_s(16).rjust(4,'0')
                # use decimal if the hex address is known to conflict
                addr_out = addr.to_s   if bogus.include?(' '+label+' ')\
                                             || always_use_decimal
                file.write("#{label} = #{addr_out}\n")
            end
        end
    end

def write_symtab_file(outputfile,forthwordhash)
    symfile = File.open("./build/"+outputfile,'w')
    forthwordhash.each do |wordname, stuff|
		symfile.write stuff.symbol_table_entry   unless stuff.tags.index "nosymbol"
#       print wordname, stuff
#       symfile.write forthwordhash[forthword].symbol_table_entry
#       symfile.write a.pack("C*")   unless suppress_symbol h[1][:tags]
    end
    symfile.write [0,0,0].pack("C*")        # null length ends pettil.sym
end

	def write_json_file(outputfile,forthwordhash)
		jsonfile = File.open("./build/"+outputfile,'w')
		jsonfile.write "[\n"
		glossary = ""
		forthwordhash.each do |wordname, stuff|
			glossary += ("\[\["+ stuff.wikiname + "\]\] ")
			jsonfile.write stuff.tiddler
		end
		jsonfile.write "{ \"title\":\"Glossary\",\"text\":#{glossary.to_json}}]"

	end



    ### The main event ###
    # parse the core dictionary label file generated by the assembler
    labels = add_labels "pettil-core.lab"

    # write out core definitions so the transient dictionary can find stuff
    write_core_defs "pettil-core.def",labels

    # now we add the rest of the symbols from the transient dictionary
    all_labels = labels.merge(add_labels "pettil-tdict.lab")

    # build an xpet monitor file with both core and transient labels
    write_xpet_monfile "pettil.mon",all_labels

    core_files = "pettil-core.a65 "\
                "core-subroutines.a65 "\
                "core-user.a65 "\
                "core-inner.a65 "\
                "core-nucleus.a65 "\
                "core-device.a65 "\
                "core-pet.a65 "\
                "core-numword.a65 "\
                "core-double.a65 "\
                "core-string.a65 "\
                "core-vm.a65 "\
                "sweet16.a65 "

    transient_files = "pettil-tdict.a65 "\
                "pettil-user.a65 "\
                "pettil-interpreter.a65 "\
                "pettil-compiler.a65 "\
                "pettil-editor.a65 "\
                "pettil-assembler.a65 "

    all_words = Hash.new
    pettil = PettilSource.new core_files+transient_files

	forthword = nil
    until (line = pettil.nextline) == nil
        if !forthword.nil?
            forthword.feed line,all_labels
            if forthword.done?
                all_words[forthword.name] = forthword
                forthword = nil
            end
        end
        # scan for '#ifdef 0'
        if line =~ /\#if 0$/
            forthword = ForthWord.new
        end
    end

	# output symbol table file
    write_symtab_file "pettil.sym",all_words

	# output tiddlers for tiddlypettil
    write_json_file "pettil.json",all_words

    exit





    #["pettil-interpreter.a65"].each do |filename|
    ((coredict+" "+tempdict).split " ").each do |filename|
    #((coredict).split " ").each do |filename|
    #((tempdict).split " ").each do |filename|
        infile = File.open("modules/"+filename,'r')
        while (line = infile.gets) do
            line.chomp!
            if line =~ /\#if 0$/
                wordname, flags, vocab, desc, t = nil
                nfaflags = 0
                capture_desc = false
                tags = []
                desc=""
                while !((line = infile.gets.chomp) =~ /^\#endif$/)
                    capture = true
                    if t = line.split(/^name=/)[1]
                        wordname = t
                        capture = false
                    end

                    if t = line.split(/^flags=/)[1]
                        flags = t
                        capture = false
                    end
                    if t = line.split(/^vocab=/)[1]
                        vocab = t
                        capture = false
                    end

                    if t = line.split(/^stack=/)[1]
                        desc = "!! " + wordname + "&nbsp;&nbsp;&nbsp;" + t +"\n"
                        capture = false
                    end
                    if t = line.split(/^tags=/)[1]
                        tags = t.split(',')
                        capture = false
                    end
#                    capture_desc = false  if line =~ /^\[\/desc\]$/
                    desc += "\n" + line   if capture
#                    capture_desc = true  if line =~ /^\[desc\]$/
                end
                nfaflags |= 0x80   if flags =~ /immediate/
                if vocab != nil
                    wordname += vocab.to_i.chr
                    nfaflags |= 0x40
                end
                if suppress_symbol tags
                    text = desc
                else
                    symbol = infile.gets.chomp
                    code = "\n```\n" + symbol
                    codeblock = true
                    while codeblock && (line = infile.gets) do
                        codeblock = !(line =~ /^\;(-)\1*$/)
                        keepline = !(line =~ /#include "(page|enter|pad).i65"/)
                        code += "\n" + line.chomp   if codeblock && keepline
                    end
                    code +=
                    text = desc+"<$button popup=\"$:/state/codeSlider\">code</$button>"\
                    "<$reveal type=\"nomatch\" text=\"\" default=\"\" state=\"$:/state/codeSlider\" animate=\"yes\">\n```\n"\
                    +code+"</$reveal>"
                end
                a = make_symbol(wordname, symbols[symbol], nfaflags, text, tags)
                b[a[:name]] = a
            end
        end

=begin
         =~ /\#if 0$/) do
                while !((line = infile.gets.chomp) =~ /^\#endif$/) do
                    puts line
                end
            end
        end
            if (line =~ /\#if 0$/)
                nfaflags = 0
                while !(line =~ /^\#endif$/)
                    wordname = line[/^name=/,1]
                    modifier = line[/^modifier=/,1]
                    modifier = infile.gets.chomp
                    line = infile.gets.chomp
                end
                symbol = infile.gets.chomp
                if modifier =~ /immediate/

                end
                if modifier =~ /vocab/
                    nfaflags |= 0x40
                end
                print "#{wordname} #{symbol} #{nfaflags.to_s}  #{modifier}\n"
                a = make_symbol(wordname, symbols[symbol], nfaflags)
                b[a[:name]] = a
            end
            line = infile.gets.chomp
        end
=end
    end

    symfile = File.open("junk/pearson.txt",'w')
    Hash[b.sort_by { | k, v | v[:hash1]*32+v[:len] }].each do |h|
        a = h[1][:name]
        symfile.write "#{a}\n"   unless suppress_symbol h[1][:tags]
    end

    symfile = File.open("junk/pettil.json",'w')
    symfile.write "[\n"
    glossary=""
    b.each do |h|
        glossary += "\[\["+ h[1][:name] + "\]\] "

        h[1][:tags].concat ["glossary"]   unless h[1][:tags].index "general"

        symfile.write "\{ \"title\":#{h[1][:name].to_json},\"text\":#{h[1][:desc].to_json},\"tags\":#{h[1][:tags].to_json}\},\n"

#,\"tags\":#{h[1][:tags].to_json}
    end
    symfile.write "\{ \"title\":\"Glossary\",\"text\":#{glossary.to_json}\}\]"
