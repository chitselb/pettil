#!/buildpettil.sh
	echo target# $1
	echo romopts $2
	echo studio  $3
	echo specialopts  $4

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
#	echo . . . . Generating combined symbol table = PETTIL.SYM
	ruby ./tools/xap.rb
#	echo . . . . Packing PETTIL.PRG binary = PETTIL-CORE.OBJ + PETTIL-TDICT.OBJ + PETTIL.SYM
	ls -la ./tmp/pettil-core.obj ./tmp/pettil-studio.obj ./tmp/pettil.sym
	cat \
		./tmp/pettil-core.obj \
		./tmp/pettil-studio.obj \
		./tmp/pettil.sym \
		> ./obj/pettil.prg$1
	ls -la ./obj/pettil.prg$1
	sort ./tmp/pettil.mon > ./tmp/t.t
	if [ -e ./pettil.dbg ]; then cat ./pettil.dbg >> ./tmp/t.t; fi
	mv ./tmp/t.t ./tmp/pettil.mon
	cp -v tmp/pettil.mon ./obj/pettil.mon$1
#	ls -l ./tmp/*.obj ./tmp/*.sym > ./docs/sizes.txt
	stat -c '%8s %n' obj/* | sed -e 's/obj\///' >> ./docs/sizes.txt
	cp -v ./tmp/sizes.csv docs/sizes.csv$1

