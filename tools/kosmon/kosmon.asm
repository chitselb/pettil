;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	KosMon - A Machine Language Monitor for C64 and PET.
;;
;;	(C) 1986-1996 by Olaf Seibert. All Rights Reserved.
;;	May be distributed under the GNU General Public License.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Hints for the C64 $C000 version:
; Move the entry point, marked with ///, to the indicated place,
; and change the base and BRK entry point accordingly.
; For a <4K version, set the symbol haveecmd to 0.

	processor 6502

	mac cset		; conditional set
	ifnconst {1}
{1}	= {2}
	endif
	endm

	cset base, $9000	; /// -$cc

c64	= 1
pet	= 2

	cset target, pet

; the settings below are for pets only.
; Note there is only allowance for Basic 2.0 (new roms) and 4.0.

	cset petb2,	0	; flag
	cset petb4,	1	; flag
	cset petb440,	0	; flag for petb4 only
	cset petb480,	1	; flag for petb4 only

lines	= 25
#if petb4 && petb480
columns = 80
#else
columns = 40
#endif
mindiskdev = 8
diskdev = 8	; my taste
printdev = 4	; my taste
printsa = 7	; my taste

	cset havedashes, 1
#if target == c64
	cset	haveecmd, 1
havepfkeys = 1
#else
haveecmd = 0
havepfkeys = 0
#endif

#if [target == pet] && petb2
	cset autorepeat, 1
#else
	cset autorepeat, 0
#endif	; (target == pet) && petb2

#if autorepeat
slowrep = 23	; time before first repeat (in jiffies)
fastrep	= 4	; time between repeats (in jiffies)
#endif	; autorepeat


       ;+++ absolute adresses

#if target == c64

pport	= $01
status	= $90
verck	= 0	; not needed
msgflg	= $9d
fnlen	= $b7
sa	= $b9
fa	= $ba
stal	= $c1
memuss	= stal+2
ndx	= $c6
indx	= $c8
lxsp	= $c9
blnsw	= $cc
gdbln	= $ce
blnon	= $cf
eal	= $ae
crsw	= $d0
pnt	= $d1
pntr	= $d3
qtsw	= $d4
tblx	= $d6
datax	= $d7
ldtbl	= $d9
rtsp	= $0200
rtstack = $0201
keyd	= $0277
gdcol	= $0287
hibase	= $0288
autodn	= $0292
tmplin	= $02a5
cirqv	= $0314
cbrkv	= $0316

       ;+++ external jumps

basnmi	= $a002
vicreset = $e5a8
kbdget	= $e5b4
scrcont = $e602
scrget	= $e63a
scrprint = $e716
instlin = $e981
pokchr	= $ea13
kbdinput = $f15b
busclse = $f651
ioinit	= $fda3
second	= $ff93
tksa	= $ff96
iecin	= $ffa5
iecout	= $ffa8
untlk	= $ffab
unlsn	= $ffae
listen	= $ffb1
talk	= $ffb4
setlfs	= $ffba
setnam	= $ffbd
load	= $ffd5
save	= $ffd8
stop	= $ffe1

#endif
#if target == pet

time	= $8d
cirqv	= $90
cbrkv	= $92
status	= $96
lstx	= $97
nokey	= $ff	; for lstx
verck	= $9d
ndx	= $9e
indx	= $a1
lxsp	= $a3
blnsw	= $a7
blnct	= $a8
gdbln	= $a9
blnon	= $aa
crsw	= $ac
eal	= $c9
fnlen	= $d1
la	= $d2
sa	= $d3
fa	= $d4
pnt	= $c4
pntr	= $c6
qtsw	= $cd
tblx	= $d8
datax	= $d7
fnadr	= $da
#if petb4 && petb480
ldtbl	= 0		; not implemented
#else
ldtbl	= $e0
#endif			; petb4 && petb480
stal	= $fb
memuss	= stal+2
rtsp	= $0200
rtstack = $0201
keyd	= $026f

tmplin	= 0		; not implemented
msgflg	= 0		; not implemented
gdcol	= 0		; not implemented
autodn	= 0		; not implemented
hibase	= 0		; not implemented

       ;+++ external jumps

setnam	= 0		; not implemented
setlfs	= 0		; not implemented

#if petb2
basready = $c389	; basic READY.

ioinit	= 0
kbdget	= $e285
scrprint = $e3d8	; print .A to screen (could use FFD2)
vicreset = 0
instlin = $e5ba		; really: open line on screen

talk	= $f0b6 	; send TALK
listen	= $f0ba 	; send LISTEN
second	= $f128 	; send SA after LISTEN
tksa	= $f164 	; send SA after TALK
iecout	= $f16f 	; send byte to IEEE bus
untlk	= $f17f 	; send UNTALK
unlsn	= $f183 	; send UNLISTEN
iecin	= $f18c 	; get byte from IEEE bus
romload = $f322 	; O/S version of LOAD
searching = $f40a	; print SEARCHING FOR name
sendname = $f466	; send program name to bus
loading = $f42e 	; print LOADING
save	= $f6a4 	; O/S version of SAVE
buslsnclse = $f6f0	; send LISTEN, CLOSE and UNLISTEN
busclse = $f6fd 	; send CLOSE and UNLISTEN

kbdinput = $f1e5	; FFCF after checking for keyboard
stop	= $f301 	; test STOP key

scrcont = $e2cc 	; continue INPUT loop
scrget	= $e2fc 	; INPUT (get) byte from screen
pokchr	= $e6ea 	; put char (and colour) in screen memory
			; the N-keybd version has an extra delay loop
			; here but we can't avoid that: would not work
			; with the B version.
#endif			; petb2
#if petb4
			; Sigh... the E000 jumptable entries are not
			; in the "upgrade" 4.0 version for PETs without
			; CRT controller... sigh...
basready = $b3ff

ioinit	= $e000
kbdget	= $e0a7 	; $e003 would be better but less compatible
scrprint = $e202	; $e009 print .A to screen
vicreset = $e018	; lower case settings
instlin = $e021

talk	= $f0d2
listen	= $f0d5
second	= $f143
tksa	= $f193
iecout	= $f19e
untlk	= $f1ae
unlsn	= $f1b9
iecin	= $f1c0
romload = $f356
searching = $f449
sendname = $f4a5
loading = $f46d
save	= $f6e3
buslsnclse = $f72f
busclse = $f73c
stop	= $f335

kbdinput = $f219

#if petb440
scrcont = $e0ee ; accidentally the same in 40 and 80 colums
scrget	= $e11e
pokchr	= $e606 ; accidentally the same in 40 and 80 colums
#endif	; petb440
#if petb480
scrcont = $e0ee ; accidentally the same in 40 and 80 colums
scrget	= $e121
pokchr	= $e606 ; accidentally the same in 40 and 80 colums
#endif	; petb480
#endif	; petb4

       ;+++ tables and hardware addresses

screen	= $8000
#if petb4 && petb480
ram96latch = $fff0	; set to 0 to not support it.
#else
ram96latch = 0		; set to 0 to not support it.
#endif

#endif	; target == pet

       ;+++ constants

cr	= $0d
cu	= $91; "^Q"
cd	= $11; "^q"
home	= $13; "^s"
rvs	= $12; "^r"
off	= $92; "^R"
pf1	= $85; "^E"
cri	= $1d; "^]"
cl	= $9d; "^]"
quote	= 34
hexwidth = columns / 5		; 8 or 16
ascwidth = 4 * columns / 5	; 32 or 64

	org base

       ; +++ program

	    ;///mark with start
entry	php
	pha
	lda #<romin
	sta cbrkv
	lda #>romin
	sta cbrkv+1
	lda #0
	sta rtsp
	pla
	plp
	brk

romin
#if target == c64
	lda #$36
	sta pport
#if .romin_end != ramin
	jmp ramin
