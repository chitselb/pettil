#!/bin/bash
alias xpetp='xpet -moncommand pettil.lab pettil.obj'
alias xap='xa -x pettil.a65;xa pettil.a65;./pettil.sh'
sed 's/^\([_a-zA-Z0-9]*\),\ 0x\(....\).*$/al C\:\2 \.\1/g' < pettil.lab > t.lab
sort t.lab > pettil.lab
rm t.lab
#echo break .cold>>pettil.lab
echo break .xpetp>>pettil.lab
# echo break .foo>>pettil.lab
# echo break .test>>pettil.lab
# echo break .plit>>pettil.lab

