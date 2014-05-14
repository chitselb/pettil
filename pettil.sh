#!/bin/bash
# pettil.sh
alias xpetp='xpet -moncommand pettil.lab pettil.obj'
alias xap='xa -x pettil.a65;xa pettil.a65;./pettil.sh'
sed 's/^\([_a-zA-Z0-9]*\),\ 0x\(....\).*$/al C\:\2 \.\1/g' < pettil.lab | sort > t.lab
mv t.lab pettil.lab
echo break .nexto>>pettil.lab	# debugging secondaries
echo "disable 1">>pettil.lab
echo break .exit>>pettil.lab	# debugging secondaries
echo "disable 2">>pettil.lab
#echo "watch store 2 3">>pettil.lab	# UP
echo break .xyzzy>>pettil.lab
echo break ._block>>pettil.lab
echo break .rlencode>>pettil.lab
echo break .rldecode>>pettil.lab
#echo break .wrapstore>>pettil.lab
#echo break .dminus>>pettil.lab

#echo "disable 3">>pettil.lab
#echo "disable 4">>pettil.lab

# This ROM routine tests the STOP key and writes to $0010.  Very bad!
echo break f940>> pettil.lab
