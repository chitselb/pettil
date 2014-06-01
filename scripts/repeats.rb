#!/usr/bin/env ruby

00  [0-63] characters of text
01  [0-63] shamrocks of 6-bit characters
1 [0-1022] start position [0-31] length
1111 1111 111
0 = end of block
1 = end of 
 =  
    text type
        |1| 7-bit length n
        n characters
    pointer
        |0| 5-bit length
        10-bit start point
    flag
        0 00000
        11 1111 1111


[1111] [00] literal (same alphabet)
[1111] [01] EOR these two bits with the current alphabet
[1111] [10]      "                                 "
[1111] [11]      "                                 "



original
"i am sam i am sam sam i am"		26

01 2 shamrocks						1
[i]6 [_]6 [a]6 [m]6 				3
[_]6 [s]6 [111111] [000000]			3

00 6 characters						1
"i am s"							6

1 2,3								2
"am "

1 0,9								2
"i am sam "

1 5,8								2
"sam i am"
									====
									13

i am sam i am sam sam i am
i am s{2,3}{0,9}{5,8}

i am sam i am sam sam i am
