2017-11-08
Here's the toolstack I'm using today:
Ubuntu Linux 17.04, bash shell
Sublime Text 3
NodeJS
TiddlyWiki5
Ruby
xa65
make
VICE xpet
git

You could do this with any other operating system, editor or PET emulator,
but at the end of the day, the sole requirement is that it be able to run
on my own Commodore PET 2001-N16, s/n 700251, now with 32K, BASIC 4 ROM,
and a few other bits of hardware added.  Notably this limits the storage
media to cassette tape.

Links:

The project blog is at http://pettil.tumblr.com
Language tiddlywiki at http://chitselb.com/files/tiddlypettil.html

Objectives of the project are, in no particular order:
* make a Forth that runs on my Commodore PET 2001
* have fun
* improve my "6502 assembly golf" skills
* find other people who are interested in this project

Future directions
* have a "Forth written in Forth" (metacompilation)
* implement a retro videogame
* add support for more storage devices
* port PETTIL to other 6502-based computers
** PETTIL-VIC
** PETTIL-64
** PETTIL-128
** Apple-PETTIL

More in the Forth and Programming forums at http://forum.6502.org
Also a few good threads (search for 'chitselb') on comp.lang.forth
There is a Facebook page at https://www.facebook.com/chitselb.pettil/

There is no linker or relocation loader.  `pettil.prg` is a simple
concatenation of three build artifacts:

`pettil.prg` = `pettil-core.obj` + `pettil-studio.obj` + `pettil.sym`

`pettil-core` $0400-$1BFF is the base language runtime, under 6K.
* barebones PETTIL, under 6K.
* Standalone applications (no developer tools) can run with *only* this
* arithmetic, boolean and relational operators
* stack and memory manipulation
* virtual memory support
* inner interpreter
* Sweet-16

`pettil-studio` $6C00-$7FFF (the transient dictionary) contains words
required for development but not for application runtime.  This dictionary
can be released, freeing up the entire 25K of RAM (on a 32K PET) above
`pettil-core` for applications
* outer interpreter
* defining words
* compiler
* assembler
* editor

`pettil-sym` $5C00-$6BFF combined symbol table for both dictionaries

To build PETTIL, clone this repository, install xa65, ruby and VICE.  Try
these commands to see if your build environment will (probably) work.  These
are the version numbers as of the time I'm editing this document, they do
not really matter.  Trickier is getting the emulator settings perfect.

$ grep DESCRIPT /etc/*release
/etc/lsb-release:DISTRIB_DESCRIPTION="Ubuntu 16.04.3 LTS"

$ git --version
git version 2.7.4

$ ruby -v
ruby 2.3.3p222 (2016-11-21 revision 56859) [x86_64-linux]

$ xa --version
xa (xa65) v2.3.5

$ xpet
[Help] [About VICE...]
xpet 3.0 (GTK+ AMD64/x86_64 Linux glibc 2.23 GCC-5.4.0)
Configure it to be a PET 2001-32N, BASIC 4 ROM

$ dpkg -l make
make 4.1-6 amd64  utility for directing compilation

$ git clone https://github.com/chitselb/pettil
$ cd pettil/
pettil$ make

(does a build and launches an xpet running PETTIL)

Please email chitselb@gmail.com
with any suggestions for improving the documentation.  I want my mom to be
able to understand this and run PETTIL.

http://chitselb.com
