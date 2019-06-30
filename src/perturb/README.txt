PERTURB is a 'bag-on-the-side' system, designed for PETTIL test automation.  It  attaches itself to PETTIL by replacing `restart` with PERTURB's own load/start address (PERTURBORG).  This address immediately follows where PETTIL loads.  PERTURBORG is also passed to xa65, along with the complete `pettil-studio` symbol list.  This exposes the internals of PETTIL to PERTURB

0401 BASIC load address
    10 sys1039
040D restart                    <-- switch with PERTURBORG
48
