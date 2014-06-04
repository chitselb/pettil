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
alias pettil='xpet -moncommand pettil.mon pettil.obj'
#
#



[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..."




# first build the core from $0400..COLD
echo .
echo . . . . Building PETTIL core = PETTIL.OBJ
xa -x pettil-core.a65
#
# a ruby script scans the source and creates
# * a symbol table for the temporary dictionary
# * a symbol table for the monitor (pettil.mon)
# * a complete symbol table for both dictionaries
echo .
echo . . . . Generating core symbol table
ruby symtab.rb
#
# build the temporary dictionary
echo .
echo . . . . Building PETTIL temporary dictionary = PETTIL-TDICT.OBJ
xa -x modules/pettil-tdict.a65
#
# run this again after compiling the upper dictionary for all labels
echo .
echo . . . . Generating combined symbol table = PETTIL.SYM
ruby symtab.rb
#
# assemble the binary pieces
echo . . . . Packing PETTIL.OBJ binary = PETTIL-CORE.OBJ + PETTIL-TDICT.OBJ + PETTIL.SYM
cat pettil-core.obj modules/pettil-tdict.obj pettil.sym > pettil.obj
#
# clean up junk
echo . . . . Cleaning up \(look in junk/ folder\)
mv modules/*.obj modules/*.err *.lab modules/*.lab pettil-core.obj *.err pettil.sym ./junk/
#
# run it
if [ -e pettil.dbg ]; then
	cat pettil.dbg >> pettil.mon
fi
#
if [ "$1" != "--norun" ]; then
echo . . . . Launching PETTIL
xpet -moncommand pettil.mon pettil.obj
fi
