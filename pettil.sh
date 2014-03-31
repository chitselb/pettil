#!/bin/bash
# pettil.sh
alias xpetp='xpet -moncommand pettil.lab pettil.obj'
alias xap='xa -x pettil.a65;xa pettil.a65;./pettil.sh'
sed 's/^\([_a-zA-Z0-9]*\),\ 0x\(....\).*$/al C\:\2 \.\1/g' < pettil.lab | sort > t.lab
mv t.lab pettil.lab
echo break .BK>>pettil.lab
echo break .PULL>>pettil.lab
echo break .npfind>>pettil.lab
echo break .pfind>>pettil.lab
#echo break .cold>>pettil.lab
#echo watch store .userarea .setbrk>>pettil.lab
#echo break .cold>>pettil.lab
#echo break .xyzzy>>pettil.lab
#echo break ._pdq>>pettil.lab
#echo break ._interpret>>pettil.lab
#echo break .nexto>>pettil.lab
#echo break .exit>>pettil.lab

# This ROM routine tests the STOP key and writes to $0010.  Very bad!
# echo break f935>> pettil.lab
