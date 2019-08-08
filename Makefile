# PETTIL Makefile
#
#

SHELL = /bin/bash
#TARGETS=01234567
TARGETS=01234

#all:  launch tiddlypettil12
#all: clean mkpet mypet vic20
#all: clean mkpet vic20 perturb
#all: pristine remote
all: pristine perturb

remote: mkd64
	scp pettil.d64 samosa:pettil/
	samosa DISPLAY=:0.0 ./pettil/tools/mkperturb

# build a fresh PETTIL from source
mkpettil:
	./tools/mkpettil
#sh ./tools/buildpettil.sh 0     5       6500  0401  # my pet #700251
#sh ./tools/buildpettil.sh 4     32      6500  1201 # VIC20 +01235(all) RAM

# launches PET and a VIC-20
mkpet:
	./tools/mkpet 0 4

# 0 (PET 2001-N #700251)
#           maize & blue
pet:
	./tools/mkpet 0

# 1 (PET 3032 Upgrade ROM)
#           amber
pet3:
	./tools/mkpet 1

# 2 (PET 4032 4.0 ROM)
#           green
pet4:
	./tools/mkpet 2

# 3 (PET 8032 4.0 ROM)
#           green
pet80:
	./tools/mkpet 3

# 4 (VIC-20 expanded)
#           colodore
vic20:
	./tools/mkpet 4

# 5 (C=64)
#           colodore
c64:
	./tools/mkpet 5

# 6 (C128)
#           colodore
c128:
	./tools/mkpet 6

# 7 (Plus/4)
#           colodore
plus4:
	./tools/mkpet 7

# Upgrade ROM, DWW +8k RAM expansion, PicChip
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



# build PETTIL disk images
mkd64: mkpettil
	# first program is PETTIL.PRG for reference machine
	# and also include PETTILPACKETS
	c1541 -attach pettil.d64                                                    \
		-write obj/pettil.prg0 pettil.prg                                       \
		-write tapes/pettilpackets pettilpackets

	TARGETS=04
	# add other targets
	for object in obj/pettil*.prg[${TARGETS}] ; do                              \
        ls -la $$object ;                                                       \
		c1541 -attach pettil.d64 -write $$object ;                              \
    done
	c1541 -attach pettil.d64 -dir

#	foo="XYzzy045"
#	for (( i=0; i<${#foo}; i++ )); do
#	  echo "${foo:$i:1}"
#	done

# clear build output area
clean:
	rm -rf ./tmp/ && mkdir -p ./tmp/perturb
	c1541 -format pettil,09 d81 pettil.d64

# clear build ouput and staging areas
pristine: clean
	rm -rf ./obj/ && mkdir -p ./obj/perturb

# build and perform all feats of testing
perturb: mkd64
	./tools/mkperturb
	./tools/chkperturb
	./tools/lsperturb 0.01

# build documentation
tiddlypettil:
	mkdir -p ./tmp/tiddlypettil/tiddlers
	cd ./doc/images/ && for a in *.png;do echo $${a};echo title: $${a} > ../statictiddlers/$${a}.tid && echo type: image/png >> ../statictiddlers/$${a}.tid&& echo  >> ../statictiddlers/$${a}.tid && base64 -w0 $$a >> ../statictiddlers/$${a}.tid;done && cd ../../
	cp ./doc/statictiddlers/tiddlywiki.info ./tmp/tiddlypettil/
	cp ./doc/statictiddlers/*.tid ./tmp/tiddlypettil/tiddlers/
	export MMDDYY=`date +"documentation generated %Y-%m-%d"`;sed "s/datetimestamp/$${MMDDYY}/" <./doc/statictiddlers/AboutPETTIL.tid >./tmp/tiddlypettil/tiddlers/AboutPETTIL.tid
	cd ./tmp/tiddlypettil/ && ~/.npm-packages/bin/tiddlywiki --load ../pettil.json --rendertiddler $$:/core/save/all tiddlypettil.html text/plain >/dev/null
	mv ./tmp/tiddlypettil/output/tiddlypettil.html ./doc/tiddlypettil.html

# upload PETTIL Tiddlywiki to website
publish:
#	scp ./doc/tiddlypettil.html www-data@puri.chitselb.com:chitselb.com/current/public/files/
#	scp ./doc/tiddlypettil.html www-puri:chitselb.com/current/public/files/

# build and publish PETTIL Tiddlywiki
doc: tiddlypettil
