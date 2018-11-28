# PETTIL Makefile
#
#

SHELL = /bin/bash

#all:  launch tiddlypettil
all:  mypet
#all:	mypet

FORCE:

mypet: FORCE clean
	#                   target# romoptions tdict
	sh ./tools/buildpettil.sh 0 3 6400
	# make a disk, build target# 0 is the default image 'pettil.prg'
	c1541 -attach pettil.d64				\
		-write obj/pettil.prg0 pettil.prg 	\
		-write obj/pettil.prg1			 	\
		-write obj/pettil.prg2			 	\
		-write obj/pettil.prg3				\
		-write tapes/pettilpackets
	/usr/bin/xpet \
		-directory data/PET/ \
		-moncommand obj/pettil.mon0			\
		-warp \
		-config data/x11_chitselb.vicerc \
		-8 chitselb.d64 \
		-9 pettil.d64

supermon: FORCE clean
	sh ./tools/buildpettil.sh 1 3 5E00 0401

micromon: FORCE clean
	sh ./tools/buildpettil.sh 2 3 6400 0401

fast: FORCE clean
	sh ./tools/buildpettil.sh 3 3 6400 0401

cheap: FORCE clean
	sh ./tools/buildpettil.sh 4 3 5E00 0401

pet:
	sh ./tools/buildpettil.sh 5 3 4000 0401

petupgrade: FORCE clean
	sh ./tools/buildpettil.sh 6 3 5E00 0401

pet4: FORCE clean
	sh ./tools/buildpettil.sh 7 3 5E00 0401

pet80: FORCE clean
	sh ./tools/buildpettil.sh 8 3 5E00 0401

vic20: FORCE clean
#	sh ./tools/buildpettil.sh 9 3 5E00 0401   #    +3K only
#	sh ./tools/buildpettil.sh 9 3 5E00 1201   #    +8K|16K|24K|32K
	sh ./tools/buildpettil.sh 9 3 5E00 1001   # 5K unexpanded
	/home/chitselb/Documents/dev/commodore/vice-3.2/src/xvic \
		-directory ./data/VIC20/ \
		-config ./data/sdl2_vic20.vicerc &

c64: FORCE clean
	sh ./tools/buildpettil.sh A 3 5E00 0801

#all:  mypet tiddlypettil
#all:  launchrecord
#all:  thread1 tiddlypettil
#all:  thread1 thread2 tiddlypettil
#all:  thread3 tiddlypettil
#all:  xpeta tiddlypettil
#all:  xpetb tiddlypettil
#all:  xpetc tiddlypettil
#all:  xpetd tiddlypettil
#all:  xpete tiddlypettil
#all:  xpetf tiddlypettil

compile: clean pettil tiddlypettil

doc: tiddlypettil publish

clean:
	rm -rf ./tmp/
	mkdir ./tmp/
	c1541 -format pettil,09 d64 pettil.d64

tiddlypettil:
	echo . Phase IV
	echo . . . . Building docs/tiddlypettil.html
	mkdir -p ./tmp/tiddlypettil/tiddlers
	cd ./docs/images/ && for a in *.png;do echo $${a};echo title: $${a} > ../statictiddlers/$${a}.tid && echo type: image/png >> ../statictiddlers/$${a}.tid&& echo  >> ../statictiddlers/$${a}.tid && base64 -w0 $$a >> ../statictiddlers/$${a}.tid;done && cd ../../
	cp ./docs/statictiddlers/tiddlywiki.info ./tmp/tiddlypettil/
	cp ./docs/statictiddlers/*.tid ./tmp/tiddlypettil/tiddlers/
	export MMDDYY=`date +"documentation generated %Y-%m-%d"`;sed "s/datetimestamp/$${MMDDYY}/" <./docs/statictiddlers/AboutPETTIL.tid >./tmp/tiddlypettil/tiddlers/AboutPETTIL.tid
	cd ./tmp/tiddlypettil/ && ~/.npm-packages/bin/tiddlywiki --load ../pettil.json --rendertiddler $$:/core/save/all tiddlypettil.html text/plain >/dev/null
	mv -v ./tmp/tiddlypettil/output/tiddlypettil.html ./docs/tiddlypettil.html

publish:
	scp ./docs/tiddlypettil.html www-data@puri.chitselb.com:chitselb.com/current/public/files/
#	scp ./docs/tiddlypettil.html www-puri:chitselb.com/current/public/files/
