#!/bin/bash
# build a PETTIL.OBJ binary in two sections
#
#
# some handy aliases if we source this script
#
# builds it
alias xap='./xap.sh --norun'
#
# runs it
alias xpetp='xpet -moncommand pettil.mon pettil.obj'
#
# first build the core from $0400..COLD
echo
echo Building PETTIL core
xa -x pettil.a65
#
# a ruby script scans the source and creates
# * a symbol table for the temporary dictionary
# * a symbol table for the monitor (pettil.mon)
# * a complete symbol table for both dictionaries
echo
echo Generating core symbol table
ruby symtab.rb
#
# build the temporary dictionary
echo
echo Building PETTIL temporary dictionary
xa -x modules/pettil-tdict.a65
#
# run this again after compiling the upper dictionary for all labels
echo
echo Generating combined symbol table
ruby symtab.rb
#
# assemble the binary pieces
echo Packing PETTIL.OBJ binary
cat pettil.obj modules/pettil-tdict.obj pettil.sym > t.t
mv t.t pettil.obj
#
# clean up junk
echo Cleaning up \(look in junk/ folder\)
mv modules/pettil-tdict.obj modules/pettil-tdict.err pettil.lab modules/pettil-tdict.lab *.err core_syms.tmp  ./junk/
#
# run it
if [ -e pettil.dbg ]; then
	cat pettil.dbg >> pettil.mon
fi
#
if [ "$1" != "--norun" ]; then
echo Launching PETTIL
xpet -moncommand pettil.mon pettil.obj
fi
