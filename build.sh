#!/bin/bash
# build.sh
#
# PETTIL build script
# requires ruby, xa65 packages
#
# some handy aliases if we source this script
#
# builds it
alias xap='./build.sh --norun &'
#
# runs it
alias pettil='xpet -moncommand ./tmp/pettil.mon ./tmp/pettil.obj > /dev/null'
#
#
# copy a fresh tiddly up to http://chitselb.com/files because github doesn't like hosting single files
alias publish='scp ./docs/tiddlypettil.html www-puri:chitselb.com/current/public/files/'
#
#



[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..."




# first build the PETTIL core from $0400..COLD
echo . Phase I
echo . . . . Building PETTIL core = PETTIL-CORE.OBJ
rm -rf ./tmp/
mkdir ./tmp/
cd ./src/
xa ./pettil-core.a65 -o ../tmp/pettil-core.obj -e ../tmp/pettil-core.err -l ../tmp/pettil-core.lab
cd ../
#
# a ruby script scans the source and creates
# * a symbol table for the temporary dictionary
# * a symbol table for the monitor (pettil.mon)
# * a complete symbol table for both dictionaries
echo . . . . Generating core labels = PETTIL-CORE.DEF
ruby xap.rb
#
# build the temporary dictionary with the PETTIL development tools
echo . Phase II
echo . . . . Building PETTIL temporary dictionary = PETTIL-TDICT.OBJ
cd ./src/
xa ./pettil-tdict.a65 -o ../tmp/pettil-tdict.obj -e ../tmp/pettil-tdict.err -l ../tmp/pettil-tdict.lab
cd ../
#
# run this again after compiling the upper dictionary for all labels
echo . Phase III
echo . . . . Generating combined symbol table = PETTIL.SYM
ruby xap.rb
#
# assemble the binary pieces
echo . . . . Packing PETTIL.OBJ binary = PETTIL-CORE.OBJ + PETTIL-TDICT.OBJ + PETTIL.SYM
ls -la ./tmp/pettil-core.obj
ls -la ./tmp/pettil-tdict.obj
ls -la ./tmp/pettil.sym
cat ./tmp/pettil-core.obj ./tmp/pettil-tdict.obj ./tmp/pettil.sym > ./tmp/pettil.obj
ls -la ./tmp/pettil.obj
#
sort ./tmp/pettil.mon > ./tmp/t.t
if [ -e ./pettil.dbg ]; then
    cat ./pettil.dbg >> ./tmp/t.t
fi
mv ./tmp/t.t ./tmp/pettil.mon
#
# build the tiddlywiki
echo . Phase IV
echo . . . . Building docs/tiddlypettil.html
mkdir -p ./tmp/tiddlypettil/tiddlers
cp ./docs/statictiddlers/tiddlywiki.info ./tmp/tiddlypettil/
cp ./docs/statictiddlers/*.tid ./tmp/tiddlypettil/tiddlers/
export MMDDYY=`date +"documentation generated %Y-%m-%d"`
sed "s/datetimestamp/${MMDDYY}/" <./docs/statictiddlers/AboutPETTIL.tid >./tmp/tiddlypettil/tiddlers/AboutPETTIL.tid
cd ./tmp/tiddlypettil/
tiddlywiki --load ../pettil.json >/dev/null
tiddlywiki --rendertiddler $:/core/save/all tiddlypettil.html text/plain >/dev/null
cd ../..
mv -v ./tmp/tiddlypettil/output/tiddlypettil.html ./docs/tiddlypettil.html
#
# run it
if [ "$1" != "--norun" ]; then
#echo . . . . Launching PETTIL
xpet -moncommand ./tmp/pettil.mon ./tmp/pettil.obj >/dev/null
fi
