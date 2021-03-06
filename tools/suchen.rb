# suchen.rb
#
# Analyzes a hexdump of the latest build, searching for duplicate strings
# that might be factorable
#
minimum_size=12


all = File.binread("tmp/pettil.obj")

i=0
while i<(all.size-minimum_size) do
    seek = all[i+=1, minimum_size]
    j = all.index(seek,i+1)
    if j
        seek.each_byte {|b| print b.to_s(16).rjust(2,'0')," "}
        print   " ", (i+0x6bfc).to_s(16).rjust(4,'0'), \
                " ", (j+0x6bfc).to_s(16).rjust(4,'0'), "\n"
	i+=minimum_size  
    end
end

