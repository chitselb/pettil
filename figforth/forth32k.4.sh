#!/bin/bash
# forth32k.4.sh
#alias xpetp='xpet -moncommand pettil.lab pettil.obj'
#alias xap='xa -x pettil.a65;xa pettil.a65;./pettil.sh'
sed 's/^\([_a-zA-Z0-9]*\),\ 0x\(....\).*$/al C\:\2 \.\1/g' < forth32k.4.lab | sort > t.lab
mv t.lab forth32k.4.lab
echo "watch .INTERPRET-2">>forth32k.4.lab

# This ROM routine tests the STOP key and writes to $0010.  Very bad!
# echo break f935>> forth32k.4.lab
