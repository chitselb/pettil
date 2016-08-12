rd -recurse tmp
mkdir tmp
cd src
xa pettil-core.a65 -o ../tmp/pettil-core.obj -e ../tmp/pettil-core.err -l ../tmp/pettil-core.lab
cd ..
ruby xap.rb
cd src
xa ./pettil-tdict.a65 -o ../tmp/pettil-tdict.obj -e ../tmp/pettil-tdict.err -l ../tmp/pettil-tdict.lab
cd ..
ruby xap.rb
cd tmp
copy/y/b pettil-core.obj+pettil-tdict.obj+pettil.sym  pettil.obj
type pettil.mon | sort >t.t
copy/y t.t+..\pettil.dbg pettil.mon
rem c1541 -format pettil,pt d64 pettil.d64 -attach pettil.d64 -write pettil.obj pettil
cd ..
mkdir -p ./tmp/tiddlypettil/tiddlers
copy .\docs\statictiddlers\tiddlywiki.info .\tmp\tiddlypettil\
copy .\docs\statictiddlers\*.tid .\tmp\tiddlypettil\tiddlers\
set mydate=doc generated %date:~10,4%-%date:~4,2%-%date:~7,2%
sed "s/datetimestamp/%mydate%/" ./docs/statictiddlers/AboutPETTIL.tid >./tmp/tiddlypettil/tiddlers/AboutPETTIL.tid
cd .\tmp\tiddlypettil
tiddlywiki --load ../pettil.json --output ../../docs/ --rendertiddler $:/core/save/all tiddlypettil.html text/plain 
cd ..\..
