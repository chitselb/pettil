#!/bin/bash
# this is buildpettil.sh
# sample usage: ./buildpettil.sh 4 32 6500 1201
#   builds PETTIL                |  |   |    |
#              target id    VIC-20  |   |    |
#              romopts         VIC-20   |    |
#              studio          tdict addr    |
#              pettil                load addr
#	echo target id: $1  romopts: $2  studio: $3  load: $4

#	echo . Phase I
#	echo . . . . Building PETTIL core = PETTIL-CORE.OBJ
	cd ./src/core/ &&                                                           \
	xa ./pettil-core.a65                                                        \
		-DROM_OPTIONS=$2                                                        \
		-DHITOP=$3                                                              \
		-DSPECIALOPTS=$4                                                        \
		-I ../common/ 															\
		-I ../../tmp/ 			                                    			\
		-o ../../tmp/pettil-core.obj 	                                        \
		-e ../../tmp/pettil-core.err                                            \
		-l ../../tmp/pettil-core.lab
	cd -
#	echo . . . . Generating core labels = PETTIL-CORE.DEF
	ruby ./tools/xap.rb
#	echo . Phase II
#	echo . . . . Building PETTIL temporary dictionary = PETTIL-TDICT.OBJ
	cd ./src/studio/ &&                                                         \
	xa ./pettil-studio.a65                                                      \
		-DROM_OPTIONS=$2                                                        \
		-DHITOP=$3                                                              \
		-DSPECIALOPTS=$4                                                        \
	  -I ../common			                                                    \
	  -o ../../tmp/pettil-studio.obj                                            \
	  -e ../../tmp/pettil-studio.err                                            \
	  -l ../../tmp/pettil-studio.lab
	cd -
	cp ./tmp/pettil-studio.lab ./tmp/pettil-studio.lab$1
#	echo . Phase IV
#	echo . . . . Generating combined symbol table = PETTIL.SYM
	ruby ./tools/xap.rb
#	echo . . . . Packing PETTIL.PRG binary = PETTIL-CORE.OBJ + PETTIL-TDICT.OBJ + PETTIL.SYM

# PETTIL binary
	cat \
		./tmp/pettil-core.obj \
		./tmp/pettil-studio.obj \
		./tmp/pettil.sym \
		> ./obj/pettil.prg$1
	cp ./tmp/pettil-core.obj ./obj/pettil-core.obj$1

	sort ./tmp/pettil.mon > ./tmp/t.t

	if [ -e ./tools/vice/perturb$1.dbg ]; then
		cat ./tmp/t.t ./tools/vice/perturb$1.dbg > ./obj/perturb/perturb.mon$1
	fi

	if [ -e ./tools/vice/pettil$1.dbg ]; then
		cat ./tmp/t.t ./tools/vice/pettil$1.dbg > ./obj/pettil.mon$1
	fi
#	ls -l ./tmp/*.obj ./tmp/*.sym > ./doc/sizes.txt
	rm ./doc/sizes.txt
	stat -c '%8s %n' obj/* | sed -e 's/obj\///' >> ./doc/sizes.txt
	cp ./tmp/sizes.csv doc/sizes.csv$1

