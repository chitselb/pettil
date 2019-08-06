PERTURB is PETTIL's test automation system, with a backronym of: PETTIL Enthusiastic Regression Testing Usually Reduces Bugs.  It unironically brings test automation to the 8-bit era, springing up virtual PETs as fast as the host can launch them.

Each PET perform its assigned `feat` then exits, leaving behind a farewell screenshot in the pettil/tmp/perturb/ directory.  These images should match a reference screenshot, stored in pettil/data/perturb/

If this screenshot matches the reference screen for this feat, then you get
an avocado (🥑) in pettil/perturb.log and the test is considered PASS

If any of these are true
    a) PERTURB produces a screenshot for which there is no reference screen
    b) PERTURB does not produce a screenshot which has a reference screen
    c) PERTURB and reference screenshots are not pixel-for-pixel the same
then it's a tomato (🍅) for your pettil/perturb.log, test FAIL

There are two types of test, "hosted" which means test source code is cross-compiled on the development host in `xa65`.  The other type is "native"
where the feat is performed entirely from source code in screens that will be
compiled and run in PETTIL on the virtual PET.

PERTURB uses the oft-maligned "bag-on-the-side" design pattern, but we did not
call them `design patterns` yet.  Our bag-on-the-side approach starts with a freshly-built PETTIL binary.

For each PETTIL binary in pettil/obj/PETTIL
    Do all of this
    get the TARGETID (a single digit, the last character of the filename)
        0 = PET #700251
        1 = PET Upgrade ROM
        2 = PET 4.0 ROM
        3 = PET 80 column
        4 = VIC-20 expanded
        5 = C=64
        6 = C128
        7 = Plus/4

    For each FEAT directory in pettil/src/perturb/FEAT/
        Do all of this
        figure out the start address of FEAT and link it in
            This is the address immediately after PETTIL loads from tape
            (or disk) and it replaces `restart` at 15 bytes into the PETTIL
        run `xa65` to build a perturb object in pettil/obj/perturb/
        VICE emulator launches a virtual PET to run the object

  PERTURB patches itself in at `restart` with every
feat on every platform, and builds an object file, using `xa65`, from
pettil/src/perturb/ into pettil/obj/perturb/ feat  e.g. src/perturb/iv/*.i65 .  Next, the VICE emulator launches a PET (or VIC-20 or
Plus/4, you get the idea...) which performs that feat, and finishes.

 into  a 'bag-on-the-side' system, designed for PETTIL test automation.  It  attaches itself to PETTIL by replacing `restart` with PERTURB's own load/start address (PERTURBORG).  This address immediately follows where PETTIL loads.  PERTURBORG is also passed to xa65, along with the complete `pettil-studio` symbol list.  This exposes the internals of PETTIL to PERTURB

0401 BASIC load address
    10 sys1039
040D restart                    <-- switch with PERTURBORG
48
