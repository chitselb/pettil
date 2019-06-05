#!/bin/bash
# ~/pettil/tools/mkperturb.sh
#
# This script runs the test automation in the `at` queue.

    pwd
    c1541 -attach pettil.d64 -dir
    export DISPLAY=:0
    echo -----------------
    c1541 -attach pettil.d64 -del "perturb*" -dir
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
            echo replicant cheese
            echo $replicant $cheese
            cat perturb/${cheese}/*.i65> tmp/${replicant}.a65
            cd tmp
#            cat ${replicant}.a65
            xa ${replicant}.a65                                              \
                -DROM_OPTIONS=${romopts}                                            \
                -DHITOP=${studio}                                                   \
                -DSPECIALOPTS=${load}                                               \
                -I ../common/src/                                                   \
                -o ../tmp/${replicant}.obj${target}                            \
                -e ../tmp/${replicant}.err${target}                                  \
                -l ../tmp/${replicant}.lab${target}                                  \
                -v
            cd ..
            cat                                                                     \
                obj/pettil-core.obj${target}                                      \
                tmp/${replicant}.obj${target} > obj/${replicant}.prg${target}
            ls -la ./obj/${replicant}.prg${target}
            cd obj
                c1541 -attach ../pettil.d64 -del ${replicant}.prg${target}
                c1541 -attach ../pettil.d64 -write ${replicant}.prg${target}
            cd ..
            c1541 -attach pettil.d64 -dir
        done
    done

    for object in obj/perturb-*.prg4
    do
        cheese=$(basename ${object#*/})
        extension="${cheese##*.}"
        namer="${cheese%.*}"
        echo "chintz ${object}\n${cheese}\n${namer}"
        cp -v obj/perturb.mon4 tmp/
        echo "bk E089\ncommand 9 \"scrsh \\\"${namer}.scrsh\\\" 2;quit\"\nkeybuf load\"${cheese}\",9\x0drun\x0d" >> tmp/perturb.mon4
        tail -9 tmp/perturb.mon4
        pwd
        ls

        /home/chitselb/bin/xvic \
         -verbose \
         -directory data/VIC20/ \
         -moncommand tmp/perturb.mon4 \
         -config data/sdl2_chitselb.vicerc \
         -warp \
         -8 chitselb.d64 \
         -9 pettil.d64

    done

    echo fritos
    pwd

    exit
