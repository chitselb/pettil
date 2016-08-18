rd -recurse tmp
mkdir tmp
cd tmp
mkdir tiddlypettil
cd tiddlypettil
mkdir tiddlers
cd ..\..\src
xa pettil-core.a65 -o ../tmp/pettil-core.obj -e ../tmp/pettil-core.err -l ../tmp/pettil-core.lab
if %errorlevel% neq 0 exit /b %errorlevel%
cd ..
ruby xap.rb
cd src
xa ./pettil-tdict.a65 -o ../tmp/pettil-tdict.obj -e ../tmp/pettil-tdict.err -l ../tmp/pettil-tdict.lab
if %errorlevel% neq 0 exit /b %errorlevel%
cd ..
ruby xap.rb
cd tmp
copy/y/b pettil-core.obj+pettil-tdict.obj+pettil.sym  pettil.obj
type pettil.mon | sort >t.t
copy/y t.t+..\pettil.dbg pettil.mon
rem c1541 -format pettil,pt d64 pettil.d64 -attach pettil.d64 -write pettil.obj pettil
set f=pettil-core.obj
for /F "tokens=4* delims= " %%A IN ('DIR %f% /-C /N ^| FIND /I "%f%"') do set S=        %%A
echo %S:~-8% %f%> ..\docs\sizes.txt
set f=pettil.obj
for /F "tokens=4* delims= " %%A IN ('DIR %f% /-C /N ^| FIND /I "%f%"') do set S=        %%A
echo %S:~-8% %f%>> ..\docs\sizes.txt
set f=pettil-tdict.obj
for /F "tokens=4* delims= " %%A IN ('DIR %f% /-C /N ^| FIND /I "%f%"') do set S=        %%A
echo %S:~-8% %f%>> ..\docs\sizes.txt
set f=pettil.sym
for /F "tokens=4* delims= " %%A IN ('DIR %f% /-C /N ^| FIND /I "%f%"') do set S=        %%A
echo %S:~-8% %f%>> ..\docs\sizes.txt
cd ..
mkdir -p ./tmp/tiddlypettil/tiddlers
copy .\docs\statictiddlers\tiddlywiki.info .\tmp\tiddlypettil\
copy .\docs\statictiddlers\*.tid .\tmp\tiddlypettil\tiddlers\ >NUL
set mydate=doc generated %date:~10,4%-%date:~4,2%-%date:~7,2%
sed "s/datetimestamp/%mydate%/" ./docs/statictiddlers/AboutPETTIL.tid >./tmp/tiddlypettil/tiddlers/AboutPETTIL.tid
cd .\tmp\tiddlypettil & tiddlywiki --load ../pettil.json --output ../../docs/ --rendertiddler $:/core/save/all tiddlypettil.html text/plain >NUL & cd ..\..
