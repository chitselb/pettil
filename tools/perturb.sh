#!/bin/bash
# pettil/tools/perturb.sh
#
# the thing that runs the test automation in the `at` queue.
pwd
c1541 -attach pettil.d64 -dir
export DISPLAY=:0
for perturbshow in obj/perturb*.prg4
do
    basename $perturbshow
    ls -la $perturbshow
    echo "$perturbshow"
    echo "$(basename $perturbshow)"
#    f = "$(basename -- $$perturbshow)"
#    echo $f
#    echo $f.mon4
    xfce4-terminal                                                              \
                --hide-menubar                                                  \
                --hide-borders                                                  \
                --geometry=80x40+630+28                                         \
    --command="/usr/bin/xvic                                                    \
    -directory data/VIC20/ -moncommand obj/perturb.mon4                         \
    -config data/gtk3_vic.vicerc                                                \
    -warp -8 chitselb.d64 -9 pettil.d64" &
 done
