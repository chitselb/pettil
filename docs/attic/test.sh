#!/bin/bash
# test.sh
sed 's/^\([_a-zA-Z0-9]*\),\ 0x\(....\).*$/al C\:\2 \.\1/g' < test.lab | sort > t.lab
mv t.lab test.lab
echo break +1037>>test.lab
