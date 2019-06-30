# PETTIL Makefile
#
#

SHELL = /bin/bash

#all:  launch tiddlypettil
#all: clean mkpet mypet vic20
#all: clean mkpet vic20 perturb
#~
all: pristine perturb

# build a fresh PETTIL from source
#~
mkpettil:
	echo +++ PETTIL
	./tools/mkpettil
#sh ./tools/buildpettil.sh 0     5       6500  0401  # my pet #700251
#sh ./tools/buildpettil.sh 4     32      6500  1201 # VIC20 +01235(all) RAM

# `mkpet` build targets
#
#id target  look
# 0 pet   	maize & blue
# 1 pet3 	amber
# 2 pet4 	green
# 3 pet80 	green
# 4 vic20 	??
# 5 c64 	??
# 6 c128 	??
# 7 plus4 	??

# the general form, launches PET and a VIC-20
#~
mkpet: mkd64
	echo +++ MKPET
	./tools/mkpet 0 4

# 0 (PET 2001-N #700251)
#~
pet: mkd64
	./tools/mkpet 0

# 1
#~ use sdl2_ config
#~
pet3: mkd64
	echo +++ PET3
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command=" 													\
	/usr/bin/xpet                                                               \
		-directory data/PET/ -moncommand obj/pettil.mon3						\
		-config data/x11_pet3.vicerc 											\
		-iosize 2048 -petdww -petdwwimage data/dwwimage.dww 					\
		-warp -8 chitselb.d64 -9 pettil.d64" &

# 2
#~ use sdl2_ config
#~
pet4: mkd64
	echo +++ PET4
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command="xpet                                              \
		-directory data/PET/ -moncommand obj/pettil.mon3						\
		-model 4032																\
			+confirmexit														\
			-CRTChwscale 														\
			-CRTCfilter 0 														\
			-virtualdev 														\
		-iosize 2048 -petdww -petdwwimage data/dwwimage.dww 					\
		-warp -8 chitselb.d64 -9 pettil.d64" &

# 3
#~ use sdl2_ config
#~
pet80: mkd64
	echo +++ PET80
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

# 4
#~
vic20: mkd64
	echo +++ VIC20
	xfce4-terminal --command="xvic		\
		-moncommand obj/pettil.mon4		\
		-config data/sdl2_chitselb.vicerc \
		-8 chitselb.d64		 			\
		-9 pettil.d64					\
		-warp"

# 5
#~ use sdl2_ config
#~
c64: mkd64
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command=" 													\
	/usr/bin/x64                                                                \
		-directory data/C64/ -moncommand obj/pettil.mon5						\
		-config data/gtk3_c64.vicerc 	 										\
		-warp -8 chitselb.d64 -9 pettil.d64" &

# 6
#~ use sdl2_ config
#~
c128: mkd64
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command=" 													\
	/usr/bin/x64                                                                \
		-directory data/C64/ -moncommand obj/pettil.mon5						\
		-config data/gtk3_c64.vicerc 	 										\
		-warp -8 chitselb.d64 -9 pettil.d64" &

# 7
#~ use sdl2_ config
#~
plus4:
	cp data/my.dww data/dwwimage.dww
	xfce4-terminal --command="xplus4 \
		-directory data/PLUS64/ -moncommand obj/pettil.mon5						\
		-config data/gtk3_c64.vicerc 	 										\
		-warp -8 chitselb.d64 -9 pettil.d64" &

# Upgrade ROM, DWW +8k RAM expansion, PicChip
#~ use sdl2_ config
#~
petpic:
	xfce4-terminal 																\
                --hide-menubar 													\
                --hide-borders 													\
                --geometry=152x53+290+28	 									\
	-x "/usr/local/bin/xpet                                                     \
		-directory data/PET/ -moncommand obj/pettil.mon1						\
		-config data/gtk3_upgrade.vicerc 										\
		-rom9 data/MYNR90_MicroMon.bin                                          \
		-romA data/MYNRa0_picchip_MMpl_DOS.bin                                  \
		-warp -8 chitselb.d64 -9 pettil.d64" &



# build and perform all feats of testing
#~
perturb: mkpettil
	./tools/mkperturb
#	at now -f tools/mkperturb

#~
mkd64: mkpettil
	c1541 -attach pettil.d64													\
		-write obj/pettil.prg0 pettil.prg 										\
		-write tapes/pettilpackets

	# add other targets
	for object in obj/pettil*.prg* ; do 											\
        ls -la $$object ; 														\
		c1541 -attach pettil.d64 -write $$object ;								\
    done

#~
compile: clean pettil tiddlypettil

#~
doc: tiddlypettil publish

#~
clean:
	rm -rf ./tmp/ && mkdir -p ./tmp/perturb
	c1541 -format pettil,09 d64 pettil.d64

#~
pristine: clean
	rm -rf ./obj/ && mkdir -p ./obj/perturb

#~
tiddlypettil:
	echo +++ TIDDLYPETTIL
	echo . Phase IV
	echo . . . . Building doc/tiddlypettil.html
	mkdir -p ./tmp/tiddlypettil/tiddlers
	cd ./doc/images/ && for a in *.png;do echo $${a};echo title: $${a} > ../statictiddlers/$${a}.tid && echo type: image/png >> ../statictiddlers/$${a}.tid&& echo  >> ../statictiddlers/$${a}.tid && base64 -w0 $$a >> ../statictiddlers/$${a}.tid;done && cd ../../
	cp ./doc/statictiddlers/tiddlywiki.info ./tmp/tiddlypettil/
	cp ./doc/statictiddlers/*.tid ./tmp/tiddlypettil/tiddlers/
	export MMDDYY=`date +"documentation generated %Y-%m-%d"`;sed "s/datetimestamp/$${MMDDYY}/" <./doc/statictiddlers/AboutPETTIL.tid >./tmp/tiddlypettil/tiddlers/AboutPETTIL.tid
	cd ./tmp/tiddlypettil/ && ~/.npm-packages/bin/tiddlywiki --load ../pettil.json --rendertiddler $$:/core/save/all tiddlypettil.html text/plain >/dev/null
	mv -v ./tmp/tiddlypettil/output/tiddlypettil.html ./doc/tiddlypettil.html

#~
publish:
	scp ./doc/tiddlypettil.html www-data@puri.chitselb.com:chitselb.com/current/public/files/
#	scp ./doc/tiddlypettil.html www-puri:chitselb.com/current/public/files/
