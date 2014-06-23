#!/bin/bash
# xap.sh
#
# PETTIL build script
# requires ruby, xa65 packages
#
# some handy aliases if we source this script
#
# builds it
alias xap='./xap.sh --norun'
#
# runs it
alias pettil='xpet -moncommand ./build/pettil.mon ./build/pettil.obj > /dev/null'
#
#



[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..."




# first build the PETTIL core from $0400..COLD
echo . Phase I
echo . . . . Building PETTIL core = PETTIL-CORE.OBJ
rm -rf ./build/
mkdir ./build/
cd ./src/
xa ./pettil-core.a65 -o ../build/pettil-core.obj -e ../build/pettil-core.err -l ../build/pettil-core.lab
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
xa ./pettil-tdict.a65 -o ../build/pettil-tdict.obj -e ../build/pettil-tdict.err -l ../build/pettil-tdict.lab
cd ../
#
# run this again after compiling the upper dictionary for all labels
echo . Phase III
echo . . . . Generating combined symbol table = PETTIL.SYM
ruby xap.rb
#
# assemble the binary pieces
echo . . . . Packing PETTIL.OBJ binary = PETTIL-CORE.OBJ + PETTIL-TDICT.OBJ + PETTIL.SYM
ls -la ./build/pettil-core.obj
ls -la ./build/pettil-tdict.obj
ls -la ./build/pettil.sym
cat ./build/pettil-core.obj ./build/pettil-tdict.obj ./build/pettil.sym > ./build/pettil.obj
ls -la ./build/pettil.obj
#
# build the tiddlywiki
echo . Phase IV
echo . . . . Building docs/tiddlypettil.html
mkdir -p ./build/tiddlypettil/tiddlers
cp ./docs/statictiddlers/tiddlywiki.info ./build/tiddlypettil/
cp ./docs/statictiddlers/*.tid ./build/tiddlypettil/tiddlers/
cd ./build/tiddlypettil/
#tiddlywiki --load ../pettil.json 
#tiddlywiki --rendertiddler $:/core/save/all tiddlypettil.html text/plain
cd ../..
#mv -v ./build/tiddlypettil/output/tiddlypettil.html ./docs/tiddlypettil.html
# copy a fresh tiddly up to http://chitselb.com/files because github doesn't like hosting single files
#scp ./docs/tiddlypettil.html www-puri:chitselb.com/current/public/files/
#
# run it
sort ./build/pettil.mon > ./build/t.t
if [ -e ./pettil.dbg ]; then
	cat ./pettil.dbg >> ./build/t.t
fi
mv ./build/t.t ./build/pettil.mon
#
if [ "$1" != "--norun" ]; then
#echo . . . . Launching PETTIL
xpet -moncommand ./build/pettil.mon ./build/pettil.obj >/dev/null
fi