#endif
.romin_end
#endif
	    ;///mark with end

	subroutine

ramin	cld
	ldx #5
ic012	pla
	sta rspace,x
	dex
	bpl ic012
	tsx
	stx spsave
	stx stackmk
	lda pclo
	bne ic028
	dec pchi
ic028	dec pclo
	lsr pflag
	lda fa
	cmp #mindiskdev
	bcs ic038
	lda #diskdev
	sta fa
ic038
#if msgflg
	lda #$c0
	sta msgflg
#endif
	jsr docr
	jmp rcmd
	;lda #"R"
	;bne docmd
error	lda #"?"
	jsr scrprint
prompt	jsr docr
	lda #"."
	jsr scrprint
	lda #0
	sta ovflow
	sta pflag
execute ldx stackmk
	txs
ic05c	jsr nextchr
	cmp #"."
	beq ic05c
docmd	ldx #adrtab-cmdtab-1
cmdloop cmp cmdtab,x
	bne cmdnxt
	sta cmdchr
	txa
	asl ;a
	tax
	lda adrtab+1,x
	pha
	lda adrtab,x
	pha
	php
	rti ;do the command

cmdnxt	dex
	bpl cmdloop
	bmi error

; the p command is a prefix for the others.
; when used it prints on both the screen and printer #printdev.

pcmd	sec
	ror pflag	; set high bit
	bne execute

	;+++ pointer routines

ststlinc
	jsr stastal

incstal inc stal
	bne ic6a0
	inc stal+1
	bne ic6a0
	inc ovflow
ic6a0	rts

decmuss ldx #2
	dc.b $2c
decstal ldx #0
	ldy stal,x
	bne ic09b
	ldy stal+1,x
	bne ic099
	inc ovflow
ic099	dec stal+1,x
ic09b	dec stal,x
	rts

staleqsv
	lda stalsav
	ldy stalsav+1
	jmp ic0ce

steqend lda memuss
	ldy memuss+1
ic0ce	sec
	sbc stal
	sta loleft
	tya
	sbc stal+1
	tay ;hileft
	ora loleft
	rts

swstend ldx #2
ic5f0	lda stal-1,x
	pha
	lda memuss-1,x
	sta stal-1,x
	pla
	sta memuss-1,x
	dex
	bne ic5f0
	rts

stpc	sta pclo
	stx pchi
	rts
	;/// move entry for $c000 here

	;+++ conversion routines

sphex2	pha
	jsr dospc
	pla
	jmp hex2

hex4	lda stal+1
	jsr hex2
	lda stal
hex2	pha
	lsr ;a
	lsr ;a
	lsr ;a
	lsr ;a
	jsr hex1
	tax
	pla
	and #$0f
	jsr hex1
printxa pha
	txa
	jsr print
	pla
	jmp print

a2hexax pha
	lsr ;a
	lsr ;a
	lsr ;a
	lsr ;a
	jsr hex1
	tax
	pla
	and #$0f

hex1	clc
	adc #$f6
	bcc ic5eb
	adc #6
ic5eb	adc #$3a
	rts

deci	ldx #8
ica3d	sec
	lda stal
	cmp tenpow,x
	lda stal+1
	sbc tenpow+1,x
	bcs ica4e
	dex
	dex
	bne ica3d
ica4e	ldy #$30
	sec
ica51	lda stal
	sbc tenpow,x
	pha
	lda stal+1
	sbc tenpow+1,x
	bcc ica66
	sta stal+1
	pla
	sta stal
	iny
	bne ica51
ica66	pla
	tya
	jsr print
	dex
	dex
	bpl ica4e
	rts

			; print .SR
printps jsr dospc
	lda pssave
bin8	ldx #8		; print .A binary
ic704	rol ;a
	pha
	lda #"*"
	bcs ic70c
	lda #"."
ic70c	jsr print
	pla
	dex
	bne ic704
	rts

getstend
	jsr hex2stal
	sta memuss
	stx memuss+1
	jsr eol
	beq ic3ab
	jsr hex2muss
ic3ab	jmp docr

get3adrs		; get addresses to memuss, stalsav, stal.
	jsr hex2muss
	;sta memuss
	;stx memuss+1
	jsr hex2ax
	sta stalsav
	stx stalsav+1
hex2stal		; get address to stal
	jsr hex2ax
	sta stal
	stx stal+1
	rts

hex2muss		; get address to memuss
	jsr hex2ax
	sta memuss
	stx memuss+1
	rts

hex2ax	jsr hex2a	; get hex address to a,x
	;bcc errc6
	tax
	;jsr hex2a
	;bcc errc6
	;rts

hex2a	;lda #0 	; get hex byte to .A
	;sta nybble
	jsr nextchr
hexa2a	jsr hex2nybb	; get hex byte in .A decoded to .A
	asl ;a
	asl ;a
	asl ;a
	asl ;a
	sta nybble
	jsr nextchr
	jsr hex2nybb
	ora nybble
	sec
	rts

errcd	jmp error

hex2nybb		; convert character to hex nybble
	cmp #":"
	bcc ic651
	sbc #7
ic651	and #$0f
	rts

tst0f	cmp #"0"        ; test for 0-F
	bcc ic50e
	cmp #"G"
	rts ;c=0:mogelijk cijfer
ic50e	sec ;geen cijfer
	rts

; hexadecimal or decimal input

hdin4	ldy #0
	sty $00,x
	sty $01,x
	cmp #"$"
	beq hexin4
	jsr tst09
	bcs errcd
icd14	pha		; decimal input
	asl $00,x	; * 10
	lda $00,x
	rol $01,x
	ldy $01,x
	asl ;a
	rol $01,x
	asl ;a
	rol $01,x
	clc
	adc $00,x
	sta $00,x
	bcc icd2c
	iny
	clc
icd2c	pla
	adc $00,x
	sta $00,x
	tya
	adc $01,x
	sta $01,x
	jsr kbdinput
	jsr tst09
	bcc icd14
	rts

hexin4	jsr hexin1	; input 1-4 hexadecimal digits (4 significant)
	bcs errcd
icd44	ldy #4
icd46	asl $00,x
	rol $01,x
	dey
	bne icd46
	ora $00,x
	sta $00,x
	jsr hexin1
	bcc icd44
	rts

hexin1	jsr kbdinput	; input 1 hexadecimal digit
	cmp #"G"
	bcs icd74
	cmp #"A"
	bcs icd70
tst09	cmp #"0"        ; test if between 0 and 9
	bcc icd74
	cmp #":"
	bcs icd74
	and #$0f
	rts
icd70	sbc #$37
	clc
	rts
icd74	sec
	rts

bin2a	ldx #8		; binary to .A
ic752	pha
	jsr nextchr
	cmp #"*"
	beq ic75b
	clc
ic75b	pla
	rol ;a
	dex
	bne ic752
	rts

eol	lda pntr	; test if at the end of input
	cmp indx
	rts

nextchr jsr inpsksp	; get next nospace character
	bne nocr	; always

inpsksp jsr input	; get character, skipping spaces
skipspc cmp #" "
	beq inpsksp
ic653	rts

inpnocr jsr input	; get next character
nocr	cmp #cr 	; error if cr
	bne ic653
	jmp error	; prompt

	;+++ command routines

ccmd	lda #0		; Compare command
	dc.b $2c
tcmd	lda #1		; Transfer command
	sta ctflag	; remember C or T
	jsr get3adrs	; get Start, End, Dest
	jsr docr
	jsr steqend
	jsr swstend
	bcc ic10d
ic0f2	jsr staleqsv
	bcs ic0fa
	jmp prompt
ic0fa	jsr ctbyte
	inc memuss
	bne ic103
	inc memuss+1
ic103	jsr incstal
	ldy ovflow
	bne ic153
	beq ic0f2
