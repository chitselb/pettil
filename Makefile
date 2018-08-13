
SHELL = /bin/bash

all:  clean pettil launch # tiddlypettil

compile: clean pettil tiddlypettil

doc: tiddlypettil publish

clean:
	rm -rf ./tmp/
	mkdir ./tmp/

hhgttg:
	xpet -config chitselb.xpet.v32
#	xfce4-terminal --hide-menubar --hide-borders --geometry=152x49+290+28 -x \

launch: clean pettil
# ~/Documents/dev/commodore/vice-3.2/src/
	pwd
	xfce4-terminal --hide-menubar --hide-borders --geometry=152x49+290+28 -x \
	/usr/local/bin/xpet \
		-directory data/PET/ \
		-config data/chitselb.xpet &
#		-CRTChwscale \
#		-CRTCfilter 2 \
#		-verbose \
#		-1 ../tapes/j.tap \
#		-moncommand pettil.mon \
#		-warp \
#		-monlog pettil-mon.log \
#		-verbose \
#	pettil.prg \
#		-logfile pettil-xpet.log \

#	/usr/local/bin/xpet \
		-verbose \
		-1 ../tapes/2017-02.tap \
		-moncommand pettil.mon \
		-warp \
	pettil.prg &
#	cd ./tmp  &&  /usr/local/bin/xpet \
		-verbose \
		-1 ../tapes/2017-02.tap \
		-moncommand pettil.mon \
		-warp \
	pettil.prg &
#	cd ./tmp  &&  /usr/bin/xpet       \
		-verbose \
		-1 ../tapes/2017-02.tap \
		-moncommand pettil.mon \
		-warp \
	pettil.prg &

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
