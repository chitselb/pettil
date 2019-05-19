#!/bin/bash
# this is buildpettil.sh
# sample usage: ./buildpettil.sh 4 32 6500 1201
#   builds PETTIL                |  |   |    |
#              target id    VIC-20  |   |    |
#              romopts         VIC-20   |    |
#              studio          tdict addr    |
#              pettil                load addr

	echo target id: $1  romopts: $2  studio: $3  load: $4

	make clean
#	echo . Phase I
#	echo . . . . Building PETTIL core = PETTIL-CORE.OBJ
	cd ./core/src/ &&                                                           \
	xa ./pettil-core.a65                                                        \
		-DROM_OPTIONS=$2                                                        \
		-DHITOP=$3                                                              \
		-DSPECIALOPTS=$4                                                        \
		-I ../../common/src/ 			                                        \
		-o ../../tmp/pettil-core.obj 	                                        \
		-e ../../tmp/pettil-core.err 	                                        \
		-l ../../tmp/pettil-core.lab 	                                        \
		-v
	cd -
#	echo . . . . Generating core labels = PETTIL-CORE.DEF
	ruby ./tools/xap.rb
	ls -la ./tmp/
#	echo . Phase II
#	echo . . . . Building PETTIL temporary dictionary = PETTIL-TDICT.OBJ
	cd ./studio/src/ &&                                                         \
	xa ./pettil-studio.a65                                                      \
		-DROM_OPTIONS=$2                                                        \
		-DHITOP=$3                                                              \
		-DSPECIALOPTS=$4                                                        \
	  -I ../../common/src/                                                      \
	  -o ../../tmp/pettil-studio.obj                                            \
	  -e ../../tmp/pettil-studio.err                                            \
	  -l ../../tmp/pettil-studio.lab                                            \
	  -v
	cd -
#	echo . Phase III
#	echo . . . . Building PERTURB temporary dictionary = PERTURB.OBJ
	cd ./perturb/src/ &&                                                        \
	xa ./perturb.a65                                             		        \
		-DROM_OPTIONS=$2                                                        \
		-DHITOP=$3                                                              \
		-DSPECIALOPTS=$4                                                        \
	  -I ../../common/src/                                                      \
	  -o ../../tmp/perturb.obj                                          		\
	  -e ../../tmp/perturb.err                                            		\
	  -l ../../tmp/perturb.lab
	cd -
#	echo . Phase IV
#	echo . . . . Generating combined symbol table = PETTIL.SYM
	ruby ./tools/xap.rb
#	echo . . . . Packing PETTIL.PRG binary = PETTIL-CORE.OBJ + PETTIL-TDICT.OBJ + PETTIL.SYM
	ls -la ./tmp/pettil-core.obj ./tmp/pettil-studio.obj ./tmp/pettil.sym
# PETTIL binary
	cat \
		./tmp/pettil-core.obj \
		./tmp/pettil-studio.obj \
		./tmp/pettil.sym \
		> ./obj/pettil.prg$1
# PERTURB binary
	cat \
		./tmp/pettil-core.obj \
		./tmp/perturb.obj \
		./tmp/perturb.sym \
		> ./obj/perturb.prg$1
	ls -la ./obj/pettil.prg$1
	sort ./tmp/perturb.mon > ./tmp/t.t
	if [ -e ./tools/perturb$1.dbg ]; then cat ./tools/perturb$1.dbg >> ./tmp/t.t; fi
	mv -v ./tmp/t.t ./obj/perturb.mon$1
#	ls -l ./tmp/*.obj ./tmp/*.sym > ./docs/sizes.txt
	stat -c '%8s %n' obj/* | sed -e 's/obj\///' >> ./docs/sizes.txt
	cp -v ./tmp/sizes.csv docs/sizes.csv$1

