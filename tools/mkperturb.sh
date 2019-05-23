#!/bin/bash -x
# ~/pettil/tools/mkperturb.sh
#
# This script runs the test automation in the `at` queue.

    pwd
    c1541 -attach pettil.d64 -dir
    export DISPLAY=:0
    echo -----------------
    for target in 0 4
    do
        echo "target $target"
      #sh ./tools/buildpettil.sh 0     5       6500  0401
          case $target in
            0)
                echo "hey! a PET!"
                romopts=5
                load=0401
                studio=6500
                ;;
            4)
                echo "VIC-20!"
                romopts=32
                load=1201
                studio=6500
                ;;
        esac
        echo "${romopts} ${load} ${studio}"

        for suite in `ls -d perturb/*/`
        do
            cheese=$(basename ${suite#*/})
            replicant="perturb-${cheese}"
            echo $replicant $cheese
            cat perturb/perturb-base.a65 perturb/${cheese}/*.i65 > tmp/perturb-${cheese}.a65
            cd tmp
            xa ./perturb-${cheese}.a65                                              \
                -DROM_OPTIONS=${romopts}                                            \
                -DHITOP=${studio}                                                   \
                -DSPECIALOPTS=${load}                                               \
                -I ../common/src/                                                   \
                -o ../tmp/${replicant}.obj${target}                            \
                -e ../tmp/${replicant}.err${target}                                  \
                -l ../tmp/${replicant}.lab${target}                                  \
                -v
            cd ..
            echo wax?
            hd -v ./obj/pettil-core.obj${target} | head -10
            cat                                                                     \
                ./obj/pettil-core.obj${target}                                      \
                ./tmp/${replicant}.obj${target}>./obj/${replicant}.prg${target}
            hd -v ./obj/${replicant}.prg${target} | head -10
            ls -la ./obj/perturb-${cheese}.prg${target}
        done
    done

    for object in obj/p*.prg* ; do                                          \
        ls -la $$object ;                                                       \
        c1541 -attach pettil.d64 -write $$object ;                              \
    done


exit

echo -----------------
for perturbshow in obj/perturb*.prg4
do
    echo "$perturbshow"
    basename $perturbshow
    ls -la $perturbshow
    echo "$perturbshow"
    echo "$(basename $perturbshow)"
#    f = "$(basename -- $$perturbshow)"
#    echo $f
#    echo $f.mon4

#    xfce4-terminal                                                              \
#                --hide-menubar                                                  \
#                --hide-borders                                                  \
#                --geometry=40x25+0+28                                         \
#    --command="/usr/bin/xvic                                                    \
#    -directory data/VIC20/ -moncommand obj/perturb.mon4                         \
#    -config data/gtk3_vic.vicerc                                                \
#    -warp -8 chitselb.d64 -9 pettil.d64" &
 done
