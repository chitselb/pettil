#!/home/chitselb/bin/ruby
#
# xap.rb - Ruby script used by xap.sh to built PETTIL
#

    require 'json'
    require 'csv'

    # Grind through a group of 6502 source code files and spew out nextline
    # after nextline of source
    class PettilSource
        def initialize(filenames)
#            puts filenames
            @files=filenames.collect
        end

        # returns :eof at end of file, nil at the end of the last file
        def nextline
            # handle last file

            if @curr.nil?
                @curr=File.open @files.next rescue nil
            end

            return   if @curr.nil?       # Still Nil?

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
            is_vocab? line
            is_code? line,labelhash

            # this goes last
            is_desc? line
        end

        def is_done?(line)
            # ;(row of dashes), eof, or end of input stream finishes a word
            if (line =~ /^\;(-)\1*$/) || line.nil? || line == :eof
                @done = true
                @skip = true
                @tags += @flags   unless @flags.nil?
                @code += "\n```\n"   unless @code.nil?
            end
        end

        def petscii(s)
            while somechar = (/(.*)''(\h+)''(.*)/).match(s)
                s = somechar[1]+[somechar[2]].pack("H*")+somechar[3]
            end
            return s
        end

        def is_name?(line)
            if t = line.split(/^name=/)[1]
                @skip = true
                z = t.split(' ')
                case true
                    when z[0] == "~"        # name=~ Multiple Words in a Title
                        @name = z[1..-1].join ' '
                        @wikititle = @name
                        @symbol = "HOWDIDTHISGETINHERE"
                    when z.length == 1      # name=FORTHWORD
                        @name = @symbol = z[0]
                        @wikititle = @name
                    when z.length == 2      # name=[FORTHWORD] {TITLE}
                        @name = @symbol = z[0]
                        @wikititle = z[1]
                    when z.length == 3      # name=[FORTHWORD] {TITLE} SYMBOL
                        @name = z[0]
                        @wikititle = z[1]
                        @symbol = petscii z[2]
                    when z.length == 4      # name=[FORTHWORD] {TITLE} {WIKINAME} SYMBOL
                        @name = z[0]
                        @wikititle = z[1]
                        @wikiname = z[2]
                        @symbol = petscii z[3]
                    else
                        puts "wut?"
                end
            end
=begin
                @name = t
            end
            if t = line.split(/^wikiname=/)[1]
                # an alternative name for use in the wiki
                @wikiname = t
                @skip = true
            end
=end

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

        def is_vocab?(line)
            if t = line.split(/^vocab=/)[1]
                @vocab = t
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
            if @to_code && line !~ /^#include "(page|align|pass).i65".*/  # filter chaffy includes
                if @code.nil?
                    # first line is special, the label
                    @label = line
