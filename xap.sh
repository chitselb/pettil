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
alias pettil='xpet -moncommand pettil.mon pettil.obj'
#
#



[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..."




# first build the core from $0400..COLD
echo . Phase I
echo . . . . Building PETTIL core = PETTIL-CORE.OBJ
xa -x pettil-core.a65
#
# a ruby script scans the source and creates
# * a symbol table for the temporary dictionary
# * a symbol table for the monitor (pettil.mon)
# * a complete symbol table for both dictionaries
echo . . . . Generating core labels = PETTIL-CORE.DEF
ruby symtab.rb
#
# build the temporary dictionary
echo .
echo . Phase II
echo . . . . Building PETTIL temporary dictionary = PETTIL-TDICT.OBJ
xa -x modules/pettil-tdict.a65
#
# run this again after compiling the upper dictionary for all labels
echo .
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
# clean up junk
echo . . . . Cleaning up \(look in junk/ folder\)
mv modules/*.obj modules/*.err *.lab modules/*.lab pettil-core.obj *.err pettil.sym ./junk/
#
# run it
if [ -e pettil.dbg ]; then
	cat pettil.dbg pettil.mon | sort > t.t
	mv t.t pettil.mon
fi
#
if [ "$1" != "--norun" ]; then
echo . . . . Launching PETTIL
xpet -moncommand pettil.mon pettil.obj
fi
