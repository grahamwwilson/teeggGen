# teeggGen
Implementation of TEEGG 7.2 event generator for e+e- -> e+e- gamma (gamma) 
for low Q^2 configurations by Dean Karlen

This is based on the zip file sent by Dean on 05-MAY-2023. 
I have modified the OPAL specific code so that it works 
stand-alone compiled against CERNLIB.
Works for me on Ubuntu 20.04 LTS with gfortran 9.4.0.

Also included in this repository are the preprint and 
the user guide (teegg.pdf). The underlying tex was updated so that 
the user guide is compilable with a modern TeX implementation.

Included in the various *-config file are example configurations.

With the current code the log file goes to fortran unit 7 and the 
4-vector file (written by evwrite.f) to unit 25.
