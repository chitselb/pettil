#!/home/chitselb/bin/ruby
    # given a string (name) and address (symbol), construct and
    # return a hash with a symbol table entry in it
    def make_symbol(name="", cfa=0, isimmediate)
        # values calculated by pearson.rb
        # 14..22        102 162 3 150 98 88 207 149
        pearson = [27, 120, 229, 241, 111, 44, 47, 141]
        psize=pearson.length-1

        c1 = [cfa.to_i].pack("S<")
    #   puts c1
        c2 = [name.length].pack("C")
    #   puts c2
        c3 = name.bytes.pack("C")
        namelen = name.length
        if name[namelen-1].ord < 33
            namelen |= 0x40     # set vocabulary bit if name ends in a control-character
        end
        namelen |= isimmediate
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
        hash1: eornybble }
        return t
    end

    # given a string from the .a65 source code, like
    #     .asc "BLOC","K"|bit7
    # returns a string containing just the ascii name of this word, e.g. "DUP"
    def parse_name(nfaline,vocabline)
        while (nfaline =~ /(.*)\|bit[67]$/)
            nfaline = $1
        end
        while (nfaline =~ /^\ *\.asc\ *(.*)/)
            nfaline = $1
        end
        while (nfaline =~ /(.*),(\d+)$/)
            nfaline = $1+',"'+$2.to_i.chr+'"'
        end
        while (nfaline =~ /\"(.+)\",'(\")'$/)
            nfaline = $1 + $2
        end
        while (nfaline =~ /\"(.+)\",'(\")',\"(.+)\"$/)
            nfaline = $1 + $2 + $3
        end
        while (nfaline =~ /\"(.+)\",\"(.)\"$/)
            nfaline = $1 + $2
        end
        while (nfaline =~ /\"(.+)\"$/)
            nfaline = $1
        end
        if (vocabline =~ /.byt\ (\d+)$/)
            nfaline += $1.to_i.chr
        end
        return nfaline
    end

    def add_symbols(symhash, filename)
        if File.exist? filename
            result = File.open(filename,'r') do |f|
                while (line = f.gets) do
                    line.chomp!
                    a = line.split(",")
                    symhash[a[0]] = a[1].hex
                end
            end
        end
    end

    # read the symbol table generated by the xa65 assembler into a hash
    # for translating the symbol into its hex address
    symbols = Hash.new
    add_symbols(symbols,"pettil-core.lab")


    # build a label file so pettil-tdict.a65 can find things in core
    # fix problems with reserved words e.g. bc add in hex address
    use_decimal = ' uarea usercold uservmbuf zgt01 _pudot dlt02 pushya i spaces01 _word _space '
    always_use_decimal = false
    symfile = File.open("pettil-core.def",'w') do |f|
#       symfile.write(#{a[0]}=#{a[1]}\n")
        symbols.each do |k, v|
            if use_decimal.include?(' '+k+' ') | always_use_decimal
                f.write("#{k} = #{v.to_s}\n")
            else
                f.write("#{k} = $#{v.to_s(16).rjust(4,'0')}\n")
            end
        end
    end

    add_symbols(symbols,"modules/pettil-tdict.lab")

    # build a monitor file with all the symbols
    symfile = File.open("pettil.mon",'w') do |f|
#       symfile.write(#{a[0]}=#{a[1]}\n")
        symbols.each do |k, v|
            f.write("al C:#{v.to_s(16).rjust(4,'0')} .#{k}\n")
        end
    end

    # build a text file for the pearson cruncher
    symfile = File.open("junk/pearson.txt",'w') do |f|
#       symfile.write(#{a[0]}=#{a[1]}\n")
        symbols.each do |k, v|
            f.write("#{k}\n")
        end
    end

=begin

#ifdef HEADERS
rehashlfa
    .byt $de,$ad
    .byt (_rehash-*-1)|bit7
    .asc "REHAS","H"|bit7
#endif
_rehash
#include "enter.i65"
    .word exit

=end
    # Scan the assembler source file for headers, that look something like
    # the block up above this comment.  parse them and create a binary
    # output file with the symbol table in it
    b=Hash.new

        coredict = "../pettil-core.a65 " +
                    "core-subroutines.a65 " +
                    "core-user.a65 " +
                    "core-inner.a65 " +
                    "core-nucleus.a65 " +
                    "core-device.a65 " +
                    "core-pet.a65 " +
                    "core-numword.a65 " +
                    "core-double.a65 " +
                    "core-string.a65 " +
                    "core-vm.a65 "

        tempdict = "pettil-tdict.a65 " +
                    "pettil-user.a65 " +
                    "pettil-interpreter.a65 " +
                    "pettil-compiler.a65 " +
                    "pettil-editor.a65 " +
                    "pettil-assembler.a65"

        ((coredict+tempdict).split " ").each do |filename|
        #((coredict).split " ").each do |filename|
        #((tempdict).split " ").each do |filename|
        infile = File.open("modules/"+filename,'r')
        while (line = infile.gets) do
            if (line.chomp == "\#ifdef HEADERS")
                # grab the next few lines
                lfasymbol = infile.gets
                dead = infile.gets
                namelenline = infile.gets
                nfaline = infile.gets   # this is useful
                if (namelenline =~ /\|bit5/)
                    vocabline = infile.gets # belongs to a vocabulary?
                else
                    vocabline = ""
                end
                endifline = infile.gets
                symbol = infile.gets    # so is this
                # make a few validation checks
                if !(dead =~ /^\s+\.byt \$de,\$ad$/)
                    puts "uh oh", symbol, dead
                end
                if !(namelenline =~ /^\s+\.byt\ \(#{symbol.chomp}-\*-1\)(\|bit5|\|bit6|\|bit7)+$/)
                    puts "uh oh", symbol, namelenline
                end
                if !(endifline.chomp =~ /^\#endif$/)
                    puts "uh oh",symbol, endifline
                end

                # turn this:    .asc "REHAS","H"|bit7
                # into this:    REHASH
                nfaline = parse_name(nfaline,vocabline)
       # # #    puts nfaline            # uncomment and feed this to pearson.rb

                if (namelenline =~ /\|bit6/) # is immmediate
                    isimmediate = 0x80
                else
                    isimmediate = 0
                end
                # we should have enough (a name and an address)
                a = make_symbol(nfaline, symbols[symbol.chomp],isimmediate)
                b[a[:name]] = a
            end
        end
    end

    symfile = File.open("pettil.sym",'w')
    Hash[b.sort_by { | k, v | v[:hash1]*32+v[:len] }].each do |h|
        a = h[1][:data].bytes
        symfile.write a.pack("C*")
    end
    symfile.write [0,0,0].pack("C*")        # null length ends pettil.sym

    symfile = File.open("junk/pearson.txt",'w')
    Hash[b.sort_by { | k, v | v[:hash1]*32+v[:len] }].each do |h|
        a = h[1][:name]
        symfile.write "#{a}\n"
    end
