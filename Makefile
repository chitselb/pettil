# RUBY = /home/chitselb/.rvm/rubies/ruby-2.1.2/bin/ruby
RUBY = /home/chitselb/.rvm/rubies/ruby-2.2.1/bin/ruby
# RUBY = /home/chitselb/.rbenv/shims/ruby
SHELL = /bin/bash

all:  clean pettil launch tiddlypettil 

compile: clean pettil tiddlypettil

doc: tiddlypettil publish

clean:
	rm -rf ./tmp/
	mkdir ./tmp/

launch: clean pettil
	xpet -verbose -Crtcpalette /home/chitselb/.vice/PET/chitselb.vpl -1 tapes/x.tap -Crtcfilter 0 -warp -moncommand ./tmp/pettil.mon ./tmp/pettil.obj &

pettil:
	echo . Phase I
	echo . . . . Building PETTIL core = PETTIL-CORE.OBJ
	cd ./src/ && xa ./pettil-core.a65 -o ../tmp/pettil-core.obj -e ../tmp/pettil-core.err -l ../tmp/pettil-core.lab
	echo . . . . Generating core labels = PETTIL-CORE.DEF
	$(RUBY) xap.rb
	echo . Phase II
	echo . . . . Building PETTIL temporary dictionary = PETTIL-TDICT.OBJ
	cd ./src/ && xa ./pettil-tdict.a65 -o ../tmp/pettil-tdict.obj -e ../tmp/pettil-tdict.err -l ../tmp/pettil-tdict.lab
	echo . Phase III
	echo . . . . Generating combined symbol table = PETTIL.SYM
	$(RUBY) xap.rb
	echo . . . . Packing PETTIL.OBJ binary = PETTIL-CORE.OBJ + PETTIL-TDICT.OBJ + PETTIL.SYM
	ls -la ./tmp/pettil-core.obj
	ls -la ./tmp/pettil-tdict.obj
	ls -la ./tmp/pettil.sym
	cat ./tmp/pettil-core.obj ./tmp/pettil-tdict.obj ./tmp/pettil.sym > ./tmp/pettil.obj
	ls -la ./tmp/pettil.obj
	sort ./tmp/pettil.mon > ./tmp/t.t
	if [ -e ./pettil.dbg ]; then cat ./pettil.dbg >> ./tmp/t.t; fi
	mv ./tmp/t.t ./tmp/pettil.mon

tiddlypettil:
	echo . Phase IV
	echo . . . . Building docs/tiddlypettil.html
	mkdir -p ./tmp/tiddlypettil/tiddlers
	cp ./docs/statictiddlers/tiddlywiki.info ./tmp/tiddlypettil/
	cp ./docs/statictiddlers/*.tid ./tmp/tiddlypettil/tiddlers/
	export MMDDYY=`date +"documentation generated %Y-%m-%d"`;sed "s/datetimestamp/$${MMDDYY}/" <./docs/statictiddlers/AboutPETTIL.tid >./tmp/tiddlypettil/tiddlers/AboutPETTIL.tid
	cd ./tmp/tiddlypettil/ && tiddlywiki --load ../pettil.json --rendertiddler $$:/core/save/all tiddlypettil.html text/plain
	mv -v ./tmp/tiddlypettil/output/tiddlypettil.html ./docs/tiddlypettil.html

publish:
	scp ./docs/tiddlypettil.html www-puri:chitselb.com/current/public/files/
