grep -h -B2 forth-83 src/*.a65 | egrep ^name= | sort | cut -b6- > z.z && sort docs/forth83-required-words.txt >t.t && diff -y z.z t.t
