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
echo break ._sharp>>pettil.lab
#echo break .boyd>>pettil.lab
#echo break .TOBR>>pettil.lab
#echo break .SW16>>pettil.lab
#echo break .RTN>>pettil.lab
#echo break .RS>>pettil.lab
#echo break .NXT>>pettil.lab
#echo break .PUSH>>pettil.lab
#echo break .PULL>>pettil.lab
#echo break .EXT>>pettil.lab
#echo break .BR>>pettil.lab
#echo break .BS>>pettil.lab
#echo break .BNC>>pettil.lab
#echo break .BC>>pettil.lab
#echo break .BP>>pettil.lab
#echo break .BM>>pettil.lab
#echo break .BZ>>pettil.lab
#echo break .BNZ>>pettil.lab
#echo break .BM1>>pettil.lab
#echo break .BNM1>>pettil.lab

#echo break .SET>>pettil.lab
#echo break .LD>>pettil.lab
#echo break .ST>>pettil.lab
#echo break .LDAT>>pettil.lab
#echo break .STAT>>pettil.lab
#echo break .LDDAT>>pettil.lab
#echo break .STDAT>>pettil.lab
#echo break .POP>>pettil.lab
#echo break .STPAT>>pettil.lab
#echo break .ADD>>pettil.lab
#echo break .SUB>>pettil.lab
#echo break .POPD>>pettil.lab
#echo break .CPR>>pettil.lab
#echo break .INR>>pettil.lab
#echo break .DCR>>pettil.lab

#echo break ._convert>>pettil.lab
#echo break ._number>>pettil.lab
#echo break .execute>>pettil.lab
#echo break ._rethread>>pettil.lab
#echo break .qbranch>>pettil.lab
#echo break ._sharp>>pettil.lab
#echo break ._rethread>>pettil.lab
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
