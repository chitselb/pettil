#!/bin/bash
# perturb.sh
#
# Compiles the code and deploys test machines
#
pwd
    # add other targets
    for object in obj/perturb.prg* ; do                                         \
        ls -la $object ;                                                       \
        c1541 -attach pettil.d64 -write $object ;                              \
    done

xfce4-terminal &
