#hexout = "0123456789abcdef"
#bucket = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
#pearson = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
#psize=31
#pearsonmin=9999
#nybroll = [0,2,4,6,8,10,12,14,1,3,5,7,9,11,13,15]
#while 1
#chrc = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	bucket = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
#	for i in 0..psize
#		pearson[i]=rand(256)
#	end
	file=File.new("t.1", "r")

#	while line=(file.gets).chomp
	line="xyzzy"
		hash=line.length
		for i in 1..(line.length)
#			hash = hash^pearson[(line[i]&(psize))]
#			foo = (hash&psize)
			hash = hash^line[i]
#			foo = hash^line[i]
#			hash = hash^pearson[foo&psize]^pearson[psize-((line[i]-i)&psize)]
#			hash = hash^line[i]^nybroll[i&15]
#			hash = (hash&255)
		end
		h1 = (hash&240)/16
		hash = h1^(hash&15)
		bucket[hash] = bucket[hash]+1
#		print "#{hexout[hash,1]}"
	end

	for i in 0..15
		print "#{bucket[i]} "
	end

foo = <<END
	off=0
	for i in 0..15
			fudge = (bucket[i]-17).abs
			off = off+fudge
			off = off+fudge*2   if fudge > 3
			off = off+fudge*7   if fudge > 6
	end

	if (pearsonmin > off)
		bestpearson = pearson
		pearsonmin = off
		off = 0
		for i in 0..15
			print "#{bucket[i]} "
			fudge = (bucket[i]-17).abs
			off = off+fudge
			off = off+fudge*2   if fudge > 3
			off = off+fudge*7   if fudge > 6
		end
		puts "#{off}"
		for i in 0..psize
			print "#{pearson[i]} "
#			puts "#{i} #{pearson[i]} #{bestpearson[i]} #{(bestpearson[i]-17).abs}"
		end
		puts
	end
#	for i in 0...(chrc.size)
#		if chrc[i]>0
#			print "#{i}_#{chrc[i]} "
#		end
#	end
#	puts
	file.close
end
puts off
END
