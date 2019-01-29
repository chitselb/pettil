# PETTIL Makefile
#
#

SHELL = /bin/bash

#all:  launch tiddlypettil
all: clean mkpet mypet vic20

mkpet:
	./tools/mkpet

	c1541 -attach pettil.d64													\
		-write obj/pettil.prg0 pettil.prg 										\
		-write tapes/pettilpackets

	# add other targets
	for object in obj/pettil.prg* ; do 											\
        echo $$object ;															\
		c1541 -attach pettil.d64 -write $$object ;								\
        ls -la $$object ; 														\
    done

testupgradepet:
	~/bin/xpet                                                                  \
		-directory data/PET/ -moncommand obj/pettil.mon2						\
		-config data/gtk3_upgrade.vicerc 										\
		-rom9 data/MYNR90_MicroMon.bin                                          \
		-romA data/MYNRa0_picchip_MMpl_DOS.bin                                  \
		-warp -8 chitselb.d64 -9 pettil.d64

pet3:
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command=" 													\
	/usr/bin/xpet                                                               \
		-directory data/PET/ -moncommand obj/pettil.mon0						\
		-config data/x11_pet3.vicerc 											\
		-iosize 2048 -petdww -petdwwimage data/dwwimage.dww 					\
		-warp -8 chitselb.d64 -9 pettil.d64" &

mypet:
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command=" 													\
	/usr/bin/xpet                                                               \
		-directory data/PET/ -moncommand obj/pettil.mon1						\
		-config data/gtk3_chitselb.vicerc 										\
		-iosize 2048 -petdww -petdwwimage data/dwwimage.dww 					\
		-warp -8 chitselb.d64 -9 pettil.d64" &

pet4:
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command=" 													\
	/usr/bin/xpet                                                               \
		-directory data/PET/ -moncommand obj/pettil.mon2						\
		-model 4032																\
			+confirmexit														\
			-CRTChwscale 														\
			-CRTCfilter 0 														\
			-virtualdev 														\
		-iosize 2048 -petdww -petdwwimage data/dwwimage.dww 					\
		-warp -8 chitselb.d64 -9 pettil.d64" &

pet80:
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command=" 													\
	/usr/bin/xpet                                                               \
		-directory data/PET/ -moncommand obj/pettil.mon2						\
		-model 8032																\
			+confirmexit														\
			-CRTChwscale 														\
			-CRTCfilter 0 														\
			-virtualdev 														\
		-iosize 2048 -petdww -petdwwimage data/dwwimage.dww 					\
		-warp -8 chitselb.d64 -9 pettil.d64" &

vic20:
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command=" 													\
	/usr/bin/xvic                                                               	\
    -directory data/VIC20/ -moncommand obj/pettil.mon4            				\
    -config data/gtk3_vic.vicerc         						                \
    -warp -8 chitselb.d64 -9 pettil.d64" &

c64:
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command=" 													\
	/usr/bin/x64                                                                \
		-directory data/C64/ -moncommand obj/pettil.mon5						\
		-config data/gtk3_c64.vicerc 	 										\
		-warp -8 chitselb.d64 -9 pettil.d64" &

petpic:
	xfce4-terminal --command=" 													\
	/usr/local/bin/xpet                                                         \
		-directory data/PET/ -moncommand obj/pettil.mon1						\
		-config data/gtk3_upgrade.vicerc 										\
		-rom9 data/MYNR90_MicroMon.bin                                          \
		-romA data/MYNRa0_picchip_MMpl_DOS.bin                                  \
		-warp -8 chitselb.d64 -9 pettil.d64" &

compile: clean pettil tiddlypettil

doc: tiddlypettil publish

clean:
	rm -rf ./tmp/
	mkdir -v ./tmp/
	c1541 -format pettil,09 d64 pettil.d64

pristine: clean
	rm -rf ./obj/
	mkdir -v ./obj/

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
