#require "json"


def make_symbol (name, symbol)
    c1 = [symbol].pack("S<")
#   puts c1
    c2 = [name.length].pack("C")
#   puts c2
    c3 = name.bytes.pack("C")
    nfa = [name.length].pack("C")+name
    data = [symbol].pack("S<")+nfa
    eorbyte = data.unpack("C*").inject(0,:^)
    eornybble = (eorbyte & 15) ^ ((eorbyte ^ 240)/16).to_i
#    print eornybble
#    puts
#    puts eornybble
    t = { 
    name: name ,
    data: data , 
    len: name.length ,
    hash1: eornybble }
#    print t 
#    puts
    return t
#     [symbol].pack("S<") + [name.length].pack("C") + name.bytes.to_a.pack("C")
end

def parse_name(nfaline)
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
    return nfaline
end


h = Hash.new
symbols = Hash.new
result = File.open('pettil.lab','r') do |f|
    while (line = f.gets) do
        line.chomp!
        a = line.split(",")
        h[a[0]] = a[1].hex
    end
end
symfile = File.open('pettil.sym','w')

b=Hash.new
infile = File.open('pettil.a65','r') do |f|
    while (line = f.gets) do
       if (line.chomp == "\#ifdef HEADERS")
            lfasymbol = f.gets
            dead = f.gets
            namelen = f.gets
            nfaline = f.gets
            endifline = f.gets
            symbol = f.gets
            nfaline = parse_name(nfaline)
            puts nfaline
            a = make_symbol(nfaline, h[symbol.chomp])
            b[a[:name]] = a
            symbols[a[:name]] = a
            if !(dead =~ /\.byt \$de,\$ad$/)
                puts "uh oh", symbol, dead
            end
            if (endifline.chomp != "\#endif")
                puts "uh oh",symbol, endifline
            end
            if !(namelen =~ /^\ *\.byt\ \(#{symbol.chomp}-\*-1\)\|bit.*[67]$/)
                puts "uh oh", symbol, namelen
            end
#            a = Array.new
#            a[0] = h[symbol.chomp]
#            symfile.write a.pack("S<")
#            a[0] = nfaline.length
#            symfile.write a.pack("C")
#            symfile.write nfaline
       end
    end
#            b = Hash[a.sort_by { | k, v | :hash1 }]
            #print b.size
            #puts
            loadaddr = ['0x7800'.hex].pack("S<")
            symfile.write loadaddr
            print loadaddr
            puts
            b.sort_by { | k, v | v[:hash1]*32+v[:len] }.each {|h|
                symfile.write h[1][:data]
            #print h[1][:name]
            #puts
            }
end