puts @label   if @label == "STUDIO"
                    @addr = labelhash[@label]
                    # start with a code quote and a slider button
                    @code =
                        "\n\n\n<$button popup=\"$:/state/codeSlider\">code</$button>"\
                        "<$reveal type=\"nomatch\" text=\"\" default=\"\" "\
                        "state=\"$:/state/codeSlider\" animate=\"yes\">\n\n```"
                end
                # append code line, filter chaff
                @code += "\n"+line
            end
            # turn on code trigger after checking, to avoid capturing the `#endif`
            if (line =~ /^\#endif$/)    # non-`#if 0` should have a comment after #endif in source
                @to_code = true
            end
        end

        def addr
            @addr
        end

        def size
            @size
        end

        def set_size(size)
            @size = size
        end

        def prevword
            @prevword
        end

        def set_prevword(prevword)
            @prevword = prevword
        end

        def nextword
            @nextword
        end

        def set_nextword(nextword)
            @nextword = nextword
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

        def symbol
            @symbol
        end

        def wikititle
            @wikititle
        end

        def wikiname
            (@wikiname.nil?) ? @wikititle : @wikiname
        end

        def vocab
            @vocab
        end

        def label
            @label
        end

        def done?
            @done
        end

        def tiddler
            # ~ add @vocab here
            text = "!! #{wikiname}"
            text = "!! //#{wikiname}//"   if @tags.index "nosymbol"
            text += ((@stack.nil?) ? "\n\n" : "&nbsp;&nbsp;&nbsp;#{@stack}\n\n")
            text += ((@prevword.nil?) ? '' : "[[<<|#{@prevword}]]&nbsp;")
            text += ((@addr.nil?) ? 'nada' : "address:&nbsp;$#{hex4out @addr}&nbsp;&nbsp;")
            text += ((@size.nil?) ? 'wut?' : "size:&nbsp;#{@size}&nbsp;")
            text += ((@nextword.nil?) ? "\n\n" : "[[>>|#{@nextword}]]\n\n")
            text += ((@desc.nil?) ? '' : @desc)
            text += ((@code.nil?) ? '' : @code)
#            puts wikititle.to_json
            return "\{ \"tags\": #{tags.join(" ").to_json},"\
                    "\"title\": #{wikititle.to_json},"\
                    "\"text\": #{text.to_json}\},\n"
        end

        # 0x80 = Smudge bit
        # 0x40 = Vocabulary bit
        # 0x20 = Immediate bit
        def symbol_table_entry
            if @addr.nil?
                return nil
            else
#            puts @name.to_s,@wikiname.to_s,@symbol.to_s
                symlen = @name.length
                if !@vocab.nil?
                    @symbol = @name+ [@vocab.to_i].pack("C")
                    symlen |= 0x40
                end
                symlen |= 0x20   if @flags.index("immediate")  unless @flags.nil?
                # length |= 0x40   if ....  add vocabulary support ~

                # a String,
                # - 2 byte address
                # - 1 byte length|flags
                # - n byte symbol
                # - 1 byte vocid (optional)
                return [@addr].pack("S<")+[symlen].pack("C")+@symbol.bytes.pack("C*")
            end
        end
    end

    def hex4out(addr)
#puts addr,addr.to_s(16).rjust(4,'0')
        return addr.to_s(16).rjust(4,'0')
    end

    def hex2out(byte)
        puts byte  if byte != 0
        return byte
    end

    # read an assembler-generated label file in:  label, address
    def add_labels(filename)
        labels = Hash.new
        if File.exist? "./tmp/"+filename
            result = File.open("./tmp/"+filename,'r') do |f|
                while (line = f.gets) do
                    line.chomp!
                    a = line.split(",")
                    labels[a[0]] = a[1].hex
                end
            end
        else
            puts "missing +#{filename}"
        end
        return labels
    end

    # outputs a label file for the xpet monitor
    def write_xpet_monfile(outputfile,labels)
        monfile = File.open("./tmp/"+outputfile,'w') do |file|
            labels.each do |label, addr|
                file.write("al C:#{hex4out addr} .#{label}\n")
            end
        end
    end

    # outputs a csv file for performance tuning
=begin
    def write_symtab_file(outputfile,forthwordhash)
        sortedbylen = forthwordhash.sort_by {|wordname, stuff| stuff.symbol.length.chr+stuff.symbol}
        symfile = File.open("./tmp/"+outputfile,'wb')
        sortedbylen.each do |wordname, stuff|
            if !(stuff.symbol_table_entry.nil?) && !(stuff.tags.index "nosymbol")
               # puts hex4out(stuff.symbol.length)+\
               # ' '+hex4out(stuff.name.length)+' '+stuff.name+'   '+stuff.symbol


#puts stuff.symbol.length.to_s+'   '+stuff.symbol_table_entry.to_s \
#                            unless stuff.symbol_table_entry.nil?
            end
            symfile.write stuff.symbol_table_entry   unless stuff.tags.index "nosymbol"
        end
        symfile.write [0,0,0].pack("C*")        # null length ends pettil.sym
    end
=end

    def write_size_file(outputfile,forthwordhash)
        sizefile = File.open("./tmp/"+outputfile,'w')
        forthwordhash.each do |wordname,stuff|
            sizeline = ["#{wordname}","#{stuff.size}"].to_csv
            sizefile.write sizeline
        end
    end

    def write_xpet_csvfile(outputfile,forthwordhash)
#        puts forthwordhash
        csvfile = File.open("./tmp/"+outputfile,'w') do |file|
            forthwordhash.each do |wordname, stuff|
                t = ((stuff.addr.nil?) ? '' : hex4out(stuff.addr).upcase)
                s = ((stuff.flags.nil?)) ? '' : stuff.flags.join(",")
                a = stuff.symbol
                d = wordname.sub(a,'')
                outline = ["#{stuff.label}","#{stuff.symbol}","#{wordname}",\
                    "#{d}",\
                    t,\
#                    "#{stuff.stack}",\
                    "#{stuff.tags.join(",")}",\
                    s,\
#                    "#{stuff.vocabulary}",\
#                    "#{stuff.name}",\
                    "#{stuff.size}"].to_csv
                file.write outline
            end
        end
    end

    # outputs a definitions file for the transient dictionary
    def write_defs_file(outputfile,labels)
        # these labels have an address that conflicts with a keyword,
        # e.g. addresses containing 'bc' or 'add' used by Sweet-16




        bogus = " pqdo02 past dult "




        always_use_decimal = true
        symfile = File.open("./tmp/"+outputfile,'w') do |file|
            labels.each do |label, addr|
                addr_out = "$"+addr.to_s(16).rjust(4,'0')
                # use decimal if the hex address is known to conflict
                addr_out = addr.to_s   if bogus.include?(' '+label+' ')\
                                             || always_use_decimal
                file.write("#{label} = #{addr_out}\n")   unless label == "romoptions"
            end
        end
    end

    def set_sizes(forthwordhash)
#forthwordhash.each do  |wordname, stuff|
#    puts stuff.addr.to_s + '     ' + wordname
#end
        sortedbyaddr = forthwordhash.sort_by {|wordname, stuff| stuff.addr}
        for i in 0..(sortedbyaddr.size-2)
            prevword = (i>0) ? sortedbyaddr[i-1][1].wikititle : nil
            nextword = sortedbyaddr[i+1][1].wikititle
            size = sortedbyaddr[i+1][1].addr-sortedbyaddr[i][1].addr
            sortedbyaddr[i][1].set_size size
            sortedbyaddr[i][1].set_prevword prevword
            sortedbyaddr[i][1].set_nextword nextword
        end
        sortedbyaddr.last[1].set_size 6     # assembler vocabulary
  # => [[:joan, 18], [:fred, 23], [:pete, 54]]
#       forthwordhash.each do |wordname, stuff|#
#           print stuff.addr, stuff.label
#       end
    end


#puts forthwordhash.sort_by { | wordname, size| wordname.size }
# forthwordhash.sort_by { | wordname, size| size }.each do |wordname, stuff|
#    puts wordname, stuff
# end
    def write_symtab_file(outputfile,forthwordhash)
        sortedbylen = forthwordhash.sort_by {|wordname, stuff|(stuff.symbol.bytes[0]&15).chr+stuff.symbol.length.chr+stuff.symbol.bytes[0].chr}
        symfile = File.open("./tmp/"+outputfile,'wb')
        sortedbylen.each do |wordname, stuff|
            if !(stuff.symbol_table_entry.nil?) && !(stuff.tags.index "nosymbol")
               # puts hex4out(stuff.symbol.length)+\
               # ' '+hex4out(stuff.name.length)+' '+stuff.name+'   '+stuff.symbol


#puts stuff.symbol.length.to_s+'   '+stuff.symbol_table_entry.to_s \
#                            unless stuff.symbol_table_entry.nil?
            end
            symfile.write stuff.symbol_table_entry   unless stuff.tags.index "nosymbol"
        end
        symfile.write [0,0,0].pack("C*")        # null length ends pettil.sym
    end

    def write_symtab_dump(outputfile,forthwordhash)
        symfile = File.open("./tmp/"+outputfile,'wb')
        forthwordhash.each do |wordname, stuff|
            t=stuff.symbol
            if t[-1] < ' '
                vocab = t[-1].ord
                t.chop!
            else
                vocab = 0
            end
            symfile.write("#{t},#{vocab}\n")
            symfile.write("#{stuff.tags.to_json}\n")
        end
    end

    def write_json_file(outputfile,forthwordhash)
        jsonfile = File.open("./tmp/"+outputfile,'w')
        jsonfile.write "[\n"
        glossary = headless = ""
        forthwordhash.each do |wordname, stuff|
            entry = "\[\["+ stuff.wikiname + "\]\] &nbsp;&nbsp;&nbsp;&nbsp; "
            if stuff.tags.index "nosymbol"
                headless += entry
            else
                glossary += entry
            end
#puts stuff.tiddler
            jsonfile.write stuff.tiddler
        end
#puts glossary.to_json
        jsonfile.write "{ \"title\":\"Glossary\",\"tags\":\"default\",\"text\":#{glossary.to_json}},"
#puts headless.to_json
        jsonfile.write "{ \"title\":\"Headless\",\"tags\":\"\",\"text\":#{headless.to_json}}]"
    end

    def write_size_file(outputfile,forthwordhash)
        sizefile = File.open("./tmp/"+outputfile,'w')
        forthwordhash.each do |wordname,stuff|
            sizeline = ["#{wordname}","#{stuff.size}"].to_csv
            sizefile.write sizeline
        end
    end

    # write a simple list of names for the pearson cruncher
    def write_pearson_file(outputfile,forthwordhash)
        pearsonfile = File.open("./tmp/"+outputfile,'w')
        forthwordhash.each do |wordname, stuff|
            pearsonfile.write "#{stuff.name}\n"   unless stuff.tags.index "nosymbol"
        end
    end

    ### The main event ###
    # parse the core dictionary label file generated by the assembler
    labels = add_labels "pettil-core.lab"

    # write out core definitions so the transient dictionary can find stuff
    write_defs_file "pettil-core.def",labels

    # now we add the rest of the symbols from the transient dictionary
    all_labels = labels.merge(add_labels "pettil-studio.lab")

    write_defs_file "pettil-studio.def",all_labels

    # write an xpet monitor file with both core and transient labels
    write_xpet_monfile "pettil.mon",all_labels

    # Changing any files here?  Also modify src/core/pettil-core.a65
    files = \
        "sweet16.a65 "\
        "core-locals.a65 "\
        "core-user.a65 "\
        "core-nucleus.a65 "\
        "core-extra.a65 "\
        "core-inner.a65 "\
        "core-double.a65 "\
        "core-vm.a65 "\
        "core-io.a65 "\
        "pettil-core.a65 "\

    core_files = files.split(" ").collect { |filename| "./src/core/"+filename }

    # Changing any files here?  Also modify studio/src/pettil-studio.a65
    files = \
        "pettil-cold.a65 "\
        "pettil-studio.a65 "\
        "pettil-name.a65 "\
        "pettil-number.a65 "\
        "pettil-user.a65 "\
        "pettil-dictionary.a65 "\
        "pettil-interpreter.a65 "\
        "pettil-compiler.a65 "\
        "pettil-utils.a65 "\
        "pettil-editor.a65 "\
        "pettil-assembler.a65 "

    studio_files = files.split(" ").collect { |filename| "./src/studio/"+filename }

    all_words = Hash.new
    pettil = PettilSource.new core_files+studio_files

    forthword = nil
    until (line = pettil.nextline).nil?
#puts line
        if !forthword.nil?
            forthword.feed line,all_labels
            if forthword.done?
#puts forthword.name+forthword.vocab.to_s+" "+forthword.size.to_s+" "+forthword.addr.to_s
                all_words[forthword.name+forthword.vocab.to_s] = forthword
                forthword = nil
            end
        end
        if line =~ /^\#if 0$/
            forthword = ForthWord.new
        end
    end
#puts "finis"


    #calculate the @size field of each forthword
#puts all_words
#    puts all_words["STUDIO"].addr
#    puts all_words.each { | word| word }
    set_sizes all_words   unless all_words["STUDIO"].addr.nil?

    # output symbol table file
    write_symtab_file "pettil.sym",all_words

    # output symbol table file in CSV, for metrics
    write_symtab_dump "symtab.csv",all_words

    # output tiddlers for tiddlypettil
    write_json_file "pettil.json",all_words

    # output word sizes as csv
    write_size_file "sizes.csv",all_words

    # output word names for pearson cruncher
    write_pearson_file "pearson.txt",all_words

    # kick out a csv file of symbols and addresses for performance tuning
    write_xpet_csvfile "pettil.csv",all_words

    exit