ic10d	jsr staleqsv
	clc
	lda loleft
	adc memuss
	sta memuss
	tya
	adc memuss+1
	sta memuss+1
	;jsr swpadrs was subr

swpadrs ldx #2
ic0b1	lda stal-1,x
	pha
	lda stalsav-1,x
	sta stal-1,x
	pla
	sta stalsav-1,x
	dex
	bne ic0b1
	;rts

ic120	jsr ctbyte
	jsr staleqsv
	bcs prptc1
	jsr decmuss
	jsr decstal
	ldy ovflow
	bne ic153
	beq ic120

ctbyte	jsr ldastal
	ldy ctflag
	beq ic142
	jmp stamuss
ic142	jsr cmpmuss
	beq ic152

hex4stop		; print 4 hex digits, space, test STOP
	jsr hex4
	jsr dospc
	jsr stop
	beq ic153
ic152	rts
ic153	jmp prompt

fcmd	jsr hex2stal
	jsr hex2muss
	jsr hex2a
	;bcc errc1
	sta apos
ic167	ldx ovflow
	bne prptc1
	jsr steqend
	bcc prptc1
	lda apos
	jsr stastal
	jsr incstal
	bne ic167	; always
prptc1	jmp prompt

hcmd	jsr hex2stal
	jsr hex2muss
	ldx #0
	jsr nextchr
	cmp #"'"
	bne hunthex
	jsr nextchr
ic197	sta huntbuf,x
	inx
	jsr kbdinput
	cmp #cr
	beq ic1c4
	cpx #end-huntbuf
	bne ic197
	beq ic1c4

hunthex ;stx nybble
	jsr hexa2a
	bcc errc1
ic1b0	sta huntbuf,x
	inx
	jsr inpsksp
	cmp #cr
	beq ic1c4
	jsr hexa2a
	bcc errc1
	cpx #end-huntbuf
	bne ic1b0
ic1c4	stx huntlen
	jsr docr
huntloop
	ldx #0
	ldy #0
testnext
	jsr ldastaly
	cmp huntbuf,x
	bne ic1e0
	iny
	inx
	cpx huntlen
	bne testnext
	jsr hex4stop
ic1e0	jsr incstal
	ldy ovflow
	bne prptc1e
	jsr steqend
	bcs huntloop

prptc1e jmp prompt
errc1	jmp error

ycmd	lda #0
	sta huntlen
	jsr hex2stal
	jsr hex2muss
y02	jsr inpsksp
	cmp #cr
	beq yloop
	jsr tst0f
	bcs errc1
	jsr hexa2a
	ldy huntbuf
	sty huntbuf+1
	sta huntbuf
	inc huntlen
	bne y02
yloop	jsr steqend
	bcc prptc1e
	jsr opredu
	ldy oplen
	cpy huntlen
	bne y00
y01	jsr ldastaly
	cmp huntbuf-1,y
	bne y00
	dey
	bne y01
	jsr dlinecm
y00	jsr adstalen
	jsr stop
	bne yloop
	beq prptc1e

dcmd	jsr getstend	; Disassemble command
dloop	jsr steqend
	bcc cuprpt
	jsr ddashes
	jsr adstalen
	jsr stop
	bne dloop
cuprpt	jsr printcu
	bne prptc1e

#if havedashes
ddashes jsr dlinecm
dashes	jsr ldastal
	tay
	and #%11011111;jmp/jmp()
	cmp #%01001100
	beq dodashes
	tya
	and #%10011111;brk/rts/rti/jsr
	cmp #%00000000
	bne nodashes
	cpy #%00100000;jsr
	beq nodashes
dodashes
	jsr docr
	ldx #35
	lda #"-"
ili0	jsr print
	dex
	bne ili0
nodashes
#else
ddashes = dlinecm
#endif	; havedashes
	 rts

dlinecm ldy #","
dline	jsr dinstr
	ldx #9
doxsp	jsr dospc	; print .X spaces
	dex
	bne doxsp
	rts

dinstr	jsr crdotysp	; disassemble one opcode
dinstr2 jsr hex4
	jsr dospc
	jsr opredu
	pha
	jsr ddump
	pla
	jsr unpack
	ldx #6
ic220	cpx #3
	bne ic239
	ldy oplen
	beq ic239
	;print hex byte/s
ic229	lda mode
	cmp #$e8	;relative
	jsr ldastaly	; must preservr carry
	bcs prtrelad
	jsr hex2savx
	dey
	bne ic229
