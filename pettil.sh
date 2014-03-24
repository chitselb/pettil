#!/bin/bash
# pettil.sh
alias xpetp='xpet -moncommand pettil.lab pettil.obj'
alias xap='xa -x pettil.a65;xa pettil.a65;./pettil.sh'
sed 's/^\([_a-zA-Z0-9]*\),\ 0x\(....\).*$/al C\:\2 \.\1/g' < pettil.lab > t.lab
sort t.lab > pettil.lab
rm t.lab
echo break .cold>>pettil.lab
#echo break ._query>>pettil.lab
echo break ._interpret>>pettil.lab
echo break .foo>>pettil.lab
echo break .bar>>pettil.lab
#echo break f563>>pettil.lab
#echo break .cold>>pettil.lab
#echo break .nexto>>pettil.lab
#echo break .nexto>>pettil.lab
#echo "disable 1">>pettil.lab
#echo break .exit>>pettil.lab
#echo "disable 2">>pettil.lab
#echo break .SW16B>>pettil.lab
#echo "disable 3">>pettil.lab
#echo break .NUL>>pettil.lab
#echo break .SW16>>pettil.lab
# echo break .foo>>pettil.lab
# echo break .test>>pettil.lab
# echo break .plit>>pettil.lab

# This ROM routine tests the STOP key and writes to $0010.  Very bad!
# echo break f935>> pettil.lab
