
SHELL = /bin/bash

all:  launch tiddlypettil
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

thread1: clean pettil pettild64
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x52+288+28 -x \
	/usr/bin/xpet \
		-directory data/PET/ \
		-moncommand t.mon \
		-warp \
		-config data/x11_4032.vicerc &
#		pettil.prg &

thread2: clean pettil pettild64
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x52+288+28 -x \
	/usr/bin/xpet \
		-directory data/PET/ \
		-moncommand t.mon \
		-warp \
		-config data/x11_4032.vicerc &
#		pettil.prg &

thread3: clean pettil pettild64
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x53+290+28 -x \
	/home/chitselb/Documents/dev/commodore/vice-3.2/src/xpet \
		-directory ./data/PET/ \
		-warp \
		-moncommand thread3.mon \
 		-config data/sdl2_chitselb.vicerc &

# native-gtk3
xpeta: clean pettil pettild64
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x53+290+28 -x \
	/home/chitselb/Documents/dev/commodore/3.2vice/g/vice-emu-code/vice/src/xpet \
 		-config /home/chitselb/.config/vice/vicerc \
		-directory ./data/PET/ \
		-warp \
		-moncommand pettil.mon \
 		pettil.prg &

# native-gtk3
xpetb: clean pettil pettild64
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x53+290+28 -x \
	/home/chitselb/Documents/dev/commodore/3.2vice/g/vice-emu-code/vice/src/xpet \
 		-config /home/chitselb/.config/vice/vicerc \
		-directory ./data/PET/ \
		-warp \
		-moncommand pettil.mon \
 		pettil.prg &

# native-gtk3
xpetc: clean pettil pettild64
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x53+290+28 -x \
	/home/chitselb/Documents/dev/commodore/3.2vice/c/vice-3.2/src/xpet \
 		-config /home/chitselb/.config/vice/vicerc \
		-directory ./data/PET/ \
		-warp \
		-moncommand pettil.mon \
 		pettil.prg &

# native-gtk3
xpetd: clean pettil pettild64
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x53+290+28 -x \
	/home/chitselb/Documents/dev/commodore/3.2vice/g/vice-emu-code/vice/src/xpet \
 		-config /home/chitselb/.config/vice/vicerc \
		-directory ./data/PET/ \
		-warp \
		-moncommand pettil.mon \
 		pettil.prg &

# native-gtk3
xpete: clean pettil pettild64
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x53+290+28 -x \
	/home/chitselb/Documents/dev/commodore/3.2vice/g/vice-emu-code/vice/src/xpet \
 		-config /home/chitselb/.config/vice/vicerc \
		-directory ./data/PET/ \
		-warp \
		-moncommand pettil.mon \
 		pettil.prg &

# native-gtk3
#	xfce4-terminal --hide-menubar --hide-borders --geometry=152x53+290+28 -x \
#		-config data/x11_chitselb.vicerc \

xpetf: clean pettil pettild64
	/usr/local/bin/xpet \
		-directory ./data/PET/ \
		-warp \
		-moncommand pettil.mon \
 		pettil.prg &

mypet: clean pettil pettild64
	/usr/bin/xpet \
		-directory data/PET/ \
		-moncommand pettil.mon \
		-warp \
		-config data/x11_chitselb.vicerc \
		pettil.d64

vic20:
	/home/chitselb/Documents/dev/commodore/vice-3.2/src/xvic \
		-directory ./data/VIC20/ \
		-config ./data/sdl2_vic20.vicerc &

xpet8032:
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x49+290+28 -x \
	/home/chitselb/Documents/dev/commodore/vice-3.2/src/xpet \
		-verbose \
		-directory ./data/PET/ \
		-config ./data/sdl2_8032.vicerc &

clean:
	rm -rf ./tmp/
	mkdir ./tmp/

launchrecord: clean pettil pettild64
	/usr/bin/xpet \
		-directory data/PET/ \
		-moncommand pettil.mon \
		-warp \
		-config data/x11_mypet.vicerc \
		pettil.d64

launch: clean pettil pettild64
# gtk3 3.2
#	xfce4-terminal --hide-menubar --hide-borders --geometry=152x49+290+28 -x \
	/home/chitselb/Documents/dev/commodore/vice-3.2/src/xpet \
		-directory data/PET/ \
		-moncommand pettil.mon \
		-config data/x11_chitselb.vicerc &

# gnome-ui 3.1
#	xfce4-terminal --hide-menubar --hide-borders --geometry=152x49+290+28 -x \
	/usr/bin/xpet \
		-directory data/PET/ \
		-moncommand pettil.mon \
		-config data/x11_chitselb.vicerc &

# gnome-ui 3.1
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x52+288+28 -x \
	/usr/bin/xpet \
		-directory data/PET/ \
		-moncommand pettil.mon \
		-warp \
		-config data/x11_4032.vicerc \
		pettil.d64 &
#		-keybuf "dL\x22pettil.prg\x22\x0drun\x0dinfo\x0dvmdump\x0d" &


pettild64:
	c1541 -format pettil,09 d64 pettil.d64
	c1541 -attach pettil.d64 -write pettil.prg

pettil:
#	echo . Phase I
#	echo . . . . Building PETTIL core = PETTIL-CORE.OBJ
	cd ./core/src/ && xa ./pettil-core.a65 \
		-o ../../tmp/pettil-core.obj \
		-e ../../tmp/pettil-core.err \
		-l ../../tmp/pettil-core.lab
#	echo . . . . Generating core labels = PETTIL-CORE.DEF
	ruby ./tools/xap.rb
	ls -la ./tmp/
#	echo . Phase II
#	echo . . . . Building PETTIL temporary dictionary = PETTIL-TDICT.OBJ
	pwd && \
	cd ./studio/src/ && \
	xa ./pettil-studio.a65 \
	  -o ../../tmp/pettil-studio.obj \
	  -e ../../tmp/pettil-studio.err \
	  -l ../../tmp/pettil-studio.lab
#	echo . Phase III
#	echo . . . . Generating combined symbol table = PETTIL.SYM
	ruby ./tools/xap.rb
#	echo . . . . Packing PETTIL.PRG binary = PETTIL-CORE.OBJ + PETTIL-TDICT.OBJ + PETTIL.SYM
	ls -la ./tmp/pettil-core.obj ./tmp/pettil-studio.obj ./tmp/pettil.sym
	cat \
		./tmp/pettil-core.obj \
		./tmp/pettil-studio.obj \
		./tmp/pettil.sym \
		> ./tmp/pettil.prg
	ls -la ./tmp/pettil.prg
	sort ./tmp/pettil.mon > ./tmp/t.t
	if [ -e ./pettil.dbg ]; then cat ./pettil.dbg >> ./tmp/t.t; fi
	mv ./tmp/t.t ./tmp/pettil.mon
	cp -v tmp/pettil.mon tmp/pettil.prg .
#	ls -l ./tmp/*.obj ./tmp/*.sym > ./docs/sizes.txt
	stat -c '%8s %n' tmp/*.obj tmp/*.sym | sed -e 's/tmp\///' > docs/sizes.txt
	cp -v ./tmp/sizes.csv docs/

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