ic239	asl mode
	bcc ic24c     ;842184
	lda modes1-1,x;$(#,),
	jsr prtnosup
	lda modes2-1,x; $$x y
	beq ic24c
	jsr prtnosup
ic24c	dex
	bne ic220
	rts

prtrelad
	jsr adcstala
	tax
	inx ;low
	bne ic258
	iny ;hi
ic258	tya
	jsr hex2savx
	txa
hex2savx stx .+7
	jsr hex2
	ldx #0		; operand modified
	rts

adstalen lda oplen
addstaa  jsr ad1stala
	sta stal
	sty stal+1
	rts

ad1stala sec ;signed accu
adcstala ldy stal+1
	tax
	bpl ic279
	dey
ic279	adc stal
	bcc ic27e
	iny
ic27e	rts

; Reduce opcode to essential instruction info
; used by a,d,y,scroll
opredu	jsr ldastal
reduce	tay
	lsr ;a
	bcc ic28e
	lsr ;a
	bcs ic29d
	cmp #$22
	beq ic2a5
	and #7
	ora #$80
ic28e	lsr ;a
	tax
	lda illtab,x
	bcs ic299
	lsr ;a
	lsr ;a
	lsr ;a
	lsr ;a
ic299	and #$0f
	bne ic2a9
ic29d	lsr ;a
	bcc ic2a5
	and #1
	adc #1	;c=1
	dc.b $2c
ic2a5	lda #0
	ldy #$80

ic2a9	tax
	lda modes,x
	sta mode
	and #3
	sta oplen
	tya
	and #$8f
	tax
	tya
	ldy #3
	cpx #$8a
	beq ic2cb
ic2c0	lsr ;a
	bcc ic2cb
	lsr ;a
ic2c4	lsr ;a
	ora #$20
	dey
	bne ic2c4
	iny
ic2cb	dey
	bne ic2c0
	rts

ddump	jsr ldastaly
	jsr hex2savx
	ldx #1
ic2d7	jsr doxsp
	cpy oplen
	iny
	bcc ddump
	ldx #3
	cpy #3
	bcc ic2d7
	jmp dospc

unpack	tay
	lda rd2pklo,y
	sta stalsav
	lda rd2pkhi,y
	sta stalsav+1
ic2f4	lda #0
	ldy #5
ic2f8	asl stalsav+1
	rol stalsav
	rol ;a
	dey
	bne ic2f8
	adc #$3f
	jsr print
	dex
	bne ic2f4
	jmp dospc

cmcmd	jsr hex2stal
	lda #3
	jsr docolon
	ldy #","
	jmp fillkeyd

	subroutine

ltcmd	clc		; < command
	dc.b $24
htcmd	sec		; > command
	php
	jsr hex2stal
	jsr inpsksp
	cmp #quote
	bne errc2
	plp
	php
	bcc ica8e
ica82	jsr kbdinput
	ldx crsw
	beq ica9d
	jsr ststlinc
	bne ica82
ica8e	ldy pntr
	lda (pnt),y
	inc pntr
	cpy indx
	bcs ica9d
	jsr ststlinc
	bne ica8e
ica9d	lda #"<"
	plp
	bcc icaa4
	lda #">"
icaa4	sta keyd
	lda #0
	sta keyd+1
	lda #quote
	jmp filkeyd2

errc2	jmp error

	subroutine

kcmd	jsr getstend	; k command
.top	ldx ovflow
	bne .end
	jsr steqend
	bcc .end
	jsr crascdmp
	jsr stop
	bne .top
.end	jmp cuprpt

	subroutine

crascdmp
	jsr docr
doascdmp
	ldx #"."
	lda #">"
	jsr printxa
	jsr hex4
	lda #quote
	jsr print
	lsr qtsw
	ldy #ascwidth
	bne ascdmp

docolon sta apos
	pha
;ic31e	jsr abytesin

abytesin
	jsr inpnocr
	cmp #" "
	bne ic68e
	jsr inpnocr
	jsr tst0f
	bcs ic68e	;if not a digit
	jsr hexa2a
	;bcc ic68e
	;ldx #0
	jsr stastal
	jsr cmpstal
	bne errc2
ic68e	jsr incstal
	dec apos
	;rts

	bne abytesin	;ic31e
	pla
sbcstaa eor #$ff
	jmp addstaa

mcmd	jsr getstend
ic32f	ldx ovflow
	bne ic341
	jsr steqend
	bcc ic341
	jsr crhexdmp
	jsr stop
	bne ic32f
ic341	jmp cuprpt

crhexdmp		; print CR and hex dump
	jsr docr
dohexdmp		; do hex dump
	ldx #"."
	lda #":"
	jsr printxa
	jsr dospc
	jsr hex4
	lda #hexwidth
	;jsr ahex2 was subroutine

ahex2	sta apos
	ldy #0
ic66a	jsr dospc
	jsr ldastaly
	jsr hex2
	jsr incstal
	dec apos
	bne ic66a
	;rts

	lda #hexwidth
	jsr sbcstaa
	ldy #hexwidth
ascdmp	jsr ldastal
	pha
	and #$7f
	cmp #$20
	pla
	php
	bcs ic374
	pha
	lda #rvs
	jsr print
	pla
	ora #$40
ic374	jsr print
	lsr qtsw
	plp
	bcs i300
	lda #off
	jsr print
i300	jsr incstal
	dey
	bne ascdmp
	rts

cocmd	jsr hex2stal	; : colon command
	lda #hexwidth
	jsr docolon
	jsr printcu
	jsr crhexdmp
	lda #":"
filkeyd0
	sta keyd
	jmp filkeyd1

acmd	jsr hex2ax
	sta memuss
	stx memuss+1
ic3b5	ldx #0		; find 3-letter word
	stx huntbuf+1
ic3ba	jsr inpnocr
	cmp #" "
	beq ic3b5
	sta abuf,x
	inx
	cpx #3
	bne ic3ba

ic3c9	dex
	bmi ic3e0
	lda abuf,x
	sec
	sbc #$3f
	ldy #5		; 5 bits of the letter
ic3d4	lsr ;a
	ror huntbuf+1
	ror huntbuf
	dey
	bne ic3d4
	beq ic3c9
			; 3*5 bits fit in a word
ic3e0	ldx #2
ic3e2	jsr kbdinput
	cmp #cr
	beq ic40b
	cmp #":"
	beq ic40b
	cmp #" "
	beq ic3e2
			; there is an operand
	jsr tst0f
	bcs ic405
	jsr hexa2a
	ldy stal
	sty stal+1
	sta stal	; save lo/hi order
	lda #$30
	sta huntbuf,x
	inx
ic405	sta huntbuf,x
	inx
	bne ic3e2

ic40b	stx stalsav
	ldx #0		; tried opcode
	stx ovflow
aloop	ldx #0
	stx apos
	lda ovflow
	jsr reduce
	ldx mode
	stx stalsav+1
	tax
	lda rd2pkhi,x
	jsr amatch
	lda rd2pklo,x
	jsr amatch
	ldx #6
ia433	cpx #3
	bne ic44b
	ldy oplen
	beq ic44b
ic43c	lda mode
	cmp #$e8
	lda #$30
	bcs ic463
	jsr amatch2
	dey
	bne ic43c
ic44b	asl mode
	bcc ic45e
	lda modes1-1,x
	jsr amatch
	lda modes2-1,x
	beq ic45e
	jsr amatch
ic45e	dex
	bne ia433
	beq ic469

ic463	jsr amatch2
	jsr amatch2
ic469	lda stalsav
	cmp apos
	beq ic474
	jmp nxtopc
ic474	jsr swstend
	ldy oplen
	beq ic4ab
	lda stalsav+1
	cmp #$9d
	bne ic4a2
	jsr steqend
	bcc ic492
	tya
	bne errc4
	ldx loleft
	bmi errc4
	bpl ic49a
ic492	iny
	bne errc4
	ldx loleft
	bpl errc4
ic49a	dex
	dex
	txa
	ldy oplen
	bne ic4a5
ic4a2	lda stal+1,y
ic4a5	jsr stastaly
	dey
	bne ic4a2
ic4ab	lda ovflow
	jsr stastaly
	ldy #"A"
fillkeyd
	sty keyd
	jsr printcu
	jsr dline
	jsr adstalen
filkeyd1
	lda #" "
	sta keyd+1
filkeyd2
	sta keyd+6
	lda stal+1
	jsr a2hexax
	stx keyd+2
	sta keyd+3
	lda stal
	jsr a2hexax
	stx keyd+4
	sta keyd+5
	lda #7
	sta ndx
	jmp prompt

amatch2 jsr amatch
amatch	stx huntlen
	ldx apos
	cmp huntbuf,x
	beq ic4ff
	pla
	pla
nxtopc	inc ovflow  ;tried opcode
	beq errc4
	jmp aloop
errc4	jmp error

ic4ff	inx
	stx apos
	ldx huntlen
	rts

jcmd	lda #$20;jsr
	dc.b $2c
gcmd	lda #$4c ;jmp
	sta ac56b
	jsr kbdinput
	cmp #cr
	beq ic54a
	cmp #" "
	bne ic56f
	jsr hex2ax
	jsr stpc
	jsr kbdinput
	cmp #cr
	bne errc4
ic54a	jsr docr
	ldx spsave
	txs
	lda pchi
	sta ac56b+2
	lda pclo
	sta ac56b+1
	lda pssave
	pha
	lda acsave
	ldx xrsave
	ldy yrsave
	plp
ac56b	jmp $ffff	; this address will be mofified
	brk

ic56f	cmp #"F"
	bne errc4
	;lda ac56b
	;cmp #$4c; jmp
	;bne errc4
	jsr kbdinput
	cmp #" "
	bne errc4
	jsr hex2ax
	sta memlo
	stx memhi
	lda #"E"
	jsr diskmrw
	jsr unlsn
	jmp prompt

rcmd	ldx #0		; Register dump cmd
ic6b6	lda rtxt,x
	jsr print
	inx
	cpx #cmdtab-rtxt
	bne ic6b6
	lda pchi
	jsr hex2
	lda pclo
	jsr hex2
	jsr dospc
	lda cirqv+1
	jsr hex2
	lda cirqv
	jsr hex2
#if target == c64
	lda pport
#endif
#if target == pet
	lda bankpp
#endif
	jsr sphex2
	lda fa
	jsr sphex2
	ldy #0
ic6e8	lda acsave,y
	jsr sphex2
	iny
	cpy #4
	bcc ic6e8
	jsr printps
	jmp prompt

			; semicolon cmd
sccmd	jsr hex2ax	; pc
	jsr stpc
	jsr hex2ax	; irq
	sei
	sta cirqv
	stx cirqv+1
	cli
	jsr hex2a	; processor port
#if target == c64
	sta pport
#endif
#if target == pet
	sta bankpp
#endif
	jsr hex2a	; drive
	sta fa
	ldy #0
ic739	jsr hex2a
	sta acsave,y
	iny
	cpy #4
	bcc ic739
	jsr bin2a
	sta pssave
	jmp prompt

icmd
#if ioinit
	jsr ioinit	; Initialise IO command
#endif
#if hibase
	lda #4
	sta hibase
#endif
#if vicreset
	jsr vicreset
#endif
	jmp prompt

xcmd			; eXit cmd
#if target == c64
	lda #$37
	sta pport
	jmp (basnmi)
#endif
#if target == pet
#if ram96latch
	lda bankpp
	sta ram96latch
#endif
	jmp basready
#endif

lsvcmd	;lda #0 	; Load, Save, or Verify command
	ldy #1		; sa
#if setlfs
	ldx fa
	jsr setlfs
#else
	sty sa
#endif
	lda #0
	sta status
	ldx #<huntbuf
	ldy #>huntbuf
#if setnam
	jsr setnam
#else
	sta fnlen
	stx fnadr
	sty fnadr+1
#endif
ll00	jsr inpsksp	; get filename
	cmp #cr 	; .L "filename   only?
	beq do_load
	cmp #quote
	bne ll00
	ldy #0
ic78a	jsr kbdinput
	cmp #quote
	beq ic7a0
	cmp #cr
	beq do_load
	iny
	cpy #end-huntbuf
	bcs errc7
	sta huntbuf-1,y
	sty fnlen
	bne ic78a
ic7a0	jsr eol
	bne ic7c6

do_load lda cmdchr
	cmp #"S"
	beq errc7
	sec
	sbc #"L"        ; set .A <> 0 for Verify
#if 0 && verck	; needed by the normal PET rom routine
	sta verck	; 1 is verify
#endif
#if 1 || target != pet	; ignored by the normal PET rom routine
	ldx stal
	ldy stal+1
#endif
	jsr load
	bcs errc7
	lda status
	and #$10	; verify error
	bne errc7
	jmp prompt

errc7	jmp error

ic7c6	dec sa		; make sa 0, for relocating load
	jsr hex2stal	; get start address to save
	jsr eol
#beq do_load	; if load address given, attempt to load there
	jsr hex2ax	; get end address
	sta eal 	; start in stal, end in eal, as for PET
	stx eal+1
	jsr eol
	bne errc7
	lda cmdchr
	cmp #"S"        ; save
	bne errc7
#if target != pet
	lda #stal	; address for save start address
	ldx eal 	; save end address
	ldy eal+1
#endif
	jsr save
	jmp prompt

#if haveecmd
ecmd	jsr kbdinput
	ldx #$7f
	cmp #"C"
	beq ic9d9
	inx
	cmp #"S"
	bne errc7
ic9d9	stx lrbflag
	jsr getstend
ic9df	ldx ovflow
	bne ic9f1
	jsr steqend
	bcc ic9f1
	jsr docrlrb
	jsr stop
	bne ic9df
ic9f1	jmp cuprpt

docrlrb jsr docr
dolrb	ldx #"."
	lda #"]"
	bit lrbflag
	bmi ica02
	lda #"["
ica02	jsr printxa
	jsr dospc
	jsr lrbadr
	jsr dospc
	ldy #0
ica10	jsr ldastaly
	jsr bin8
	bit lrbflag
	bpl ica21
	iny
	cpy #3
	bcc ica10
	dey
ica21	tya
	jsr addstaa
	rts

lrbadr	bit lrbflag
	bpl ica38
	lda stal	; for sprite add 1
	and #$3f
	cmp #$3f
	bne ica38
	jsr incstal
ica38	jmp hex4

lbcmd	ldx #$7f	; left bracket cmd [
	dc.b $2c
rbcmd	ldx #$80	; right bracket cmd ]
	stx lrbflag
	jsr hex2stal
	ldy #0
icace	jsr bin2a
	jsr stastaly
	bit lrbflag
	bpl icade
	iny
	cpy #3
	bcc icace
icade	jsr printcu
	jsr docrlrb
	lda cmdchr
	jmp filkeyd0
#endif	; haveecmd
errca	jmp error

; Bank cmd.
; Has a nybble as argument on the 64, and
; a byte on the PET.
bcmd	jsr inpsksp
	cmp #cr
	beq icb07
#if target == c64
	jsr hex2nybb
	cmp #8		; only allow banks 0-7 and f
	bcc icb02
	cmp #$0f
	bne errca
	lda #$86	; $80 to flag drive, bank 6 in the 64
icb02	sta bank
	bne prptcb
#endif
#if target == pet
	sta bank0f	; attempt to clear bit 7
	jsr hexa2a
	sta bank
	cmp #$0f
	bne prptcb
	ror bank0f	; c=1: bit 7 := 1 iff bank == 0f
	lda #$00	; set bank for not-in-drive memory
	sta bank
	beq prptcb
#endif
icb07	lda bank
#if target == c64
	bpl icb0e
	lda #"F"-"0"	; $16
icb0e	clc
	adc #"0"
	jsr print
#endif
#if target == pet
	jsr hex2
#endif
prptcb	jmp prompt

qmcmd	jsr inpsksp	; question mark ? cmd
	cmp #cr
	bne icd95
	ldx #0		; provide help on just ?
icd87	lda cmdtab,x
	jsr print
	inx
	cpx #adrtab-cmdtab
	bne icd87
	beq prptcb
icd95	ldx #stal
	jsr hdin4
calcloop
	jsr skipspc
	cmp #cr
	beq icdd6
	pha
	jsr inpsksp
	ldx #memuss
	jsr hdin4
	tay
	pla
	jsr do_op
	tya
	jmp calcloop

do_op	ldx #4
icdb5	cmp optab,x
	beq icdbf
	dex
	bpl icdb5
	bmi errca
icdbf	lda opctab,x
	sta acdcb
	sta acdd1
	asl ;a		; c:=1 for sbc... *dirty*
	lda stal
acdcb	and memuss	; opcode modified
	sta stal
	lda stal+1
acdd1	and memuss+1	; opcode modified
	sta stal+1
	rts

icdd6	jsr docr
	jsr hex4
	jsr dospc
	jsr deci
	jmp prompt

	;+++ begin of i/o routines

adr2stal
	iny
	jsr ldastaly
	tax
	iny
	jsr ldastaly
	sta stal+1
	stx stal
	rts

dotrcr	ldy rtsp	; handle return disassembly
	beq noreturn
	dey
	lda rtstack,y
	sta stal+1
	dey
	lda rtstack,y
	sta stal
	sty rtsp
	jmp scrolld

noreturn
	cmp #$60	; rts
	beq iw02
dotrcj	sec		; up
	jsr getcmd
	bcs waitprtc
	ldy #0
	jsr ldastal
	cmp #$60	; rts
	beq dotrcr
	cmp #$20	; jsr
	bne iw02
	ldx rtsp
	lda stal
	;clc c is 1
	adc #3-1
	sta rtstack,x
	inx
	lda stal+1
	adc #0
	sta rtstack,x
	inx
	stx rtsp
	bne iwabs

iw02	cmp #$4c	; jmp
	bne iw03
iwabs	jsr adr2stal
	jmp scrolld

iw03	cmp #$6c	; jmp()
	bne iw04
	jsr adr2stal
	ldy #$ff
	bne iwabs

iw04	and #%00011111	; branch
	cmp #%00010000
	bne iw05
	iny
	jsr ldastaly
	jsr ad1stala
	tax
	inx ;lo
	bne iw041
	iny ;hi
iw041	stx stal
	sty stal+1
	jmp scrolld

iw05	jmp scrd

#if havepfkeys
dofkeys tax
	ldy pflen-pf1,x
	sty ndx
	lda pfends-pf1,x
	tax
ic801	lda pf1txt,x
	sta keyd-1,y
	dex
	dey
	bne ic801
	beq wait
#endif	; havepfkeys

	subroutine

; this duplicates the rom input routine, inserting
; code for our special keys (cu, cd, stop).
; Also does autorepeat on models that don't have it themselves (3032)

input	tya
	pha
	txa
	pha
	lda #0
	sta lxsp+1
#if autorepeat && 0	; this part serves to get the initial timing
	lda #slowrep	; right. it may be removed in case of
	clc		; memory shortage since it is almost never
	adc time+2	; *really* needed, because usually this function
	sta reptime	; is called with no key pressed.
#endif
	lda crsw	; input from screen or keyboard (cr switch)
	beq wait
	jmp scrget	; get from the screen in rom

waitprtc
	lda datax	; key that has been hit
waitprt jsr scrprint	; print it

wait:
#if 1 && autorepeat
; Use jiffy timer to check when to make a key repeat.
; When no key was pressed, set to slow value.
; When action is taken, set to fast value.
; A key is made to repeat by making the keyboard scanner think
; the previous key was different, which is done by changing lstx.

	lda #slowrep
	ldx #nokey
	cpx lstx
	beq notpressed$

	lda time+2
	cmp reptime
	bmi endrepeat$
#if target == pet
	inc lstx	; not "stx lstx" because that would fool us
			; next time around...
#else
	dec lstx	; for 64 use dec because nokey==64 and this
			; would be bad for scancode 63, as above...
#endif
	lda #fastrep
notpressed$
	clc
	adc time+2
	sta reptime
endrepeat$
#endif
#if 0 && autorepeat
	lda blnct	; abuse cursor blink countdown to check when
	cmp reptime	; to make a key repeat.
	bne endrepeat$	; when no key was pressed, set to slow value.
	ldx #nokey	; when action is taken, set to fast value.
	cpx lstx	; a key is made to repeat by faking the release
	beq notpressed$	; of the key, by setting lstx to #nokey.
	stx lstx
	dec blnct
	lda #20-3	; fastrep
	sta reptime
	bne endrepeat$
notpressed$
	lda #20-17	; slowrep
	sta reptime
endrepeat$
#endif
	lda ndx 	; anything in the keyboard buffer?
	sta blnsw	; if <>0, turn off cursor
#if autodn
	sta autodn
#endif
	beq wait
	lda blnon	; restore char and colour under cursor,
	beq ico00	; if needed
	lda gdbln
#if gdcol
	ldx gdcol
#endif
	lsr blnon
	jsr pokchr
ico00	jsr kbdget	; get char from keyboard buffer

	ldx qtsw	; quote mode switch
	bne ic058	; if in quote mode, don't be fancy
	ldx tblx	; screen line of cursor
	sta datax	; key that has been hit
#if havepfkeys
	cmp #pf1	; check for pf keys
	bcc ic847
	cmp #pf1+8
	bcc dofkeys
#endif
ic847	cmp #$03	; "^c"
	beq dojump
	cmp #$83	; "^C"
	beq doreturn
	cmp #cd 	; cursor down
	beq docd
	cmp #cu 	; cursor up
	beq docu
ic058	cmp #cr 	; return = done
	bne waitprt
	jmp scrcont	; continue input function in rom

dojump
	jmp dotrcj	; follow changed flow of control
doreturn
	jmp dotrcr	; go back to previous jsr

docd	cpx #lines-1	; bottom line
	bcc waitprt
	jsr getcmd	; c = 1: go up
	bcs waitprtc
	lda cmdchr
	cmp #":"
	bne i800
	; scroll up mem dump
	;clc
	lda stal
	adc #hexwidth-1 ;c=1
	sta stal
	bcc ic871
	inc stal+1
ic871	jsr crhexdmp
tab1	lda #1
	sta pntr
	jmp wait

i800	cmp #">"
	bne ic87b
	; scroll up asc dump
	;clc
	lda stal
	adc #ascwidth-1 ;c is 1 (equal)
	sta stal
	bcc i801
	inc stal+1
i801	jsr crascdmp
	jmp tab1

ic87b	cmp #","
	bne ic892
			; scroll up disassembly
scrd	jsr opredu
	jsr adstalen
scrolld ;ldy #","
	jsr ddashes
	jmp tab1

ic892
#if haveecmd
			; scroll up [ or ]
	ldx #$7f
	cmp #"["-$40
	beq ic899
	inx
ic899	stx lrbflag
	clc
	lda #1
	bit lrbflag
	bpl ic8a6
	lda #3
ic8a6	adc stal
	sta stal
	bcc ic8ae
	inc stal+1
ic8ae	jsr docrlrb
	jmp tab1
#endif	; haveecmd

docu	txa
	bne ic8bd
	clc
	jsr getcmd
	bcc ic8c0
ic8bd	jmp waitprtc
ic8c0
#if tmplin
	lda #0
	sta tmplin
#endif
#if [target == pet] && petb2
	dec tblx	; on basic 2.0, this function is meant for
	jsr instlin	; inserting chars onto the next line, opening
	inc tblx	; up the *next* screen line
#else
	jsr instlin
#endif
#if ldtbl
#if hibase
	lda hibase
#else
	lda #<screen
#endif	; hibase
	ora #$80
	sta ldtbl
#endif	; ldtbl
	jsr gohome
	lda cmdchr
	cmp #":"
	bne ic8ed
			; scroll down hex dump
	;sec ; c is already 1 (equal)
	lda stal
	sbc #hexwidth
	sta stal
	bcs ic8e4
	dec stal+1
ic8e4	jsr dohexdmp
hmtab1	jsr gohome
	jmp tab1

ic8ed	cmp #">"
	bne i803
	; scroll down asc dump
	;sec c is already 1
	lda stal
	sbc #ascwidth
	sta stal
	bcs i802
	dec stal+1
i802	jsr doascdmp
	jsr gohome
	jmp tab1

i803	cmp #","
	bne ic93a
			; scroll down dissass
	lda stal
	ldx stal+1
	sta memuss
	stx memuss+1
	lda #$10	; #bytes backwards
	sta dbackup
ic8fe	sec
	lda memuss
	sbc dbackup
	sta stal
	lda memuss+1
	sbc #0
	sta stal+1
ic90c	jsr opredu
	jsr adstalen
	jsr steqend
	beq ic91e
	bcs ic90c
	dec dbackup
	bne ic8fe
ic91e	inc oplen
	lda oplen
	jsr sbcstaa
	jsr ldastal
	lda #","
	jsr dodota
	jsr dinstr2
	jmp hmtab1

ic93a
#if haveecmd
	; scroll down [ or ]
ic93a	jsr decstal
	cmp #"["-$40
	beq ic953
	jsr decstal
	jsr decstal
	lda stal
	and #$3f
	cmp #$3d
	bne ic951
	dec stal	; for sprite, decrement 1 extra
ic951	ldx #$80
ic953	stx lrbflag
	jsr dolrb
	jmp hmtab1
#endif	; haveecmd

;;;;
;
;   getcmd is called with the number of the current line in .X
;   with automatically (pnt) pointing to the same line.

	subroutine

getcmd	ror stal	; remember down (.C=0) or up (.C=1)
	lda pnt
	sta memuss
	lda pnt+1
	sta memuss+1
.top	ldy #0
	lda (memuss),y
	cmp #"."        ; screen code
	beq ic98d
.nextline
	bit stal	; pl=go down
	bpl .down
	sec
	lda memuss
	sbc #columns
	sta memuss
	bcs .2
	dec memuss+1
.2	dex
	bpl .top
	sec		; .c=1: not found
	rts

.down	clc
	lda memuss
	adc #columns
	sta memuss
	bcc .1
	inc memuss+1
.1	inx
	cpx #lines
	bcc .top
	rts

ic98d	iny
	lda (memuss),y
#if haveecmd
	cmp #"["-$40    ; screen-[
	beq .gotcmd
	cmp #"]"-$40    ; ]
	beq .gotcmd
#endif
	cmp #","        ; screen code
	beq .gotcmd
	cmp #">"        ; screen code
	beq .gotcmd
	cmp #":"        ; screen code
	bne .nextline
.gotcmd sta cmdchr
	iny
	jsr scr2stal
	sta stal+1

	; fall through to scr2stal

	subroutine

scr2stal		; convert number in screen code
	jsr scr2nybb
	asl ;a
	asl ;a
	asl ;a
	asl ;a
	sta stal
	jsr scr2nybb
	ora stal
	sta stal
	clc
	rts

	subroutine

scr2nybb
	lda (memuss),y
	iny
	cmp #" "
	beq scr2nybb
	cmp #7	; screen code for "f"
	bcs .1
	adc #9
.1	and #$0f
	rts

	subroutine

usestal sta membyt
	lda stal
	sta memlo
	lda stal+1
	sta memhi
	rts

usemuss sta membyt
	lda memuss
	sta memlo
	lda memuss+1
	sta memhi
	rts

ldastal jsr usestal	; *** note: these funcs must preserve the Carry!
	lda #$ad	; lda abs
	bne setopc

stastal jsr usestal
	lda #$8d	; sta abs
	bne setopc

cmpstal jsr usestal
	lda #$cd	; cmp abs
	bne setopc

stamuss jsr usemuss
	lda #$8d	; sta abs
	bne setopc

cmpmuss jsr usemuss
	lda #$cd	; cmp abs
	bne setopc

ldastaly
	jsr usestal
	lda #$b9	; lda a,y
	bne setopc

stastaly
	jsr usestal
	lda #$99	; sta a,y
;	bne setopc
;
;cmpstaly
;	jsr usestal
;	lda #$d9	; cmp a,y

setopc	sta memopc	; must preserve .A and carry (for opredu)
	stx mem_savx
#if target == c64
	bit bank
#endif
#if target == pet
	bit bank0f
#endif
	bmi diskmem
	bpl icb7f	; always

icb79	pla
	pla
	plp
	ldy mem_savy
icb7f
#if target == c64
	ldx pport
	txa
	and #$38
bank	 = .+1
	ora #7
	sei
	sta pport
#endif	; target == c64
#if [target == pet] && ram96latch
	sei
	ldx bank
	stx ram96latch
	ldx bankpp
#endif	; target == pet
membyt	 = .+1
	lda #8		; constant will be modified

memhi	= memopc+2
memlo	= memopc+1

memopc	lda $ffff,y	; opcode and address will be modified
#if target == c64
	stx pport
	cli
#endif
#if [target == pet] && ram96latch
	stx ram96latch
	cli
#endif	; target == pet
	php
mem_savx = .+1
	ldx #3		; constant will be modified
	plp
	rts

diskmem
	sty mem_savy
	php
	pha		; opcode
	and #$10	; test y-indexing
	bne icba1
	ldy #0
icba1	clc
	tya
	adc memlo	; add .Y
	pha
	lda #0
	adc memhi
#if 1		; we don't want this...
	cmp #$48	; $4800-$c000
	bcc icbb4	; fetch from computer's memory anyway
	cmp #$c0
	bcc icb79
#endif
icbb4	sta memhi
	pla
	sta memlo
	pla		; opcode, test r/w
	and #$60
	cmp #1
	ror rwflag
	ora #$89	; make it an immediate opcode
	sta acc07
	lda #"R"
	bit rwflag ;<0:r
	bmi icbd1
	lda #"W"
icbd1	jsr diskmrw ;m-rw
	lda #1	;1 byte
	jsr iecout
	bit rwflag ;>0:w
	bpl diskw
	jsr unlsn
	lda fa
	jsr talk
	lda #$6f
	jsr tksa
icbeb	lda #0
	sta status
	jsr iecin
	sta diskbytin
	lda status
	and #2
	bne icbeb	; time-out
	jsr iecin
	jsr untlk
	plp
mem_savy    = .+1
	ldy #1		; this constant will be modified
	lda membyt
diskbytin = .+1

acc07	lda #$14	; this opcode and constant will be modified
	rts		; sbc/cmp...

diskw	lda membyt
	jsr iecout
	jsr unlsn
	ldy mem_savy
	lda membyt
	plp
	rts

diskmrw pha
	lda #0
	sta status
	lda fa
	jsr listen
	lda status
	bne errcc
	lda #$6f
	jsr second
	lda #"M"
	jsr iecout
	lda #"-"
	jsr iecout
	pla		;r/w/e
	jsr iecout
	lda memlo
	jsr iecout
	lda memhi
	jmp iecout

errcc	jmp error

atcmd	lsr pflag
	ldy #$ff
icc50	iny
	sta huntbuf-1,y
	jsr kbdinput
	cmp #cr
	bne icc50
	lda #0
	sta status
	tya
	bne diskcmd
	lda fa
	jsr talk
	lda status
	bne errcc
	lda #$6f
	jsr tksa
	lda #cr
icc72	jsr print
	jsr iecin
	ldx status
	beq icc72
	jsr untlk
	jmp prompt
diskcmd lda fa
	jsr listen
	lda status
	bne errcc
	lda huntbuf
	cmp #"$"
	beq dir
	lda #$6f
	jsr second
	jsr buf2bus
	jmp prompt

buf2bus ldx #0
icc9f	lda huntbuf,x
	jsr iecout
	inx
	dey
	bne icc9f
	jmp unlsn

dir	lda #$f0	; do a directory listing - open SA 0
	jsr second
	jsr buf2bus	; send file name = dir specifier
	lda fa		; have the disk talk
	jsr talk
	lda #$60	; on SA 0
	jsr tksa
	ldy #5		; skip load address, link, line number
iccc0	jsr docr
iccc3	sta stal
	jsr bus2a
	dey
	bpl iccc3
	sta stal+1
	jsr deci	; print line number = # of blocks in file
	lda #" "        ; add a space
iccd2	jsr print	; and print the line until a 00 which
	jsr bus2a	; terminates a basic line
	bne iccd2
	ldy #3		; other lines have 4 bytes prefix
	jsr stop
	bne iccc0
icce1	lda fa		; close the file
	jsr listen
	lda #$e0
	jsr busclse
	jmp prompt	; done

bus2a	jsr iecin	; bus to .A
	ldx status	; when EOI set, we're done
	bne icce1
	tax		; set Z flag appropriately
	rts

prtnosup
	cmp #0
	bne print
	rts

crdotysp		; print cr, dot, .Y, space
	tya
	pha
	jsr docr
	pla
dodota	ldx #"."        ; print dot, .A
	jsr printxa
dospc	lda #" "        ; print space
	dc.b $2c
printcu lda #cu 	; print cursor up
	dc.b $2c
gohome	lda #home	; print home
	dc.b $2c
docr	lda #cr 	; print cr

print	bit pflag	; print to printer?
	bpl ice0a
	pha
	lda #printdev
	jsr listen
	lda #$60 + printsa	; sa 7 = print lower case
	jsr second
	pla
	pha
	cmp #quote
	bne ice03
	lda #"'"
ice03	jsr iecout
	jsr unlsn
	pla
ice0a	jmp scrprint

;;;;
;
; This is code duplicating C-64 functionality on the PET.
; In particular it is the relocating loader we're concerned about,
; but we extend it by printing the original load address and
; the actual end address.
;

#if target == pet
	subroutine
load
	stx memuss	    ; desired load start addr
	sty memuss+1
	sta verck	    ; A: verify flag
	lda fa
	cmp #4
	bcs .ieeeload
	jmp romload

.ieeeload
	lda sa
	pha
	lda #$60
	sta sa
	jsr searching	; "searching for filename"
	jsr sendname
	jsr talk
	lda sa
	jsr second
	jsr iecin	; get start address low
	sta eal
	jsr iecin	; and high
	sta eal+1

	jsr loading
	jsr .preal	; print start address

	pla		; get sa back
	bne .absload
	lda memuss
	sta eal
	lda memuss+1
	sta eal+1
.absload
.notimeout
	lda status
	and #$fd	; mask timeout
	sta status

	jsr stop
	beq .endload
	jsr iecin
	tax
	lda status
	lsr
	lsr
	bcs .notimeout
	txa
	ldy verck
	beq .loadbyt

	ldy #0
	cmp (eal),y
	beq .nextbyt
	ldx #$10
	stx status
	bne .nextbyt
.loadbyt
	sta (eal),y
.nextbyt
	inc eal
	bne .1
	inc eal+1
.1	bit status
	bvc .notimeout

.endload
	jsr .preal	; print end address

	jsr untlk
	jsr buslsnclse

	clc
	rts

.preal
	lda eal+1	; print end address
	jsr sphex2
	lda eal
	jmp hex2

#endif

optab	dc.b "+-&!%"
opctab	dc.b $65; adc zpg
	dc.b $e5; sbc  "
	dc.b $25; and  "
	dc.b $05; ora  "
	dc.b $45; eor  "

tenpow	dc.w 1,10,100,1000,10000

#if havepfkeys
pflen	dc.b pf3txt - pf1txt
	dc.b pf5txt - pf3txt
	dc.b pf7txt - pf5txt
	dc.b pf2txt - pf7txt
	dc.b pf4txt - pf2txt
	dc.b pf6txt - pf4txt
	dc.b pf8txt - pf6txt
	dc.b pf8end - pf8txt
pfends	dc.b pf3txt-pf1txt-1
	dc.b pf5txt-pf1txt-1
	dc.b pf7txt-pf1txt-1
	dc.b pf2txt-pf1txt-1
	dc.b pf4txt-pf1txt-1
	dc.b pf6txt-pf1txt-1
	dc.b pf8txt-pf1txt-1
	dc.b pf8end-pf1txt-1
pf1txt	dc.b "        :",cr
pf3txt	dc.b "M0000",cl,cl,cl,cl
pf5txt	dc.b "B0",cr
pf7txt	dc.b "@$0",cr
pf2txt	dc.b cu,cr+128,".A ",cri,cri,cri,cri," "
pf4txt	dc.b "B7",cr
pf6txt	dc.b "BF",cr
pf8txt	dc.b "@$1",cr
pf8end
#endif	; havepfkeys

;used to test for illegal opcodes
illtab	dc.b $40,$02,$45,$03;".^be^c
	dc.b $d0,$08,$40,$09;"p^h.^i
	dc.b $30,$22,$45,$33;"0.e3
	dc.b $d0,$08,$40,$09;"p^h.^i
	dc.b $40,$02,$45,$33;".^be3
	dc.b $d0,$08,$40,$09;"p^h.^i
	dc.b $40,$02,$45,$b3;".^be_
	dc.b $d0,$08,$40,$09;"p^h.^i
	dc.b $00,$22,$44,$33;"..d3
	dc.b $d0,$8c,$44,$00;"p^Ld.
	dc.b $11,$22,$44,$33;"^q.d3
	dc.b $d0,$8c,$44,$9a;"p^Ld^Z
	dc.b $10,$22,$44,$33;"^p.d3
	dc.b $d0,$08,$40,$09;"p^h.^i
	dc.b $10,$22,$44,$33;"^p.d3
	dc.b $d0,$08,$40,$09;"p^h.^i
	dc.b $62,$13,$78,$a9;"B^sX_

modes	dc.b $00,$21,$81,$82
	dc.b $00,$00,$59,$4d
	dc.b $91,$92,$86,$4a
	dc.b $85,$9d
	;      4   8   1 v 2   4   8
modes1	 dc.b ",",")",",","#","(","$"
modes2	 dc.b "Y",$00,"X","$","$",0

;index:reduced opcode
;result:lo byte of packed ascii opcode
rd2pklo  dc.b $1c,$8a,$1c,$23;"^\^J^\#
	dc.b $5d,$8b,$1b,$a1;"]^K^[_
	dc.b $9d,$8a,$1d,$23;"^}^J^]#
	dc.b $9d,$8b,$1d,$a1;"^}^K^]_
	dc.b $00,$29,$19,$ae;".)^y_
	dc.b $69,$a8,$19,$23;"I_^y#
	dc.b $24,$53,$1b,$23;"$s^[#
	dc.b $24,$53,$19,$a1;"$s^y_
	dc.b $00,$1a,$5b,$5b;".^z[[
	dc.b $a5,$69,$24,$24;"_I$$
	dc.b $ae,$ae,$a8,$ad;"____
	dc.b $29,$00,$7c,$00;").\.
	dc.b $15,$9c,$6d,$9c;"^u^|M^|
	dc.b $a5,$69,$29,$53;"_I)s
	dc.b $84,$13,$34,$11;"^D^s4^q
	dc.b $a5,$69,$23,$a0;"_I#_
rd2pkhi dc.b $d8,$62,$5a,$48;"xBzh
	dc.b $26,$62,$94,$88;"&B^T^H
	dc.b $54,$44,$c8,$54;"tdht
	dc.b $68,$44,$e8,$94;"Hd_^T
	dc.b $00,$b4,$08,$84;"._^h^D
	dc.b $74,$b4,$28,$6e;"T_(N
	dc.b $74,$f4,$cc,$4a;"T_lj
	dc.b $72,$f2,$a4,$8a;"R__^J
	dc.b $00,$aa,$a2,$a2;".___
	dc.b $74,$74,$74,$72;"TTTR
	dc.b $44,$68,$b2,$32;"dH_2
	dc.b $b2,$00,$22,$00;"_...
	dc.b $1a,$1a,$26,$26;"^z^z&&
	dc.b $72,$72,$88,$c8;"RR^Hh
	dc.b $c4,$ca,$26,$48;"dj&h
	dc.b $44,$44,$a2,$c8;"dd_h

rtxt	dc.b cr
	dc.b "    PC  IRQ  PP DR AC XR YR SP NV#BDIZC", cr
	dc.b ".; "

cmdtab	dc.b "ABCD"
#if haveecmd
	dc.b "E"
#endif
	dc.b "FGHIJKLMPRSTVXY@,:;"
#if haveecmd
	dc.b "[]"
#endif
	dc.b "<>?"

adrtab	dc.w acmd,bcmd,ccmd,dcmd
#if haveecmd
	dc.w ecmd
#endif
	dc.w fcmd, gcmd, hcmd
	dc.w icmd, jcmd, kcmd
	dc.w lsvcmd, mcmd
	dc.w pcmd, rcmd, lsvcmd, tcmd
	dc.w lsvcmd, xcmd, ycmd
	dc.w atcmd, cmcmd
	dc.w cocmd, sccmd
#if haveecmd
	dc.w lbcmd, rbcmd
#endif
	dc.w ltcmd, htcmd, qmcmd

; local storage from here on:
#if target == pet
bank	dc.b 0
bankpp	dc.b 0
bank0f	dc.b 0	; bit 7 is a flag
#endif
rwflag	dc.b 0
pflag	dc.b 0
rspace	= .
pchi	dc.b 0
pclo	dc.b 0
pssave	dc.b 0
acsave	dc.b 0
xrsave	dc.b 0
yrsave	dc.b 0
spsave	dc.b 0
stackmk dc.b 0
cmdchr	dc.b 0
huntlen dc.b 0
lrbflag dc.b 0
apos	dc.b 0
oplen	dc.b 0	 ;operand length
abuf	dc.b 0,0 ;3 bytes
loleft	dc.b 0
stalsav dc.w 0
ovflow	dc.b 0
ctflag	dc.b 0
mode	dc.b 0
nybble	dc.b 0
dbackup dc.b 0
#if autorepeat
reptime	dc.b slowrep
#endif

huntbuf dc.b "KOSMON  BY KOSMO"
	dc.b "SOFT   V11.10.86"
end	 = .
