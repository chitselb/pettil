#!/bin/bash
# pettil.sh

# general purpose shell script for PETTIL development builds
# usage:
#
# to get the xap (build it) and xpetp (run it) aliases
# $ source ./pettil.sh
#
# 
alias xpetp='xpet -moncommand pettil.mon pettil.obj'
alias xap='./xap.sh --norun'

# make the symbol list for the xpet monitor
sed 's/^\([_a-zA-Z0-9]*\),\ 0x\(....\).*$/al C\:\2 \.\1/g' < pettil.lab | sort > pettil.mon

echo break .nexto>>pettil.mon	# debugging secondaries
echo "disable 1">>pettil.mon
echo break .exit>>pettil.mon	# debugging secondaries
echo "disable 2">>pettil.mon
#echo "watch store 2 3">>pettil.mon	# UP
echo break .ice>>pettil.mon
echo break .xyzzy>>pettil.mon
#echo break ._block>>pettil.mon
#echo break ._jiffyfetch>>pettil.mon
#echo break .rlencode>>pettil.mon
#echo break .rldecode>>pettil.mon
#echo break .wrapstore>>pettil.mon
#echo break .dminus>>pettil.mon

#echo "disable 3">>pettil.mon
#echo "disable 4">>pettil.mon

# This ROM routine tests the STOP key and writes to $0010.  Very bad!
echo break f940>> pettil.mon
