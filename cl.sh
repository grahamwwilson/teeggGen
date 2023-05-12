#!/bin/sh
#
# Compile TEEGG and link against CERNLIB using 
# particular configuration file (see subroutine teeggx.f that is included)
#
#          Graham W. Wilson    12-MAY-2023
#
# To compile with an alternative configuration file (for example etronOPAL)
#
# ./cl.sh etronOPAL
#
# Currently use --std=legacy. 
# This avoids most warnings, but there are still 3 warnings 
# and 2 common block size errors on Ubuntu 20.04 LTS with gfortran 9.4.0. 
# See compiler.errors file.
#

fn=teegg
config=${1:-egamma}

configfile=${config}-config.f
rm teegg-configfile.f
ln -s ${configfile} teegg-configfile.f

# TEEGG uses CERNLIB CPU time management subroutines: TIMED, TIMEX, TIMEL, TIMEST. 
# Presumably not really necessary - and could be dispensed with to 
# avoid need to compile against CERNLIB.

gfortran --std=legacy -o ${fn} ${fn}.f `cernlib -safe pawlib mathlib kernlib packlib`

exit
