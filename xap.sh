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
alias pettil='xpet -moncommand pettil.mon pettil.obj > /dev/null'
#
#



[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..."




# first build the PETTIL core from $0400..COLD
echo . Phase I
echo . . . . Building PETTIL core = PETTIL-CORE.OBJ
xa pettil-core.a65 -o pettil-core.obj -e pettil-core.err -l pettil-core.lab
#
# a ruby script scans the source and creates
# * a symbol table for the temporary dictionary
# * a symbol table for the monitor (pettil.mon)
# * a complete symbol table for both dictionaries
echo . . . . Generating core labels = PETTIL-CORE.DEF
ruby symtab.rb
#
# build the temporary dictionary with the PETTIL development tools
echo . Phase II
echo . . . . Building PETTIL temporary dictionary = PETTIL-TDICT.OBJ
#xa -x modules/pettil-tdict.a65
xa modules/pettil-tdict.a65 -o modules/pettil-tdict.obj -e modules/pettil-tdict.err -l modules/pettil-tdict.lab
#
# run this again after compiling the upper dictionary for all labels
echo . Phase III
echo . . . . Generating combined symbol table = PETTIL.SYM
ruby symtab.rb
#
# assemble the binary pieces
echo . . . . Packing PETTIL.OBJ binary = PETTIL-CORE.OBJ + PETTIL-TDICT.OBJ + PETTIL.SYM
ls -la pettil-core.obj
ls -la modules/pettil-tdict.obj
ls -la pettil.sym
cat pettil-core.obj modules/pettil-tdict.obj pettil.sym > pettil.obj
ls -la pettil.obj
#
# build the tiddlywiki
echo . Phase IV
echo . . . . Building docs/tiddlypettil.html
rm -rf ./docs/tiddlypettil
mkdir ./docs/tiddlypettil/
cd ./docs/tiddlypettil/
cp ../tiddlywiki.info ./
mkdir tiddlers
cp ../*.tid tiddlers/
tiddlywiki --load ../../junk/pettil.json --rendertiddler $:/core/save/all tiddlypettil.html text/plain  >/dev/null
cd ../..
mv ./docs/tiddlypettil/output/tiddlypettil.html docs/tiddlypettil.html
# copy a fresh tiddly up to http://chitselb.com/files because github doesn't like hosting single files
scp docs/tiddlypettil.html www-puri:chitselb.com/current/public/files/
#
# clean up junk
echo . . . . Cleaning up \(look in junk/ folder\)
mv modules/*.obj modules/*.err *.lab modules/*.lab pettil-core.obj pettil-core.def *.err pettil.sym ./junk/
#
# run it
sort pettil.mon > t.t
if [ -e pettil.dbg ]; then
	cat pettil.dbg >> t.t
fi
mv t.t pettil.mon
#
if [ "$1" != "--norun" ]; then
echo . . . . Launching PETTIL
xpet -moncommand pettil.mon pettil.obj >/dev/null
fi
