#!/bin/bash
# pettil.sh
alias xpetp='xpet -moncommand pettil.lab pettil.obj'
alias xap='xa -x pettil.a65;xa pettil.a65;./pettil.sh'
sed 's/^\([_a-zA-Z0-9]*\),\ 0x\(....\).*$/al C\:\2 \.\1/g' < pettil.lab | sort > t.lab
mv t.lab pettil.lab
echo break ._interpret>>pettil.lab
#echo break .cold>>pettil.lab
#echo break .strcmp16>>pettil.lab
#echo break .opfind>>pettil.lab
#echo break .pfind>>pettil.lab
#echo break .disp1>>pettil.lab
#echo break .disp2>>pettil.lab
#echo "disable 3">>pettil.lab
#echo "disable 4">>pettil.lab
#echo break .getpstack>>pettil.lab
#echo break .putpstack>>pettil.lab
#echo watch store .userarea .setbrk>>pettil.lab
#echo break .cold>>pettil.lab
#echo break .xyzzy>>pettil.lab
#echo break .plugh>>pettil.lab
#echo break ._pdq>>pettil.lab
#echo break ._interpret>>pettil.lab
#echo break .nexto>>pettil.lab
#echo break .exit>>pettil.lab

# This ROM routine tests the STOP key and writes to $0010.  Very bad!
# echo break f935>> pettil.lab
