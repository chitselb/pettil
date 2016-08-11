rd -recurse tmp
mkdir tmp
cd src
xa pettil-core.a65 -o ../tmp/pettil-core.obj -e ../tmp/pettil-core.err -l ../tmp/pettil-core.lab
cd ..
ruby xap.rb
cd src
xa ./pettil-tdict.a65 -o ../tmp/pettil-tdict.obj -e ../tmp/pettil-tdict.err -l ../tmp/pettil-tdict.lab
cd ..
ruby xap.rb
cd tmp
copy/y/b pettil-core.obj+pettil-tdict.obj+pettil.sym  pettil.obj
type pettil.mon | sort >t.t
copy/y t.t+..\pettil.dbg pettil.mon
rem c1541 -format pettil,pt d64 pettil.d64 -attach pettil.d64 -write pettil.obj pettil
cd ..
