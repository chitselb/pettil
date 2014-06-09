#!/home/chitselb/bin/ruby
# pearson.rb
#
# given a file containing Forth words, generate random pearson hash
# tables forever, printing out each one that is more efficient than
# the best so far.

psize=7
pearson = Array.new(psize+1,0)
lowest_so_far=50
# 128 153 126 204 94 193 211 4
# 118 208 124 83 15 168 74 126
wordlist = Array.new
    file=File.new("junk/pearson.txt", "r")
    while line=(file.gets) do
        wordlist += [line.chomp]
        puts line
    end
    file.close

		puts "lda (tos),y" 
		puts "and #(pearsonx-pearson-1)"
		puts "tax"
		puts "lda n"
		puts "eor pearson,x"
		puts "sta n"
		puts "dey"
#puts "char^pearson[hash&psize]"
tries = 0
while true
    tries +=1

    pearson = Array.new
    until pearson.length > psize do
        pearson += [rand(256)]
        pearson.uniq!
    end

    bucket = Array.new(16,0)
    wordlist.each { |line|
#       hash=0
#       hash=line.length
#       hash=pearson[line.length&psize]
        hash=line.length&31
                line.reverse.each_byte { |char|
#            print "#{char.chr} "
            hash ^= pearson[char&psize]
            #            hash = char^pearson[hash&psize]
#           hash ^= pearson[char&psize]
        }
#	puts
# this really wouldn't work without a larger table
#       line.each_byte { |char|
#            index = hash^char
#           hash = pearson[(index&psize)]
#       }
#
# h := 0
# for each c in C loop
#   index := h xor c
#   h := T[index]
# end loop
# return h


        hash = ((hash&240)/16)^(hash&15)
        bucket[hash] += 1
    }
    t = bucket.max
    if t<lowest_so_far
        lowest_so_far = t
        pearson.each { |x| print "#{x} " }
        print "\n"
        bucket.each { |x| print "#{x} " }
        print "\n#{t}\n"
    end
    if tries > 9999
        print "."
        tries = 0
    end
end
