
C-----------------------------
C A test gamma configuration
C-----------------------------

      RADCOR=NONE

      CONFIG=GAMMA
      EB=45.6D0
      TEVETO=50.0D-3
C      TGMIN= 45.0D0 * PI/180.0D0
      TGMIN = ACOS(0.75D0)
      EGMIN=1.0D0

      NEV=10000
      WGHTMX=0.5D0
      TITLE=' A test of lowest order gamma configuration'
C      NXTPAR=2

