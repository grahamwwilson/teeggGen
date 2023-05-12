CDECK  ID>, BLANKDEK.   
*CMZ :  3.21/02 29/03/94  15.41.18  by  S.Giani
*-- Author :
CDECK  ID>, TEGCBC. 
************************************************************************
CDECK  ID>, TEGPAT. 
************************************************************************
*.
*.    -----------
*.    Version 7.2
*.    -----------
*.
*.    Dean Karlen
*.    Carleton University, Ottawa, Canada
*.    April 1989
*.
*.**********************************************************************
*.*                                                                    *
*.* TEEGG - A monte carlo event generator to simulate the process,     *
*.*                                                                    *
*.*          +  -      +  -                                            *
*.*         e  e  --> e  e  gamma (gamma)    for t-channel dominated   *
*.*                                          configurations.           *
*.*                                                                    *
*.* Reference: D. Karlen, Nucl. Phys. B289 (1987) 23                   *
*.*                                                                    *
*.* > The three different configurations with their input parameters:  *
*.*    1) e-gamma (Both an electron and gamma are 'seen'):             *
*.*       TEVETO - maximum theta of the 'missing' electron             *
*.*       TEMIN  - minimum theta of the 'seen' electron  |TEMIN and/or *
*.*       TGMIN  - minimum theta of the 'seen' gamma     | TGMIN>TEVETO*
*.*       EEMIN  - minimum energy of the 'seen' electron               *
*.*       EGMIN  - minimum energy of the 'seen' gamma                  *
*.*    2) electron (Only the electron is 'seen'):                      *
*.*       TEVETO - maximum theta of the 'missing' electron             *
*.*       TEMIN  - minimum theta of the 'seen' electron   |TEMIN>TEVETO*
*.*       TGVETO - maximum theta of the 'missing' gamma(s)|TEMIN>TGVETO*
*.*       EEMIN  - minimum energy of the 'seen' electron               *
*.*    3) gamma (Only the gamma is 'seen'):                            *
*.*       TEVETO - maximum theta of the 'missing' electrons            *
*.*       TGMIN  - minimum theta of the 'seen' gamma       TGMIN>TEVETO*
*.*       EGMIN  - minimum energy of the 'seen' gamma                  *
*.*                                                                    *
*.* > The fourth order process is divided into two regions:            *
*.*    1) SOFT PART - second gamma has energy < CUTOFF (in CM frame)   *
*.*                 - only one photon is generated                     *
*.*    2) HARD PART - second gamma has energy > CUTOFF (in CM frame)   *
*.*   The two regions must be generated separately.                    *
*.*                                                                    *
*.**********************************************************************
*.
*. Changes since Version 7.0:
*.
*.    -----------
*.    Version 7.2   April 1989, Carleton Univesity
*.    -----------
*.
*. o redefine the definition of phi-ks in cm frame for 4 body final
*.   state. Change the generation of this angle to include the peak
*.   at phi-ks=pi when refered to phi_k. This introduces two new
*.   parameters:
*.     FRAPHI - the fraction of trial events generated with the
*.              phi_ks peak.
*.     EPSPHI - the cutoff variable in the phi_ks peak distribution
*.   This change was made to eliminate the large weights sometimes
*.   observed for special configurations (GAMMAE type) in version 7.1.
*.   The default, FRAPHI=0., turns off this new peaked generation.
*. o replace the calculation of DILOG by the CERNLIB version.
*.
*.    -----------
*.    Version 7.1   June 1987, Stanford Linear Accelerator Center
*.    -----------
*.
*. o form of 3rd order EPA cross section put in terms of invariants
*. o add Martinez/Miquel matrix element for e-e-g-g (very CPU intensive)
*. o allow generation of weighted events (useful for looking at
*.   distributions and calculating cross sections for many acceptances).
*. o new configuration: GAMMAE, 4th order single photon with a (soft)
*.   electron in the acceptance.
*. o new MTRXGG: HEEGG, a hybrid of EPADC and BEEGG
*.
*.The program consists of the following:
*.
*.User callable routines:
*.    TEEGGI,TEEGGL,TEEGG7,TEEGGC,TEEGGP,TEEGGA
*.Internal routines:
*.    T3BODY,T4BODY,FQPEG,DMORK,SPENCE,TBOORT,BEEGGC,BCOLL,BEEGGM,TPRD
*.    INMART,MEEGGC
*.Routines supplied by Martinez/Miquel:
*.    ELEMAT,AMTOTM,AMPLIM,ZMART,SPININ
*.
*.How to Use This Program With Another Monte Carlo System.
*.--------------------------------------------------------
*.
*.1) Initialization
*.   --------------
*. - Call TEEGGI to set the defaults for all the parameters.
*. - modify parameters as desired
*. - Initialize the random number by: CALL RNDIN(ISEED)
*. - Call the logical function, TEEGGL(OLUN). This checks the validity
*.   of the parameters and calculates some constants to be used later.
*.   Returns .TRUE. if parameters are valid; .FALSE. if not. Use
*.   OLUN to specify the logical unit number for error messages to be
*.   printed. TEEGGL must be called before any new generation of events.
*. > Input parameters are found in common TINPAR
*. > Constants calculated by TEEGGL are in common TCONST
*.
*.2) Generation
*.   ----------
*. - Call TEEGG7 to generate one event.
*. > Event information (4-vectors) are found in common TEVENT
*.
*.3) End of generation
*.   -----------------
*. - Call TEEGGC to calculate efficiencies and total cross section from
*.   the last event sample generated.
*. - Call TEEGGP(OLUN) to print out a summary header of the parameters
*.   and results from the last event generation (on unit OLUN).
*. > Summary information filled by TEEGGC is found in common TSMMRY
*.
*.Routines That Must be Provided (site dependant):
*.------------------------------------------------
*.
*.SUBROUTINE RNDGEN(NRND)
*. - fill the REAL*4 array, RND(i) (i=1,NRND) (in COMMON TRND) with
*.   pseudo random numbers equidistributed between 0 and 1.
*. - optionally modify the varaibles in common TRND as follows:
*.   - fill SEED with the seed required to generate the current set of
*.     random numbers
*.   - fill NXSEED with the seed required to generate the next set of
*.     random numbers
*.
*.SUBROUTINE RNDIN(JSEED)
*. - initialize random number generator with INTEGER*4 seed JSEED
*. - optionally:
*.   - fill NXSEED with JSEED. (Seed required to generate the next set
*.     of random numbers)
*.
*.Unweighted vs. weighted events
*.------------------------------
*.
*.An unweighted event sample is the easiest to use, as it represents the
*.results from a hypothetical experiment.
*.
*.If an integrated cross section with a more complicated acceptance than
*.can be specified with the input parameters is desired (eg. a pt cut),
*.greater efficiency can be obtained using weighted events.
*.This form of generation is specified by setting UNWGHT=.FALSE.
*.The routine, TEEGGA, can be used in this integration, as follows.
*.After an event is generated, call TEEGGA(var1,var2,sig,ersig) if it
*.passes the complicated acceptance. The variables, var1 and var2
*.are REAL*8 variables that are used to accumulate the total weights and
*.should be set to 0 before event generation. By using other pairs of
*.variables, many acceptances can be calculated at once. After the event
*.generation, and after TEEGGC is called, call TEEGGA once again and the
*.total cross section and error is returned in sig and ersig.
*.The use of weighted events in histogramming is more efficient also.
*.The variable WGHT in common TEVENT specifies the event weight.

CDECK  ID>, TEEGGI. 
*.
*...TEEGGI   initilizes parameters for TEEGG.
*.
*. SEQUENCE  : TEGCOM
*. CALLS     : RNDGEN
*. CALLED    : USINIT,TEEGM
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************


C-----------------------------------------------------------------------
C SUBROUTINE TEEGGI : Sets default values for the parameters.
C-----------------------------------------------------------------------

      SUBROUTINE TEEGGI
      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


C.....EB = energy of e beam (in GeV)
      EB = 14.5 D0

C.....RADCOR= HARD  generate e+ e- gamma gamma
C           = SOFT  e+ e- gamma(with soft brem and virtual corrections)
C           = NONE  e+ e- gamma(according to lowest order diagrams only)
      RADCOR= NONE

C.....CONFIG= EGAMMA  then generate according to e-gamma configuration
C           = ETRON   then generate according to single electron config.
C           = GAMMA   then generate according to single gamma config.
C           = GAMMAE  then generate accrdng to sngl gamma/soft e config.
      CONFIG= EGAMMA

C.....MATRIX = BK    then use Berends & Kleiss matrix element
C            = BKM2  then use    "        "      "    " with m**2/t term
C            = TCHAN then use t channel only matrix element (/w m term)
C            = EPA   then use matrix element from EPA (for testing)
      MATRIX = BKM2

C.....MTRXGG = EPADC then use EPA with double compton (RADCOR=HARD only)
C            = BEEGG then use Berends et al. e-e-g-g  (RADCOR=HARD only)
C            = MEEGG then use Martinez/Miquel e-e-g-g (RADCOR=HARD only)
C            = HEEGG then use EPA for low Q**2, BEEGG otherwise ("   " )
      MTRXGG = EPADC

C.....TEVETO = maximum theta of 'missing' e's in final state (in radians
      TEVETO = 100.D-3

C.....TEMIN = minimum angle between the 'seen' electron and beam line
C             (used for e-gamma & etron configurations)     (in radians)
      TEMIN = ACOS(.75D0)

C.....TGMIN = minimum angle between the 1st gamma and the beam line
C             (used for the e-gamma & gamma configurations) (in radians)
      TGMIN = ACOS(.75D0)

C.....TGVETO = maximum angle between the 'missing' 1st gamma & beam line
C             (only used for etron configuration)           (in radians)
C             (also used in for the gamma configuration to veto 2nd g)
      TGVETO = 50.D-3

C.....EEMIN = minimum energy of the 'observed' electron (in GeV)
C             (used for the e-gamma & electron configurations)
      EEMIN = 2.00 D0

C.....EGMIN = minimum energy of the 'observed' 1st photon (in GeV)
C             (used for the e-gamma & gamma configurations)
      EGMIN = 2.00 D0

C.....PEGMIN= minimum separation of e and gamma in phi (in radians)
C             (used for egamma configuration with hard rad. correction)
      PEGMIN= PI/4.D0

C.....EEVETO= energy of electron required to act as a veto (in GeV)
C             (used for gamma configuration with hard rad. correction)
      EEVETO= 0.0 D0

C.....EGVETO= energy of gamma required to act as a veto (in GeV)
C             (used for etron&gamma configs with hard rad. correction)
      EGVETO= 0.0 D0

C.....PHVETO= separation of two particles in phi reqd. to act as a veto
C             (used for e-g separation in etron config. and g-gs separ.
C             in gamma config... all for hard rod. correction only)
      PHVETO= PI/4.D0

C.....CUTOFF = CM cutoff energy for radiative correction (in GeV)
      CUTOFF = 0.25 D0

C.....WGHT1M = maximum weight for generation of QP0 & cos(theta QP)
      WGHT1M = 1.001 D0

C.....WGHTMX = maximum weight of the trial events
      WGHTMX = 1.00 D0

C.....EPS = arbitrary small parameter, used to stabilize weights.
C           It determines the relative sampling of ks^pbc vs. ks^0; if
C           large weights occur due to very hard 2nd photon,decrease EPS
      EPS = 0.01 D0

C.....FRAPHI = defines the fraction of trial events generated with the
C              peaked distribution for phi_ks. This is useful to reduce
C              large weights for configurations like GAMMAE. By default,
C              phi_ks is generated only with a flat distribution.
      FRAPHI = 0.0D0

C.....EPSPHI = small parameter that determines the 'cutoff' of the
C              peaked distribution for phi_ks.
      EPSPHI = 1.0 D-4

C.....ISEED = initial seed
      ISEED = 123456789

C Initialize random number generator
      CALL  RNDIN(ISEED)

C.....UNWGHT = logical variable, specifies if unweighted events are reqd
C            = TRUE  Then events are unweighted (each event weight=1)
C            = FALSE Then events are weighted(event weight given by WGHT
      UNWGHT = .TRUE.

      RETURN
      END

CDECK  ID>, TEEGGL. 
*.
*...TEEGGL   checks that the parameters for TEEGG are valid.
*.
*.     TEEGGL is a logical function that returns true if the set
*.     of parameters supplied to TEEGG is valid. TEEGGL returns
*.     false and error messages generated otherwise.
*.
*. INPUT     : OLUN  logical unit number to write error messages (if any
*.
*. SEQUENCE  : TEGCOM
*. CALLS     : FQPEG,INMART
*. CALLED    : USINIT,TEEGGM
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.2
*. CREATED   : 29-Jun-87
*. LAST MOD  : 10-Apr-89
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*. 10-Apr-89   Dean Karlen   Add checks for FRAPHI and EPSPHI
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C LOGICAL FUNCTION TEEGGL: Checks parameters and calculates constants.
C-----------------------------------------------------------------------

      FUNCTION TEEGGL(OLUN)

C Returns .TRUE. if okay ; .FALSE. if parameters are invalid.
C OLUN is the unit number to write out any error messages.

      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


      LOGICAL TEEGGL
      INTEGER   OLUN
      DOUBLE PRECISION
     >       SINTST,QP0MAX,MINEE,MINEG,MINQP,ECMMIN,SINT1,SINT2,TKMIN
     >,      PBCMIN

      EXTERNAL FQPEG
      DOUBLE PRECISION FQPEG

      TEEGGL=.TRUE.

C Run through various parameters, and check for validity

      IF(EB .LT. 0.1 D0 )THEN
         TEEGGL=.FALSE.
         WRITE(OLUN,*)'EB is too small. EB must be greater than .1 GeV'
      ENDIF

      IF(MAX(MAX(MAX(TEVETO,TEMIN),TGMIN),TGVETO) .GT. PI/2.D0)THEN
         TEEGGL=.FALSE.
         WRITE(OLUN,*)'All ANGLE parameters must be less than pi/2'
      ENDIF

      IF(MIN(MIN(MIN(TEVETO,TEMIN),TGMIN),TGVETO) .LE.  0.D0)THEN
         TEEGGL=.FALSE.
         WRITE(OLUN,*)'All ANGLE parameters must be greater than 0'
      ENDIF

      IF(CUTOFF .LE.  0.D0 .AND. RADCOR.NE.NONE)THEN
         TEEGGL=.FALSE.
         WRITE(OLUN,*)'CUTOFF must be greater than 0'
      ENDIF

      IF(EEMIN.LT.1.D-4*EB .AND. CONFIG.EQ.ETRON)THEN
         TEEGGL=.FALSE.
         WRITE(OLUN,*)'EEMIN must be at least EB/10000. '
      ENDIF

      IF(EGMIN.LT.1.D-4*EB .AND. CONFIG.NE.ETRON)THEN
         TEEGGL=.FALSE.
         WRITE(OLUN,*)'EGMIN must be at least EB/10000. '
      ENDIF

      IF(CONFIG.EQ.EGAMMA)THEN

         IF(TEVETO.GE.TEMIN .AND. TEVETO.GE.TGMIN)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'TEMIN or TGMIN must be greater than TEVETO'
         ENDIF

      ELSE IF(CONFIG.EQ.GAMMA)THEN

         IF(TEVETO  .GE. TGMIN)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'TEVETO must be less than TGMIN'
         ENDIF

      ELSE IF(CONFIG.EQ.GAMMAE)THEN

         IF(RADCOR.NE.HARD)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'GAMMAE only valid for RADCOR = HARD'
         ENDIF
         IF(TEVETO  .GE. TGMIN)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'TEVETO must be less than TGMIN'
         ENDIF
         IF(TGVETO  .GE. TGMIN)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'TGVETO must be less than TGMIN'
         ENDIF
         IF(TGVETO  .GT. TEVETO)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'TGVETO must be less than or equal to TEVETO'
         ENDIF
         IF(EEVETO .LT. M)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'EEVETO must be greater than m_e'
         ENDIF

      ELSE IF(CONFIG.EQ.ETRON)THEN

         IF(TEVETO.GE.TEMIN)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'TEVETO must be less than TEMIN'
         ENDIF
C The following is made for convenience. If necessary it can be removed,
C but then theta-gamma generation must allow +z side final state.
         IF(TGVETO.GE.TEMIN)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'TGVETO must be less than TEMIN'
         ENDIF

      ELSE

         TEEGGL=.FALSE.
         WRITE(OLUN,*)'Invalid configuration. Choose EGAMMA, GAMMA, ',
     >                ' or ETRON.'

      ENDIF

      IF(RADCOR.NE.HARD .AND. RADCOR.NE.SOFT .AND. RADCOR.NE.NONE)THEN
         TEEGGL=.FALSE.
         WRITE(OLUN,*)'Invalid RADCOR. Choose HARD, SOFT,or NONE.'
      ENDIF

C Check that MATRIX element is consistent with RADCOR

      IF(RADCOR.NE.HARD)THEN
         IF(MATRIX.NE.BK    .AND. MATRIX.NE.BKM2 .AND.
     >      MATRIX.NE.TCHAN .AND. MATRIX.NE.EPA       )THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'Invalid MATRIX. Choose BK, BKM2, TCHAN,or EPA'
         ENDIF
      ELSE
         IF(MTRXGG.NE.EPADC .AND. MTRXGG.NE.BEEGG .AND.
     >      MTRXGG.NE.MEEGG .AND. MTRXGG.NE.HEEGG      )THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)
     >      'Invalid MTRXGG. Choose EPADC, BEEGG, MEEGG, or HEEGG'
         ENDIF

         IF(MTRXGG.EQ.BEEGG)THEN
          IF(CONFIG.EQ.GAMMA)
     >    WRITE(OLUN,*)'MTRXGG=BEEGG may not valid be for CONFIG=GAMMA'
          IF(CONFIG.EQ.ETRON)
     >    WRITE(OLUN,*)'MTRXGG=BEEGG may not valid be for CONFIG=ETRON'
          IF(CONFIG.EQ.GAMMAE)
     >    WRITE(OLUN,*)'MTRXGG=BEEGG may not valid be for CONFIG=GAMMAE'
         ENDIF

      ENDIF

      IF(RADCOR.EQ.HARD .AND. EPS.LE.0.D0)THEN
         TEEGGL=.FALSE.
         WRITE(OLUN,*)'EPS must be greater than 0.'
      ENDIF

      IF(RADCOR.EQ.HARD)THEN
         IF(FRAPHI.LT.0.D0 .OR. FRAPHI.GT.1.D0)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'FRAPHI must be between 0. and 1.'
         ELSE IF(EPSPHI.LT.1.D-6 .OR. EPSPHI.GT.1.D0)THEN
            TEEGGL=.FALSE.
            WRITE(OLUN,*)'EPSPHI must be between 1.D-6 and 1.'
         ENDIF
      ENDIF


C If the parameters look good, continue on...

      IF(TEEGGL)THEN

C Keep track of the initial seed

         BSEED=NXSEED

C Initialize some variables.

         NTRIAL=0
         NPASSQ=0
         NACC  =0
         W1MAX =0.D0
         WMAX  =0.D0
         WMINSF=1.D20
         Q2W2MX=0.D0
         SUMW1 =0.D0
         SUMW12=0.D0
         SUMWGT=0.D0
         SUMW2 =0.D0
         ASOFTC=1.D0
         CONVER=0.D0

         P(13)=0.D0
         P(14)=0.D0
         P(15)=0.D0
         P(16)=0.D0

C Some useful constants
         S=4.D0*EB**2
         SQRTS=2.D0*EB
         EBP = SQRT(EB**2 -M**2)
         EPSLON=2.D0*M**2/S

         CDELT=COS(TEVETO)
C CDELT1 = 1 - COS(TEVETO)
         CDELT1 = 2.D0 * SIN(TEVETO/2.D0)**2
C CTGVT1 = 1 - COS(TGVETO)
         CTGVT1 = 2.D0 * SIN(TGVETO/2.D0)**2
         ACTEM = ABS(COS(TEMIN))
         ACTK  = ABS(COS(TGMIN))

C Calculate constants required for generation of the phase space vars
C First for the soft generation.

         IF(RADCOR.EQ.NONE .OR. RADCOR.EQ.SOFT)THEN

C #1 - QP0
C FQPMAX = EB - QP0max
C Note that this can be a small number compared to EB, so care must be
C taken.
C Also, a check is made to see if the config is kinematically allowed

            IF(CONFIG.EQ.EGAMMA)THEN

               FQPMAX = FQPEG(TEMIN,TGMIN,EEMIN,EGMIN,TEVETO,EB)

            ELSE IF(CONFIG.EQ.GAMMA)THEN

               FQPMAX = EB*( EGMIN*SIN((TGMIN-TEVETO)/2.D0)**2 /
     >                       (EB-EGMIN*COS((TGMIN-TEVETO)/2.D0)**2) )
               SINTST = EGMIN*SIN(TGMIN-TEVETO)/(EB+FQPMAX-EGMIN)
               IF(SINTST.GT.SIN(2.D0*TEVETO))FQPMAX=-1.

            ELSE IF(CONFIG.EQ.ETRON)THEN

               FQPMAX = SQRTS*EEMIN*SIN((TEMIN-TEVETO)/2.D0)**2 /
     >                  (SQRTS - EEMIN*(1.D0+COS(TEMIN-TEVETO)))
               SINTST = EEMIN*SIN(TEMIN-TEVETO)/(EB+FQPMAX-EEMIN)
               IF(SINTST.GT.SIN(TGVETO+TEVETO))FQPMAX=-1.

            ENDIF

C Here we check if the choice is kinematically impossible.

            IF(FQPMAX.LT.0.D0)THEN
               WRITE(OLUN,*)'Sorry, your choice of parameters is',
     >                      ' kinematically impossible!'
               TEEGGL=.FALSE.
            ELSE
               QP0MAX=EB-FQPMAX
               QP0MIN=10.*M

               ZMAX=QP0MAX/FQPMAX
               LOGZ0M=LOG(1.D0 + CDELT1/EPSLON*ZMAX**2)

C #2 - COS(thetaQP)

C #3 - COS(thetaK)

               IF(CONFIG.EQ.EGAMMA .OR. CONFIG.EQ.ETRON)THEN

C Check if kinematics give a stronger limit on theta-gamma than given

                  SINT1=EEMIN * SIN(TEMIN+TEVETO) *
     >                  ( EB - EEMIN*SIN((TEMIN+TEVETO)/2.D0)**2 )
     >              /   ( EB**2 - EEMIN*(SQRTS-EEMIN) *
     >                          SIN((TEMIN+TEVETO)/2.D0)**2 )
                  SINT2=EEMIN * SIN(TEMIN-TEVETO) *
     >                  ( EB - EEMIN*COS((TEMIN-TEVETO)/2.D0)**2 )
     >              /   ( EB**2 - EEMIN*(SQRTS-EEMIN) *
     >                          COS((TEMIN-TEVETO)/2.D0)**2 )
                  TKMIN=ASIN(MIN(SINT1,SINT2))-TEVETO
                  IF(CONFIG.EQ.ETRON )TKMIN=MAX(0.D0,TKMIN)
                  IF(CONFIG.EQ.EGAMMA)TKMIN=MAX(TGMIN,TKMIN)

                  CTGM1M = 2.D0 * SIN(TKMIN/2.D0)**2 + EPSLON
                  IF(CONFIG.EQ.ETRON)
     >               FACT3=(2.D0*SIN(TGVETO/2.D0)**2 + EPSLON)/CTGM1M
                  IF(CONFIG.EQ.EGAMMA)
     >               FACT3=(1.D0+COS(TKMIN) + EPSLON)/CTGM1M

               ELSE

                  CTGM1M = 2.D0 * SIN(TGMIN/2.D0)**2 + EPSLON
                  FACT3=(1.D0+COS(TGMIN)+EPSLON)/CTGM1M

               ENDIF

C #4 - PHI K

C #5 - PHI QP

            ENDIF

C Now for the hard generation

         ELSE IF(RADCOR.EQ.HARD)THEN

C #1 - QP0
C FQPMAX = EB - QP0max

            IF(CONFIG.EQ.EGAMMA)THEN

               FQPMAX = MIN( ( EB*EGMIN*SIN((TGMIN+TEVETO)/2.D0)**2
     >                        +EB*EEMIN*SIN((TEMIN-TEVETO)/2.D0)**2
     >                        -EGMIN*EEMIN*SIN((TGMIN+TEMIN)/2.D0)**2 )
     >                      /( EB - EGMIN*COS(TGMIN+TEVETO/2.D0)**2
     >                            - EEMIN*COS(TEMIN-TEVETO/2.D0)**2 )  ,

     >                       ( EB*EEMIN*SIN((TEMIN+TEVETO)/2.D0)**2
     >                        +EB*EGMIN*SIN((TGMIN-TEVETO)/2.D0)**2
     >                        -EEMIN*EGMIN*SIN((TEMIN+TGMIN)/2.D0)**2 )
     >                      /( EB - EEMIN*COS(TEMIN+TEVETO/2.D0)**2
     >                            - EGMIN*COS(TGMIN-TEVETO/2.D0)**2 )  )

            ELSE IF(CONFIG.EQ.GAMMA .OR. CONFIG.EQ.GAMMAE)THEN

               FQPMAX = EB*( EGMIN*SIN((TGMIN-TEVETO)/2.D0)**2 /
     >                       (EB-EGMIN*COS((TGMIN-TEVETO)/2.D0)**2) )
               SINTST = EGMIN*SIN(TGMIN-TEVETO)/(EB+FQPMAX-EGMIN)
               IF(SINTST.GT.SIN(2.D0*TEVETO))FQPMAX=-1.

            ELSE IF(CONFIG.EQ.ETRON)THEN

               FQPMAX = SQRTS*EEMIN*SIN((TEMIN-TEVETO)/2.D0)**2 /
     >                  (SQRTS - EEMIN*(1.D0+COS(TEMIN-TEVETO)))
               SINTST = EEMIN*SIN(TEMIN-TEVETO)/(EB+FQPMAX-EEMIN)
               IF(SINTST.GT.SIN(TGVETO+TEVETO))FQPMAX=-1.

            ENDIF

C Here we check if the choice is kinematically impossible.

            IF(FQPMAX.LT.0.D0)THEN
               WRITE(OLUN,*)'Sorry, your choice of parameters is',
     >                      ' kinematically impossible!'
               TEEGGL=.FALSE.
            ELSE

               QP0MAX=EB-FQPMAX
               QP0MIN=10.*M

               ZMAX=QP0MAX/FQPMAX
               PBCMIN= SQRT( (S+M**2)*FQPMAX/EB - 2.D0*M**2)/2.D0
               LOGZ0M=LOG(1.D0 + CDELT1/EPSLON*ZMAX**2)

               IF(CUTOFF.GE.PBCMIN*(1.D0+EPS))THEN
                  WRITE(OLUN,*)'Your choice of CUTOFF is too large.'
                  TEEGGL=.FALSE.
               ELSE
                  LOGRSM=LOG( (PBCMIN*(1.D0+EPS) - CUTOFF)/(EPS*CUTOFF))
               ENDIF

C #2 - COS(thetaQP)

C #3 - COS(thetaK)

               IF(CONFIG.EQ.ETRON .OR. CONFIG.EQ.GAMMAE)THEN

                  CTGM1M = EPSLON
                  FACT3=(2.D0*SIN(TGVETO/2.D0)**2 + EPSLON)/CTGM1M

               ELSE

                  CTGM1M = 2.D0 * SIN(TGMIN/2.D0)**2 + EPSLON
                  FACT3=(1.D0+COS(TGMIN)+EPSLON)/CTGM1M

               ENDIF

C #4 - PHI K
C #5 - PHI QP
C #6 - KS

C #7 - Theta KS

               FACT7=(1.D0+2.D0/EPSLON)

C #8 - Phi KS

C Additional initialization is required for the Martinez/Miquel ME.
               IF(MTRXGG.EQ.MEEGG)CALL INMART

            ENDIF

         ENDIF

C Now finished with the constant calculations. Check few more parameters

         IF(TEEGGL)THEN

C Let the user know if he's working inefficiently

            IF(CDELT1 .LT. 10.D0 * 2.D0*M**2/QP0MIN/SQRTS)
     >         WRITE(OLUN,*)'Warning: The choice of TEVETO is so '
     >,        'small as to cause this program to be inefficient'
            IF(FQPMAX .LT. 10.D0 * 2.D0*M**2/SQRTS)
     >         WRITE(OLUN,*)'Warning: TEMIN or TGMIN '
     >,       'so close to TEVETO causes this program to be inefficient'

C Here a check on the minimum energy of the missing e or gamma is made.

           IF(CONFIG.EQ.GAMMA .OR. CONFIG.EQ.GAMMAE)THEN
               MINQP = SQRTS/(1.D0+ (SIN(2.D0*TEVETO)+SIN(TGMIN-TEVETO))
     >                 /SIN(TGMIN+TEVETO))
               MINEE = (SQRTS-MINQP)*SIN(TGMIN-TEVETO) /
     >                 ( SIN(2.D0*TEVETO) + SIN(TGMIN-TEVETO) )
               IF(MINEE.LT. 1.D-3 * EB)
     >            WRITE(OLUN,*)'SEVERE Warning: TGMIN'
     >,           ' may be too close to TEVETO to trust the results!!!'
            ELSE IF(CONFIG.EQ.ETRON)THEN
               MINQP =SQRTS/(1.D0+(SIN(TGVETO+TEVETO)+SIN(TEMIN-TEVETO))
     >                 /SIN(TEMIN+TGVETO))
               MINEG = (SQRTS-MINQP)*SIN(TEMIN-TEVETO) /
     >                 ( SIN(TGVETO+TEVETO) + SIN(TEMIN-TEVETO) )
               IF(MINEG.LT. 1.D-3 * EB)
     >            WRITE(OLUN,*)'SEVERE Warning: TEMIN'
     >,           ' may be too close to TEVETO to trust the results!!!'
            ENDIF

C Here check that CUTOFF is much less than the minimum total CM energy

            IF(RADCOR.EQ.SOFT.OR.RADCOR.EQ.HARD)THEN
               ECMMIN=2.D0*SQRT(EB*FQPMAX)
               IF(CUTOFF.GT.ECMMIN/2.)THEN
                  WRITE(OLUN,*)'SEVERE Warning: CUTOFF is much '
     >,           'too large for the chosen set of parameters.'
                  WRITE(OLUN,*)'Do not trust the results.'
                  WRITE(OLUN,800)ECMMIN/10.D0
               ELSE IF(CUTOFF.GT.ECMMIN/10.)THEN
                  WRITE(OLUN,*)'Warning: CUTOFF may be too large'
     >,           ' for the chosen set of parameters.'
                  WRITE(OLUN,*)'The results are not guaranteed.'
                  WRITE(OLUN,800)ECMMIN/10.D0
               ENDIF
 800           FORMAT(' Suggest choosing CUTOFF= ',E8.2,' GeV or less'/)

C Calculate the approximate soft correction here.(to stabilize wght)
C 3.5 seems to work better than 4
               ASOFTC = 1.D0 + 3.5D0 * ALPHA/PI * LOG(ECMMIN/M)
     >                                          * LOG(CUTOFF/ECMMIN)
            ENDIF

         ENDIF
      ENDIF

      RETURN
      END

CDECK  ID>, TEEGG7. 
*.
*...TEEGG7   calls an event generator to generate one event.
*.
*. SEQUENCE  : TEGCOM
*. CALLS     : T3BODY,T4BODY
*. CALLED    : KIUSER,TEEGGM
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.2
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C SUBROUTINE TEEGG7: Calls an event generator to generate one event.
C-----------------------------------------------------------------------

      SUBROUTINE TEEGG7
      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


      IF(RADCOR.EQ.NONE .OR. RADCOR.EQ.SOFT)THEN
         CALL T3BODY
      ELSE IF(RADCOR.EQ.HARD)THEN
         CALL T4BODY
      ENDIF

      RETURN
      END

CDECK  ID>, TEEGGC. 
*.
*...TEEGGC   calculates the efficiency and total cross section
*.
*. SEQUENCE  : TEGCOM
*. CALLED    : USLAST,TEEGGM
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C SUBROUTINE TEEGGC: Calculates the efficiency and total cross section.
C-----------------------------------------------------------------------

      SUBROUTINE TEEGGC
      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


      DOUBLE PRECISION CONST

      EFFIC =REAL(NACC)/DBLE(NTRIAL)

      IF(RADCOR.EQ.NONE .OR. RADCOR.EQ.SOFT)THEN

         CONST = 2.D0*ALPHA3*2.D0/S*LOGZ0M*ZMAX*SUMW1/NTRIAL
     >           * LOG(FACT3) * ASOFTC

C Factor of 2 is from e+ and e- symmetrization:
         CONVER= CONST/NPASSQ * PBARN *2.D0

      ELSE IF(RADCOR.EQ.HARD)THEN

         CONST = ALPHA4/PI*2.D0/S*LOGZ0M*LOGRSM*ZMAX*SUMW1/NTRIAL
     >           * LOG(FACT3) * 2.D0*LOG(FACT7)

C Factor of 2 is from k and ks symmetrization:
         CONVER= CONST/NPASSQ * PBARN *2.D0

      ENDIF

      SIGE  = CONVER*SUMWGT
      ERSIGE= SIGE*SQRT( SUMW2/SUMWGT**2    + SUMW12/SUMW1**2
     >                  - 1.D0/DBLE(NPASSQ) -  1.D0 /DBLE(NTRIAL) )

      RETURN
      END

CDECK  ID>, TEEGGP. 
*.
*...TEEGGP   prints out a summary of input parameters and total x-sect
*.
*. INPUT     : OLUN   logical unit number to write summary
*.
*. SEQUENCE  : TEGCOM
*. CALLED    : USLAST,TEEGGM
*.
*. BANKS L   : Names of banks lifted
*. BANKS U   : Names of banks used
*. BANKS M   : Names of banks modified
*. BANKS D   : Names of banks dropped
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.2
*. CREATED   : 29-Jun-87
*. LAST MOD  : 10-Apr-89
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*. 10-Apr-89   Dean Karlen   Add FRAPHI and EPSPHI to output.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C SUBROUTINE TEEGGP: Prints out a summary of input params, total x-sect.
C-----------------------------------------------------------------------

      SUBROUTINE TEEGGP(OLUN)
      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


      INTEGER   OLUN

      LOGICAL      LWWARN
      CHARACTER*4  DESCOR
      CHARACTER*7  DESCON
      CHARACTER*13 WARN,WARN1
      CHARACTER*30 DESCME

      IF(CONFIG.EQ.EGAMMA)THEN
         DESCON='e-gamma'
      ELSE IF(CONFIG.EQ.GAMMA)THEN
         DESCON='gamma  '
      ELSE IF(CONFIG.EQ.ETRON)THEN
         DESCON='etron  '
      ELSE IF(CONFIG.EQ.GAMMAE)THEN
         DESCON='gamma e'
      ENDIF

      IF(RADCOR.NE.HARD)THEN
         IF(MATRIX.EQ.BK)THEN
            DESCME='Berends & Kleiss             '
         ELSE IF(MATRIX.EQ.BKM2)THEN
            DESCME='Berends & Kleiss with m term '
         ELSE IF(MATRIX.EQ.TCHAN)THEN
            DESCME='t channel only (inc. m term) '
         ELSE IF(MATRIX.EQ.EPA)THEN
            DESCME='Equivalent photon approx.    '
         ENDIF
      ELSE
         IF(MTRXGG.EQ.EPADC)THEN
            DESCME='EPA with double compton      '
         ELSE IF(MTRXGG.EQ.BEEGG)THEN
            DESCME='Berends et al e-e-gamma-gamma'
         ELSE IF(MTRXGG.EQ.MEEGG)THEN
            DESCME='Martinez/Miquel e-e-g-g      '
         ELSE IF(MTRXGG.EQ.HEEGG)THEN
            DESCME='EPA/Berends et al hybrid eegg'
         ENDIF
      ENDIF

      IF(RADCOR.EQ.NONE)THEN
         DESCOR='none'
      ELSE IF(RADCOR.EQ.SOFT)THEN
         DESCOR='soft'
      ELSE IF(RADCOR.EQ.HARD)THEN
         DESCOR='hard'
      ENDIF

      LWWARN=.FALSE.
      IF(W1MAX.GT.WGHT1M)THEN
         WARN1='** Warning **'
         LWWARN=.TRUE.
      ELSE
         WARN1='             '
      ENDIF

      IF(WMAX.GT.WGHTMX.AND.UNWGHT)THEN
         WARN='** Warning **'
         LWWARN=.TRUE.
      ELSE
         WARN='             '
      ENDIF

      IF(RADCOR.EQ.SOFT .AND. WMINSF.LT.0.D0)THEN
         WRITE(OLUN,120)
 120     FORMAT(' ** Warning ** The choice of CUTOFF is too small,'
     >,         ' causing the soft correction',/,' weight to be < 0.',/
     >,         ' Increase CUTOFF, and try again.',/)
      ENDIF

      IF(LWWARN)THEN
         WRITE(OLUN,121)
 121     FORMAT(' ** Warning ** The choice of a maximum weight is too'
     >,         ' small (see below).',/,' Increase as necessary.',/)
      ENDIF

      IF(( (RADCOR.EQ.HARD.AND.MTRXGG.EQ.EPADC) .OR. RADCOR.EQ.SOFT .OR.
     >     (RADCOR.EQ.NONE.AND.MATRIX.EQ.EPA)) .AND. Q2W2MX.GE..1D0)THEN
         WRITE(OLUN,122)Q2W2MX
 122     FORMAT(' ** Warning ** The equivalent photon approximation'
     >,         ' may be invalid for the event',/,' sample generated:',/
     >,         ' Q**2/W**2 << 1 is not always true. max(Q**2/W**2)='
     >,         F7.3,/)
      ENDIF

      WRITE(OLUN,100)DESCOR,DESCME,DESCON,BSEED,NXSEED,EB
      IF(RADCOR.NE.NONE)WRITE(OLUN,101)CUTOFF
      WRITE(OLUN,102)TEVETO
      IF(CONFIG.EQ.EGAMMA)THEN
         WRITE(OLUN,103)TEMIN,TGMIN,EEMIN,EGMIN
      ELSE IF(CONFIG.EQ.GAMMA.AND.RADCOR.NE.HARD)THEN
         WRITE(OLUN,104)TGMIN,EGMIN
      ELSE IF(CONFIG.EQ.GAMMA.AND.RADCOR.EQ.HARD)THEN
         WRITE(OLUN,105)TGMIN,TGVETO,EGMIN
      ELSE IF(CONFIG.EQ.GAMMAE.AND.RADCOR.EQ.HARD)THEN
         WRITE(OLUN,105)TGMIN,TGVETO,EGMIN
      ELSE IF(CONFIG.EQ.ETRON)THEN
         WRITE(OLUN,106)TEMIN,TGVETO,EEMIN
      ENDIF
      IF(RADCOR.EQ.HARD)THEN
         IF(CONFIG.EQ.EGAMMA)WRITE(OLUN,107)PEGMIN
         IF(CONFIG.NE.EGAMMA)WRITE(OLUN,108)PHVETO
         IF(CONFIG.EQ.GAMMA .AND.EEVETO.NE.0.D0)WRITE(OLUN,109)EEVETO
         IF(CONFIG.EQ.GAMMAE.AND.EEVETO.NE.0.D0)WRITE(OLUN,109)EEVETO
         IF(CONFIG.NE.EGAMMA.AND.EGVETO.NE.0.D0)WRITE(OLUN,110)EGVETO
         IF(EPS.NE.0.01D0)WRITE(OLUN,111)EPS
         IF(FRAPHI.GT.0.0D0)WRITE(OLUN,117)FRAPHI,EPSPHI
      ENDIF
      WRITE(OLUN,112)WGHT1M,W1MAX,WARN1
      IF(UNWGHT)THEN
         WRITE(OLUN,113)WGHTMX,WMAX,WARN
         WRITE(OLUN,114)NACC,NTRIAL,EFFIC,SIGE,ERSIGE
      ELSE
         WRITE(OLUN,115)WMAX
         WRITE(OLUN,116)NACC,NTRIAL,EFFIC,SIGE,ERSIGE
      ENDIF

 100  FORMAT(' '
     >,/,    ' TEEGG (7.2) - an e e gamma (gamma) event generator.'
     >,                                   ' Rad. correction: ',A4
     >,/,    ' Matrix element: ',A30,'      Configuration: ',A7
     >,/,/,  ' Initial seed =',I12,' next seed =',I12
     >,/,    ' Parameter: EB     = ',F7.3,' GeV')
 101  FORMAT(' Parameter: CUTOFF = ',F7.5,' GeV')
 102  FORMAT(' Parameter: TEVETO = ',F7.5,' rad')
 103  FORMAT(' Parameter: TEMIN  = ',F7.5,' rad'
     >,/,    ' Parameter: TGMIN  = ',F7.5,' rad'
     >,/,    ' Parameter: EEMIN  = ',F7.3,' GeV'
     >,/,    ' Parameter: EGMIN  = ',F7.3,' GeV')
 104  FORMAT(' Parameter: TGMIN  = ',F7.5,' rad'
     >,/,    ' Parameter: EGMIN  = ',F7.3,' GeV')
 105  FORMAT(' Parameter: TGMIN  = ',F7.5,' rad'
     >,/,    ' Parameter: TGVETO = ',F7.5,' rad'
     >,/,    ' Parameter: EGMIN  = ',F7.3,' GeV')
 106  FORMAT(' Parameter: TEMIN  = ',F7.5,' rad'
     >,/,    ' Parameter: TGVETO = ',F7.5,' rad'
     >,/,    ' Parameter: EEMIN  = ',F7.3,' GeV')
 107  FORMAT(' Parameter: PEGMIN = ',F7.5,' rad')
 108  FORMAT(' Parameter: PHVETO = ',F7.5,' rad')
 109  FORMAT(' Parameter: EEVETO = ',F7.4,' GeV')
 110  FORMAT(' Parameter: EGVETO = ',F7.4,' GeV')
 111  FORMAT(' Parameter: EPS    = ',F7.5,'    ')
 117  FORMAT(' Parameter: FRAPHI = ',F7.5,'    '
     >,/,    ' Parameter: EPSPHI = ',F7.6,'    ')
 112  FORMAT(' Parameter: WGHT1M = ',F7.3,' ; Observed maximum ',F7.3
     >,                                   ' ',A13)
 113  FORMAT(' Parameter: WGHTMX = ',F7.3,' ; Observed maximum ',F7.3
     >,                                   ' ',A13)
 114  FORMAT(' No. of events generated=',I7,','
     >,      ' No. of attempts=',I8,','
     >,      ' Efficiency=',F8.6
     >,/,    ' Total cross section =',E12.6,' +/- ',E12.6,' pb',/,/)
 115  FORMAT(' Weighted events generated   ; Observed maximum ',F7.3)
 116  FORMAT(' No. of weighted events =',I7,','
     >,      ' No. of attempts=',I8,','
     >,      ' Efficiency=',F8.6
     >,/,    ' Total cross section =',E12.6,' +/- ',E12.6,' pb',/,/)

      RETURN
      END

CDECK  ID>, TEEGGA. 
*.
*...TEEGGA   calculates cross section for user defined acceptance.
*.
*.     Optional description of routine....a few lines
*.
*. INPUT     : SUMWT  varaiable to accumulate accepted event weights
*. INPUT     : SUMWT2 varaiable to accumulate accepted event weights **2
*. OUTPUT    : XSCT   total cross section
*. OUTPUT    : ERXSCT error in total cross section calculation
*.
*. SEQUENCE  : TEGCOM
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C SUBROUTINE TEEGGA: Calculate cross section for user defined Acceptance
C-----------------------------------------------------------------------

      SUBROUTINE TEEGGA(SUMWT,SUMWT2,XSCT,ERXSCT)
      IMPLICIT NONE

      DOUBLE PRECISION SUMWT,SUMWT2,XSCT,ERXSCT


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


C If CONVER  has not been calculated, accumulate statistics
      IF(CONVER.EQ.0.D0)THEN
         IF(UNWGHT)THEN
            SUMWT  = SUMWT + 1.D0
            SUMWT2 = 0.D0
         ELSE
            SUMWT  = SUMWT  + WGHT
            SUMWT2 = SUMWT2 + WGHT**2
         ENDIF

C If CONVER has been calculated, calculate the cross section, provided
C There were some events in the acceptance
      ELSE IF(SUMWT.GT.0.D0)THEN
         IF(UNWGHT)THEN
            XSCT = SUMWT/DBLE(NACC) * SIGE
            ERXSCT = XSCT * SQRT(1.D0/SUMWT - 1.D0/DBLE(NTRIAL))
         ELSE
            XSCT  = CONVER*SUMWT
            ERXSCT= XSCT*SQRT(SUMWT2/SUMWT**2     + SUMW12/SUMW1**2
     >                        - 1.D0/DBLE(NPASSQ) -  1.D0 /DBLE(NTRIAL))
         ENDIF

C If no events were in the acceptance, xsct=0
      ELSE
         XSCT = 0.D0
         ERXSCT = 0.D0
      ENDIF

      RETURN
      END

CDECK  ID>, T3BODY. 
*.
*...T3BODY   generates an e-e-gamma event.
*.
*. SEQUENCE  : TEGCOM
*. CALLS     : DMORK RNDGEN
*. CALLED    : TEEGG7
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C SUBROUTINE T3BODY: Generates an e-e-gamma event
C-----------------------------------------------------------------------

      SUBROUTINE T3BODY
      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


C Variables
      DOUBLE PRECISION Z,Z0,FQPP,FQP,QP0,QPP,WGHT1
     >,      COSQP1,COSK1M,COSK1,PHIK,PHIP,W2,SINQP,SINK,COSKP1
     >,      K0,QM0,QMP,TA,COSQM1,F1,ABK,WBK,WM,TM,TPM,TRIX,D5L
     >,      FQM,COSKM1,DSIGA
     >,      SC,PBC,EBC,BETA1,BETA,GAMA,KCK,ATERM
     >,      KXPKC,KYPKC,KZPKC
     >,      XITERM,SINTR,COSTR,KXCKC,KYCKC,KZCKC,SINKC2,BETAM1,COSKC1
     >,      EMORK,TMORK,YMORK,UMORK,DEMORK,DELTAS

      INTEGER   IMISS,IOBSV

C Externals
      DOUBLE PRECISION   DMORK
      EXTERNAL DMORK

C The starting point for a new trial
C ----------------------------------

 1    CONTINUE

C #1 Generate QP0
C Do until trial QP0 COSQP1 is taken

C Increment the trial event counter here.
         NTRIAL=NTRIAL+1

C Generate all random numbers needed here.
         CALL RNDGEN(8)

         Z=RND(1)*ZMAX

C FQPP=EB-QP ; FQP=EB-QP0
         FQPP=EB/(1.D0+Z)
         FQP =FQPP - EPSLON*EB*(1.D0+Z)/Z
         QP0=EB-FQP
         QPP=SQRT(QP0**2-M**2)
         Z0 = QP0/FQP

C Require QP0 > QP0min
         IF(QP0.LT.QP0MIN)GOTO 1

C Assign a weight for this trial QP0
         WGHT1=(FQPP/FQP)**2 * LOG(  Z0**2*CDELT1/EPSLON+1.D0)/
     >                         LOGZ0M

C Keep track of all weights, to calculate the total cross section.
         SUMW1 = SUMW1 + WGHT1
         SUMW12= SUMW12+ WGHT1**2

      IF(WGHT1.LT.RND(2)*WGHT1M)GOTO 1

C A q+0 has been accepted. Keep track of number that pass qp generation.
      NPASSQ = NPASSQ + 1

C #2 Generate COS(theta QP0)

C COSQP1 = 1 - COS(theta QP0)
      COSQP1 = EPSLON/Z0**2*( (Z0**2/EPSLON*CDELT1+1.D0)**RND(3) -1.D0)

C #3 COS(theta K)

C COSK1M = 1 + COS(theta K) + epsilon
      COSK1M=CTGM1M*FACT3**RND(4)
      COSK1 = COSK1M - EPSLON

C #4 phi K  note that Kx=Ksin(theta_k)cos(phi_k + phi_qp) etc.
      PHIK=TWOPI*RND(5)

C #5 phi QP
      PHIP=TWOPI*RND(6)


C Derive the rest of the quantities that determine the exact x-section

C W2 = Invariant mass **2
      W2 = 2.D0*SQRTS*FQP + M**2

      SINQP = SQRT(COSQP1*(2.D0 - COSQP1))
      SINK  = SQRT(COSK1*(2.D0 - COSK1))

C COSKP1 = 1 + cos(theta gamma-e+)
      COSKP1= (COSK1+COSQP1) - COSK1*COSQP1 + SINK*SINQP*COS(PHIK)

      Y2 = (W2 - M**2)/2.D0

      K0 = SQRTS*FQP / (2.D0*FQP + QPP*COSKP1 + (QP0-QPP))

      QM0 = SQRTS - K0 - QP0
      QMP = SQRT(QM0**2-M**2)

C Carefully calculate t.If QP0 is large enough, expand in powers of m**2
      IF(QP0.GE.100.D0*M)THEN
         T   = -2.D0*EBP*QPP*COSQP1 -M**2*FQP**2/EB/QP0
      ELSE
         T   = -2.D0*EBP*QPP*COSQP1 + 2.D0*M**2 - 2.D0*(EB*QP0-EBP*QPP)
      ENDIF

C Also calculate the approximate t, to be used to evaluate DSIGA
      TA  = -2.D0*EB*QP0*(COSQP1 + EPSLON/Z0**2)

C COSQM1 = 1 + cos(theta e-)
      COSQM1 = (M**2 + W2 - T - 2.D0*EBP*K0*COSK1 -2.D0*K0*(EB-EBP)
     >          -2.D0*(EB*QM0-EBP*QMP))/(2.D0*EBP*QMP)

C Require that the electron is in the right place
C and that 'seen' particles have enough energy

      IF(CONFIG.EQ.EGAMMA)THEN
         IF(ABS(COSQM1-1.D0).GT.ACTEM)GOTO 1
         IF(QM0.LT.EEMIN .OR. K0.LT.EGMIN)GOTO 1
      ELSE IF(CONFIG.EQ.ETRON)THEN
         IF(ABS(COSQM1-1.D0).GT.ACTEM)GOTO 1
         IF(QM0.LT.EEMIN)GOTO 1
      ELSE IF(CONFIG.EQ.GAMMA)THEN
         IF(K0.LT.EGMIN)GOTO 1
         IF(COSQM1.GT.CDELT1)GOTO 1
      ENDIF

      TP  = 2*M**2 - 2.D0*EBP*QMP*COSQM1 - 2.D0*(EB*QM0-EBP*QMP)
      SP  = S - 2.D0 * SQRTS * K0
      U   = 2.D0 * M**2 - 2.D0*(EB*QM0+EBP*QMP) + 2.D0*EBP*QMP*COSQM1
      UP  = 2.D0 * M**2 - 2.D0*(EB*QP0+EBP*QPP) + 2.D0*EBP*QPP*COSQP1
      X1  = (EB+EBP)*K0 - EBP*K0*COSK1
      X2  = (EB-EBP)*K0 + EBP*K0*COSK1
      Y1  = (QP0+QPP)*K0 - QPP*K0*COSKP1

C Calculate the exact cross section.

      F1 = ALPHA3/PI**2 /S

C Calculate some M terms

      WM = M**2*(S-SP)/(S**2+SP**2)*(SP/X1+SP/X2+S/Y1+S/Y2)
      TM = -8.D0*M**2/T**2*(X2/Y2+Y2/X2)
      TPM= -8.D0*M**2/TP**2*(X1/Y1+Y1/X1)

C Decide which matrix element to use
C This is the Berends Kleiss terms only

      IF(MATRIX .EQ. BK )THEN
         ABK = (  S*SP*(S**2+SP**2) + T*TP*(T**2+TP**2)
     >          + U*UP*(U**2+UP**2)   ) / (S*SP*T*TP)
         WBK =  S/X1/X2 + SP/Y1/Y2 - T/X1/Y1 - TP/X2/Y2
     >        + U/X1/Y2 + UP/X2/Y1
         TRIX= ABK * WBK * (1.D0-WM)

C This is the Berends Kleiss with me**2 term

      ELSE IF(MATRIX .EQ. BKM2)THEN

         TRIX = (  S*SP*(S**2+SP**2) + T*TP*(T**2+TP**2)
     >           + U*UP*(U**2+UP**2)   ) / (S*SP*T*TP)
     >         *(S/X1/X2+SP/Y1/Y2-T/X1/Y1-TP/X2/Y2+U/X1/Y2+UP/X2/Y1)
     >         *(1.D0-WM)
     >         + TM + TPM

C This is the t-channel term with me**2 term. This can be used to judge
C the size of interference terms.

      ELSE IF(MATRIX .EQ. TCHAN)THEN

         TRIX=
     >     -(S**2+SP**2+U**2+UP**2)/T/X2/Y2 + TM

C This is the EPA matrix element (for testing only)

      ELSE IF(MATRIX .EQ. EPA)THEN

         TRIX= -4.D0*(X2**2 + Y2**2)
     >              *((S**2 + (S-W2)**2)/W2**2 + 2.D0*M**2/T)
     >              /T/X2/Y2

      ELSE

         TRIX= 1.D9

      ENDIF

      D5L = QP0 * K0 * K0 / Y2 / 8.D0

      DSIGE = F1 * TRIX * D5L

C Calculate approximate cross section.
C Here the approximate sigma is symmetrized.

      FQM=EB-QM0
      COSKM1=Y2/QM0/K0
      DSIGA =-2.D0*ALPHA3*S/PI**2 *
     >        (  1.D0/X2/Y2/TA*(SQRTS-QP0*(2.D0-COSKP1))/FQP
     >         + 1.D0/X1/Y1/TP*(SQRTS-QM0*(2.D0-COSKM1))/FQM )
     >        * D5L * ASOFTC

C If soft corrections are requested, modify the weight.

      WGHTSF=1.D0

      IF(RADCOR.EQ.SOFT)THEN
         SC = W2
         PBC= SQRT(W2-2.D0*M**2)/2.D0
         EBC= SQRT(PBC**2+M**2)

C Boost the photon's angles to the gamma-e center of mass.
C (allowing for transverse momentum, as done in the 4 body generator)
C Beta = -qp/(sqrts-qp0)

         BETA1 = (2.D0*FQP + .5D0*M**2/QP0)/(EB + FQP)
         BETA  = 1.D0-BETA1
         GAMA  = (SQRTS - QP0)/SQRT(SC)

C KXPKC = kx'/k' etc.  KCK = k'/k = k''/k
         KCK   = GAMA*(BETA*SINK*COS(PHIK)*SINQP
     >                  + BETA1*(1.D0 - COSK1 - COSQP1 + COSK1*COSQP1)
     >                  + COSK1 + COSQP1 - COSK1*COSQP1)
         ATERM = SINK*COS(PHIK)*SINQP - COSK1*COSQP1 +COSK1+COSQP1-BETA1
         KXPKC =(SINK*COS(PHIK) +BETA*SINQP+(GAMA-1.D0)*ATERM*SINQP)/KCK
         KYPKC =(SINK*SIN(PHIK))/KCK
         KZPKC =(COSK1 + BETA1*COSQP1 - BETA1 - COSQP1
     >           + (GAMA - 1.D0)*ATERM*(1.D0-COSQP1))/KCK

C KXCKC= kx''/k'' etc. this is the frame where kinematics a solved.
         XITERM = (GAMA-1.D0)*COSQP1 - GAMA*(BETA1 + BETA*EPSLON)
         SINTR  = (1.D0+XITERM)*SINQP /
     >             SQRT(2.D0*(1.D0 + XITERM)*COSQP1 + XITERM**2)
         COSTR  = SIGN(SQRT(1.D0-SINTR**2),COSQP1-XITERM*(1.D0-COSQP1))
         KXCKC = KXPKC*COSTR + KZPKC*SINTR
         KYCKC = KYPKC
         KZCKC = KZPKC*COSTR - KXPKC*SINTR

         SINKC2= KXCKC**2 + KYCKC**2

C BETAM1 = 1 - beta(e-) in cm frame
         BETAM1=(M**2/2.D0/PBC**2 - M**4/8.D0/PBC**4)*PBC/EBC
         COSKC1=SINKC2/(1.D0-KZCKC)

         EMORK=SQRT(SC)/M
         TMORK=.5D0*(BETAM1 + COSKC1 -BETAM1*COSKC1)
         YMORK=.5D0*LOG(.5D0* EMORK**2 * (1.D0 - KZCKC))
         UMORK=TMORK+1.D0/TMORK
         DEMORK=CUTOFF/M
         DELTAS=DMORK(TMORK,YMORK,UMORK,EMORK,DEMORK)
         WGHTSF=(1.D0+DELTAS)
         WMINSF=MIN(WMINSF,WGHTSF)
      ENDIF

C The weight of this trial event is,

      WGHT = DSIGE/DSIGA * WGHTSF
      WMAX = MAX(WMAX,WGHT)
      W1MAX= MAX(W1MAX,WGHT1)

C Keep track of quantities for the total cross section calculation.

      SUMWGT = SUMWGT + WGHT
      SUMW2  = SUMW2  + WGHT**2

      IF(UNWGHT.AND.WGHT.LT.RND(7)*WGHTMX)GOTO 1

C An event has been accepted at this point
C ----------------------------------------

      NACC=NACC+1

C Calculate the 4 vectors. Decide whether to interchange or not here.

      IF(RND(8).LT..5)THEN
         IMISS=0
         IOBSV=4
         RSIGN=+1.D0
      ELSE
         IMISS=4
         IOBSV=0
         RSIGN=-1.D0
      ENDIF

C 'missing'
      P(IMISS+1)=QPP*SINQP*COS(PHIP)  * RSIGN
      P(IMISS+2)=QPP*SINQP*SIN(PHIP)  * RSIGN
      P(IMISS+3)=QPP*(1.D0-COSQP1)    * RSIGN
      P(IMISS+4)=QP0
C Gamma
      P(9) =K0*SINK*COS(PHIK+PHIP)    * RSIGN
      P(10)=K0*SINK*SIN(PHIK+PHIP)    * RSIGN
      P(11)=K0*(COSK1-1.D0)           * RSIGN
      P(12)=K0
C 'observed'
      P(IOBSV+1)=-P(IMISS+1)-P(9)
      P(IOBSV+2)=-P(IMISS+2)-P(10)
      P(IOBSV+3)=QMP*(COSQM1-1.D0)    * RSIGN
      P(IOBSV+4)=QM0

      RETURN
      END

CDECK  ID>, T4BODY. 
*.
*...T4BODY   generates an e-e-gamma-gamma event.
*.
*. SEQUENCE  : TEGCOM
*. CALLS     : RNDGEN TBOORT TPRD BEEGGC MEEGGC
*. CALLED    : TEEGG7
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.2
*. CREATED   : 29-Jun-87
*. LAST MOD  : 10-Apr-89
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*. 10-Apr-89   Dean Karlen   Handle the peak in phi-ks properly
*. 21-May-89   Dean Karlen   remove recalculation of CPHKKS (IBM problem
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C SUBROUTINE T4BODY: Generates an e-e-gamma-gamma event.
C-----------------------------------------------------------------------

      SUBROUTINE T4BODY
      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


C Variables
      DOUBLE PRECISION
     >       ZP,Z0,FQPP,FQP,QP0,WGHT1,RS,W2,SQRTSC,SC,PBC,EBC
     >,      COSQP1,SINQP,COSK1M,COSK1,SINK,PHIK,PHIP
     >,      BETA1,BETA,GAMA,KCK,ATERM,KXPKC,KYPKC,KZPKC
     >,      XITERM,SINTR,COSTR,KXCKC,KYCKC,KZCKC,SINKC,PHIKC
     >,      KS,CSKS1P,SINKSP,CSKS1Q,PHIKSP,KC,QM0C,QMPC
     >,      CSKS1K,SINKSK,PHIKSK,KXYCKC,CPKSK,SPKSK,KSXKS,KSYKS,KSZKS
     >,      QPP0,QM0,QMP0,K0,KSL,COSQM,COSQM1,COSKSL,CSKS1L,CSK1CQ
     >,      DELTQ,PHIEL,PHIKL,PHIKSL,SGNPHI,XPHIKS,PHIKSX
     >,      KAP1,KAP2,KAP3,KAP1P,KAP2P,KAP3P,A,B,C,X,Z,UA,UB,RO,XTERM
     >,      DSIGA,TE,BPMK1,BPMK2,BQMK1,BQMK2,BK1K2
     >,      S1,S2,T1,T2,U1,U2,PPK1K2,PMK1K2,QPK1K2,QMK1K2
     >,      K1P,K1M,K2P,K2M,QPP,QPM,QMP,QMM
     >,      XPHIP1,XPHIP2,XPHIK1,XPHIK2,CPHKSK,CPHKKS
     >,      KZCKC1,COSTR1,KZPKC1,CSKS2P

      DOUBLE PRECISION
     >       QMC4(4),GAMC4(4),GAMSC4(4),QPL4(4),QML4(4)
     >,      GAML4(4),GAMSL4(4)

      INTEGER   IMISS,IOBSV
      LOGICAL LKSAXZ,LPKPHI,LPASS,LSWAP
      LOGICAL LAE,LAG,LAGS,LAEG,LAEGS,LRE,LRG,LRGS,LREG,LREGS,LRGGS

      DOUBLE PRECISION HQ2MIN
      PARAMETER (HQ2MIN = 1.D2 * M**2)

C Externals
      DOUBLE PRECISION
     >         TPRD,BEEGGC,MEEGGC
      EXTERNAL TPRD,BEEGGC,MEEGGC

      DOUBLE PRECISION PHISEP,PHI1,PHI2,XPHI,DXPHI,XPHI1,TASQRT,DUM
      PHISEP(PHI1,PHI2)=MIN(ABS(PHI1 - PHI2) , TWOPI - ABS(PHI1 - PHI2))
      XPHI(PHI1)=(PI-ABS(MOD(ABS(PHI1),TWOPI)-PI))/PI
      DXPHI(XPHI1)=1.D0 - FRAPHI +
     >             FRAPHI/LOG(1.D0+1.D0/EPSPHI)/(XPHI1+EPSPHI)
      TASQRT(DUM)=DUM/2.D0+DUM**2/8.D0+DUM**3/16.D0+5.D0*DUM**4/128.D0
     >            +7.D0*DUM**5/256.D0

C The starting point for a new trial
C ----------------------------------

 1    CONTINUE

C #1 Generate QP0
C Do until trial QP0 COSQP1 is taken

C Increment the trial event counter here. The calculation of the total
C cross section depends on this quantity.
         NTRIAL=NTRIAL+1

C Generate all random numbers needed here.
         CALL RNDGEN(12)

         ZP=RND(1)*ZMAX

C FQPP=EB-QP ; FQP=EB-QP0
         FQPP=EB/(1.D0+ZP)
         FQP =FQPP - EPSLON*EB*(1.D0+ZP)/ZP
         QP0=EB-FQP
         Z0 = QP0/FQP

C Require QP0 > QP0min
         IF(QP0.LT.QP0MIN)GOTO 1

C Some handy 'constants'

         W2 = 2.D0*SQRTS*FQP + M**2
         PBC= SQRT(W2-2.D0*M**2)/2.D0
         EBC= SQRT(PBC**2+M**2)
         SQRTSC=SQRT(W2)
         SC = W2

C Assign a weight for this trial QP0

         RS=(PBC*(1.D0+EPS)-CUTOFF)/(EPS*CUTOFF)
         WGHT1=(FQPP/FQP)**2 * LOG(1.D0+CDELT1/EPSLON*Z0**2)*LOG(RS)/
     >                       ( LOGZ0M * LOGRSM )

C Keep track of all weights, to calculate the total cross section.
         SUMW1 = SUMW1 + WGHT1
         SUMW12= SUMW12+ WGHT1**2

      IF(WGHT1.LT.RND(2)*WGHT1M)GOTO 1

C A q+0 has been accepted. Keep track of number that pass qp generation
      NPASSQ = NPASSQ + 1

C #2 Generate COS(theta QP0)

C COSQP1 = 1 - COS(theta QP0)
      COSQP1 = EPSLON/Z0**2*( (Z0**2/EPSLON*CDELT1+1.D0)**RND(3) -1.D0)
      SINQP  = SQRT(COSQP1*(2.D0 - COSQP1))

C #3 COS(theta K)

C COSK1M = 1 + COS(theta K) + epsilon
      COSK1M=CTGM1M*FACT3**RND(4)
      COSK1 = COSK1M - EPSLON
      SINK  = SQRT(COSK1*(2.D0 - COSK1))

C #4 phi K  note that Kx=Ksin(theta_k)cos(phi_k + phi_qp) etc.
      PHIK=TWOPI*RND(5)

C #5 phi QP
      PHIP=TWOPI*RND(6)

C Now boost the first photon's angles to the gamma-e center of mass.
C Beta = -qp/(sqrts-qp0)

      BETA1 = (2.D0*FQP + .5D0*M**2/QP0)/(EB + FQP)
      BETA  = 1.D0-BETA1
      GAMA  = (SQRTS - QP0)/SQRT(SC)

C KXPKC = kx'/k' etc.  KCK = k'/k = k''/k
      KCK   = GAMA*(BETA*SINK*COS(PHIK)*SINQP
     >               + BETA1*(1.D0 - COSK1 - COSQP1 + COSK1*COSQP1)
     >               + COSK1 + COSQP1 - COSK1*COSQP1)
      ATERM = SINK*COS(PHIK)*SINQP - COSK1*COSQP1 + COSK1+COSQP1-BETA1
      KXPKC =(SINK*COS(PHIK) + BETA*SINQP + (GAMA-1.D0)*ATERM*SINQP)/KCK
      KYPKC =(SINK*SIN(PHIK))/KCK
      KZPKC =(COSK1 + BETA1*COSQP1 - BETA1 - COSQP1
     >        + (GAMA - 1.D0)*ATERM*(1.D0-COSQP1))/KCK

C KXCKC= kx''/k'' etc. this is the frame where kinematics a solved.
      XITERM = (GAMA-1.D0)*COSQP1 - GAMA*(BETA1 + BETA*EPSLON)
      SINTR  = (1.D0+XITERM)*SINQP /
     >          SQRT(2.D0*(1.D0 + XITERM)*COSQP1 + XITERM**2)
      COSTR  = SIGN(SQRT(1.D0-SINTR**2),COSQP1-XITERM*(1.D0-COSQP1))
      KXCKC = KXPKC*COSTR + KZPKC*SINTR
      KYCKC = KYPKC
      KZCKC = KZPKC*COSTR - KXPKC*SINTR

      SINKC = SQRT(KXCKC**2 + KYCKC**2)
      PHIKC = ATAN2(KYCKC,KXCKC)

C Now add another photon according to the approximate cross section.

C #6 KS

      KS = PBC * (1.D0+EPS)/(1.D0+EPS*RS**RND(7))

C #7 theta KS

C Determine if the generating axis is the -z axis or the QM0 direction
C also determine if peaked or flat distribution is generated
C and for peaked distribution, determine sign of delta-phi
      LPKPHI=.FALSE.
      SGNPHI=-1.D0
      IF(RND(8).GE..5)THEN
         LKSAXZ=.TRUE.
         IF(RND(8).LT.(FRAPHI+1.D0)/2.D0)THEN
            LPKPHI=.TRUE.
            IF(RND(8).LT.(FRAPHI+2.D0)/4.D0)SGNPHI=1.D0
         ENDIF
      ELSE
         LKSAXZ=.FALSE.
         IF(RND(8).LT.FRAPHI/2.D0)THEN
            LPKPHI=.TRUE.
            IF(RND(8).LT.FRAPHI/4.D0)SGNPHI=1.D0
         ENDIF
      ENDIF

C CSKS1 =1-COS(theta-ks) (about PM or -K direction)

      IF(LKSAXZ)THEN
         CSKS1P=EPSLON*FACT7**RND(9)-EPSLON
         SINKSP=SQRT(CSKS1P*(2.D0 - CSKS1P))
      ELSE
         CSKS1K=EPSLON*FACT7**RND(9)-EPSLON
         SINKSK=SQRT(CSKS1K*(2.D0 - CSKS1K))
      ENDIF

C #8 phi KS (about PM or -K direction)
C phi_ks=0 when ks is in the plane defined PM and -K.

      IF(.NOT.LPKPHI)THEN
         PHIKSX=TWOPI*RND(10)
      ELSE
         XPHIKS=EPSPHI*(1.D0+1.D0/EPSPHI)**RND(10)-EPSPHI
         PHIKSX=XPHIKS*PI*SGNPHI
      ENDIF

C Check that the configuration is even possible.
      IF(KS.GT.PBC)GOTO 1

C Solve the event kinematics
C --------------------------

C Solve for the 1st photon energy and for the electron. First for the
C case where the 2nd photon is generated about the -z axis

      IF(LKSAXZ)THEN

         PHIKSP = PHIKC + PI + PHIKSX

         KC = ( SQRTSC/2.D0*(SQRTSC-2.D0*KS) - M**2/2.D0 ) /
     >        ( SQRTSC - KS*(1.0D0 + KZCKC - CSKS1P+(1.D0-KZCKC)*CSKS1P
     >                       - SINKC*SINKSP*COS(PHIKC-PHIKSP) )  )
         QM0C = SQRTSC - KC - KS
         QMPC = SQRT(QM0C**2-M**2)

         CSKS1Q=( (QMPC+KS)**2 - KC**2 ) / (2.D0*QMPC*KS)

         CSKS1K=( QM0C**2 - M**2 - (KC-KS)**2 ) / (2.D0*KC*KS)
         SINKSK=SQRT(CSKS1K*(2.D0 - CSKS1K))

         GAMC4(1) = KC*KXCKC
         GAMC4(2) = KC*KYCKC
         GAMC4(3) = KC*KZCKC
         GAMC4(4) = KC

         GAMSC4(1) = KS*SINKSP*COS(PHIKSP)
         GAMSC4(2) = KS*SINKSP*SIN(PHIKSP)
         GAMSC4(3) = KS*(CSKS1P-1.D0)
         GAMSC4(4) = KS

         QMC4(1) = -GAMC4(1)-GAMSC4(1)
         QMC4(2) = -GAMC4(2)-GAMSC4(2)
         QMC4(3) = -GAMC4(3)-GAMSC4(3)
         QMC4(4) = QM0C

C Calculate the x_phi for the four cases (phi_ks about PM OR about -K)
C                                       X(regular OR ks <--> k symm)
         XPHIP1 = XPHI(PHIKSX)
         XPHIP2 = XPHIP1

         CPHKSK = ( CSKS1P-1.D0 + KZCKC*(1.D0-CSKS1K) )/
     >            (SINKC*SINKSK)
         CPHKKS = ( KZCKC + (CSKS1P-1.D0)*(1.D0-CSKS1K) )/
     >            (SINKSP*SINKSK)

         CPHKSK = MIN(1.D0,MAX(-1.D0,CPHKSK))
         CPHKKS = MIN(1.D0,MAX(-1.D0,CPHKKS))

         XPHIK1 = XPHI(ACOS(CPHKSK)+PI)
         XPHIK2 = XPHI(ACOS(CPHKKS)+PI)
      ELSE

C Now for the case where the 2nd photon is generated about the -k axis
C First the energies of the participants can be found from CSKS1K

C The phi_ks peak occurs at phi_ks = pi
         PHIKSK = PI + PHIKSX

         KC = (.5D0*(SC-M**2) - SQRTSC*KS)/(SQRTSC - KS*(2.0D0-CSKS1K))
         QM0C = SQRTSC - KC - KS
         QMPC = SQRT(QM0C**2 - M**2)

C KSXKS = Ks_x / Ks etc.

         KXYCKC=SQRT(KXCKC**2 + KYCKC**2)
         CPKSK = COS(PHIKSK)
         SPKSK = SIN(PHIKSK)

         KSXKS = - KXCKC*KZCKC/KXYCKC * SINKSK*CPKSK
     >           - KYCKC/KXYCKC * SINKSK*SPKSK - KXCKC*(1.D0-CSKS1K)
         KSYKS = - KYCKC*KZCKC/KXYCKC * SINKSK*CPKSK
     >           + KXCKC/KXYCKC * SINKSK*SPKSK - KYCKC*(1.D0-CSKS1K)
         KSZKS =   KXYCKC*SINKSK*CPKSK         - KZCKC*(1.D0-CSKS1K)

C Calculate the 4-vectors in the CM frame.

         GAMC4(1) = KC*KXCKC
         GAMC4(2) = KC*KYCKC
         GAMC4(3) = KC*KZCKC
         GAMC4(4) = KC

         GAMSC4(1) = KS*KSXKS
         GAMSC4(2) = KS*KSYKS
         GAMSC4(3) = KS*KSZKS
         GAMSC4(4) = KS

         QMC4(1) = -GAMC4(1)-GAMSC4(1)
         QMC4(2) = -GAMC4(2)-GAMSC4(2)
         QMC4(3) = -GAMC4(3)-GAMSC4(3)
         QMC4(4) = QM0C

         CSKS1P = 1.D0 + GAMSC4(3)/KS
         SINKSP = SQRT(CSKS1P*(2.D0-CSKS1P))

         CSKS1Q=( (QMPC+KS)**2 - KC**2 ) / (2.D0*QMPC*KS)

C Calculate the x_phi for the four cases (phi_ks about PM OR about -K)
C                                       X(regular OR ks <--> k symm)
         XPHIP1 = XPHI(ATAN2(KYCKC,KXCKC)-ATAN2(KSYKS,KSXKS)+PI)
         XPHIP2 = XPHIP1

         CPHKSK = ( CSKS1P-1.D0 + KZCKC*(1.D0-CSKS1K) )/
     >            (SINKC*SINKSK)
         CPHKKS = ( KZCKC + (CSKS1P-1.D0)*(1.D0-CSKS1K) )/
     >            (SINKSP*SINKSK)

C Since CPHKKS can be somewhat unstable, recalculate
         KZCKC1 = 1.D0 + KZCKC
C        IF(KZCKC.LT.-0.99D0)THEN
C           COSTR1 = 1.D0 - COSTR
C           IF(COSTR.GT.0.99D0)COSTR1 = TASQRT(SINTR**2)
C           KZPKC1 = 1.D0 + KZPKC
C           IF(KZPKC.LT.-0.99D0)KZPKC1 = TASQRT(KXPKC**2 + KYPKC**2)
C           KZCKC1 = COSTR1 + KZPKC1 - COSTR1*KZPKC1 - KXPKC*SINTR
C        ENDIF
         CSKS2P = 2.D0 - CSKS1P
         IF(CSKS1P.GT.1.99D0)CSKS2P = TASQRT(KSXKS**2 + KSYKS**2)

         CPHKKS = (KZCKC1 - CSKS2P - CSKS1K + CSKS2P*CSKS1K)/
     >            (SINKSP*SINKSK)

         CPHKSK = MIN(1.D0,MAX(-1.D0,CPHKSK))
         CPHKKS = MIN(1.D0,MAX(-1.D0,CPHKKS))

         XPHIK1 = XPHI(PHIKSX)
         XPHIK2 = XPHI(ACOS(CPHKKS)+PI)

      ENDIF

C Finished with the kinematics......
C Require that the first photon be above the cutoff too.

      IF(KC.LT.CUTOFF)GOTO 1

C Rotate and boost back to lab system, then rotate for phip

      CALL TBOORT(QMC4,SINTR,COSTR,GAMA,BETA,SINQP,COSQP1,PHIP,QML4)
      CALL TBOORT(GAMC4,SINTR,COSTR,GAMA,BETA,SINQP,COSQP1,PHIP,GAML4)
      CALL TBOORT(GAMSC4,SINTR,COSTR,GAMA,BETA,SINQP,COSQP1,PHIP,GAMSL4)

      QPP0    = SQRT(QP0**2-M**2)
      QPL4(1) = QPP0*SINQP*COS(PHIP)
      QPL4(2) = QPP0*SINQP*SIN(PHIP)
      QPL4(3) = QPP0*(1.D0-COSQP1)
      QPL4(4) = QP0

      QM0 = QML4(4)
      QMP0 = SQRT(QM0**2-M**2)
      K0  = GAML4(4)
      KSL = GAMSL4(4)

      COSQM=QML4(3)/QMP0
C COSQM1= 1+COS(theta q-) in lab system (can be small)
      IF(QML4(3).LT.0.D0)THEN
         COSQM1 = ( QML4(1)**2 + QML4(2)**2 )
     >            /QMP0**2 /(1.D0-COSQM)
      ELSE
         COSQM1 = 1.D0+COSQM
      ENDIF

      COSKSL=GAMSL4(3)/GAMSL4(4)
C CSKS1L= 1+COS(theta ks) in lab system (can be small)
      IF(GAMSL4(3).LT.0.D0)THEN
         CSKS1L = ( GAMSL4(1)**2 + GAMSL4(2)**2 )
     >            /GAMSL4(4)**2 /(1.D0-COSKSL)
      ELSE
         CSKS1L = 1.D0+COSKSL
      ENDIF

C Check if the event passes for the chosen configuration.

      PHIEL =ATAN2(QML4(2),QML4(1))
      PHIKL =ATAN2(GAML4(2),GAML4(1))
      PHIKSL=ATAN2(GAMSL4(2),GAMSL4(1))

C Acceptance criteria
      LAE  = QM0.GE.EEMIN .AND. ABS(COSQM).LE.ACTEM
      LAG  =  K0.GE.EGMIN
      LAGS = KSL.GE.EGMIN .AND. ABS(COSKSL).LE.ACTK
      LAEG = PHISEP(PHIEL,PHIKL) .GE. PEGMIN
      LAEGS= PHISEP(PHIEL,PHIKSL) .GE. PEGMIN

C Rejection criteria
      LRE  = QM0.GE.EEVETO .AND. COSQM1.GE.CDELT1
      LRG  =  K0.GE.EGVETO .AND. COSK1.GE.CTGVT1
      LRGS = KSL.GE.EGVETO .AND.
     >       MIN((1.D0+COSKSL),(1.D0-COSKSL)).GE.CTGVT1
      LREG = PHISEP(PHIEL,PHIKL)  .GE. PHVETO
      LREGS= PHISEP(PHIEL,PHIKSL) .GE. PHVETO
      LRGGS= PHISEP(PHIKL,PHIKSL) .GE. PHVETO

C Now decide if event passes all the criteria: LPASS
C and if the (k,ks) swapped event could have been generated: LSWAP

      LPASS=.FALSE.
      LSWAP=.FALSE.

      IF(CONFIG.EQ.EGAMMA)THEN
         LPASS = LAE .AND. ((LAG.AND.LAEG) .OR. (LAGS.AND.LAEGS))
         LSWAP = ABS(COSKSL).LE.ACTK
      ELSE IF(CONFIG.EQ.ETRON)THEN
         LPASS = LAE.AND. .NOT.(LRG.AND.LREG).AND. .NOT.(LRGS.AND.LREGS)
         LSWAP = (1.D0+COSKSL) .LT. CTGVT1
      ELSE IF(CONFIG.EQ.GAMMA)THEN
         LPASS = (LAG .AND. .NOT.LRE .AND. .NOT.(LRGS.AND.LRGGS) ) .OR.
     >           (LAGS.AND. .NOT.LRE .AND. .NOT.(LRG .AND.LRGGS) )
         LSWAP = ABS(COSKSL).LE.ACTK
      ELSE IF(CONFIG.EQ.GAMMAE)THEN
         LPASS = (LAGS.AND. .NOT.LRE .AND. COSQM1.GE.CDELT1)
         LSWAP = .FALSE.
      ENDIF

      IF(.NOT.LPASS)GOTO 1

C Derive some quantities needed for calculating the event weight

      CSK1CQ=( (QMPC+KC)**2 - KS**2 ) / (2.D0*QMPC*KC)

      IF(M/QM0C.LT..01D0)THEN
         DELTQ=QM0C*( 1.D0/2.D0 *(M/QM0C)**2 +  1.D0/8.D0 * (M/QM0C)**4
     >              + 3.D0/48.D0*(M/QM0C)**6 + 15.D0/384.D0*(M/QM0C)**8)
      ELSE
         DELTQ=QM0C-QMPC
      ENDIF

C These invariants are calculated in the gamma-e CM

      KAP1 = (PBC*KS*CSKS1P + M**2/2.D0 * KS/PBC)         / M**2
      KAP2 = (PBC*KC*(1.D0+KZCKC) + M**2/2.D0 * KC/PBC)   / M**2
      KAP3 = (-SC+M**2)/2.D0                              / M**2
      KAP1P= (-QMPC*KS*CSKS1Q - DELTQ*KS)                 / M**2
      KAP2P= (-QMPC*KC*CSK1CQ - DELTQ*KC)                 / M**2
      KAP3P= (QM0C-QMC4(3))*PBC                           / M**2

      A = 1.D0/KAP1  + 1.D0/KAP2  + 1.D0/KAP3
      B = 1.D0/KAP1P + 1.D0/KAP2P + 1.D0/KAP3P
      C = 1.D0/KAP1/KAP1P + 1.D0/KAP2/KAP2P + 1.D0/KAP3/KAP3P
      X = KAP1  + KAP2  + KAP3
      Z = KAP1*KAP1P + KAP2*KAP2P + KAP3*KAP3P
      UA= KAP1  * KAP2  * KAP3
      UB= KAP1P * KAP2P * KAP3P
      RO= KAP1/KAP1P+KAP1P/KAP1 + KAP2/KAP2P+KAP2P/KAP2 +
     >    KAP3/KAP3P+KAP3P/KAP3

      XTERM =  2.D0*(A*B-C)*( (A+B)*(X+2.D0) - (A*B-C) - 8.D0 )
     >       - 2.D0*X*(A**2+B**2 - C*RO ) - 8.D0*C
     >       + 4.D0*X*
     >         ( (1/UA+1/UB)*(X+1.D0)-(A/UB+B/UA)*(2.D0+Z*(1.D0-X)/X)
     >                + X/UA*X/UB*(1.D0-Z) + 2.D0/UA*Z/UB )
     >       - 2.D0*RO*( A*B + C )

C Calculate the 'exact' cross section
C It is not symmetrized about + <--> - .

C Here is the slightly approximated t
      T   = -SQRTS*QP0*COSQP1 - M**2*FQP**2/EB/QP0
C Here is the more exact t:
      TE  = -2.D0*EBP*QPP0*COSQP1 -M**2*FQP**2/EB/QP0

      DSIGE = (ALPHA/PI)**4 * XTERM/M**2 /S /(-TE) *
     >        ( (S**2 + (S-SC)**2)/SC**2 + 2.D0*M**2/TE )

C If the Berends et al. eegg calculation is requested:

      IF(MTRXGG.EQ.BEEGG .OR. (MTRXGG.EQ.HEEGG .AND. -T.GE.HQ2MIN))THEN

C Invariant products of photons and the electron.
C Work with the LAB 4 vectors only.
C The CM does not have a physical value for p-
C and was only developed for EPA methods.

         BPMK1 = EB*GAML4(4) + EBP*GAML4(3)
         BPMK2 = EB*GAMSL4(4) + EBP*GAMSL4(3)
         BQMK1 = TPRD(QML4,GAML4)
         BQMK2 = -KAP1P*M**2
         BK1K2 = TPRD(GAML4,GAMSL4)

C Calculate the BK invariants:

         U = 2.D0*M**2 - SQRTS*QM0 + 2.D0*EBP*QMP0*COSQM
         SP= S - 2.D0*SQRTS*(K0+KSL) + 2.D0*BK1K2
         TP= 2.D0*M**2 - SQRTS*QM0 - 2.D0*EBP*QMP0*COSQM
         UP= 2.D0*M**2 - SQRTS*QP0
     >                 - 2.D0*EBP*QPP0*(1.D0-COSQP1)
         S1= 4.D0*EB*(EB-K0)
         S2= 4.D0*EB*(EB-KSL)
         T1= TE- 2.D0*(BQMK1-BPMK1+BK1K2)
         T2= TE- 2.D0*(BQMK2-BPMK2+BK1K2)
         U1= U - SQRTS*K0*(2.D0-COSK1) - M**2*K0/EB*(COSK1-1.D0)
     >       + 2.D0*BQMK1
         U2= U - SQRTS*KSL*(1.D0-COSKSL) - M**2*KSL/EB*COSKSL
     >       + 2.D0*BQMK2
         PPK1K2 = SP+UP+TP - 3.D0*M**2
         PMK1K2 = SP+U +TE - 3.D0*M**2
         QPK1K2 = S +U +TP - 3.D0*M**2
         QMK1K2 = S +UP+TE - 3.D0*M**2

         K1P = GAML4(4)+GAML4(3)
         K1M = GAML4(4)-GAML4(3)
         K2P = GAMSL4(4)+GAMSL4(3)
         K2M = GAMSL4(4)-GAMSL4(3)
         QPP = QPL4(4)+QPL4(3)
         QPM = QP0*COSQP1 - (QPP0-QP0)*(1.D0-COSQP1)
         QMP = QML4(4) + QML4(3)
         QMM = QML4(4) - QML4(3)

         DSIGE=BEEGGC(M,EB,QPL4,QML4,GAML4,GAMSL4
     >,               S1,S2,TE,T1,T2,U1,U2,PPK1K2,PMK1K2,QPK1K2,QMK1K2
     >,               K1P,K1M,K2P,K2M,QPP,QPM,QMP,QMM
     >,               BPMK1,BPMK2,BQMK1,BQMK2,BK1K2)

      ELSE IF(MTRXGG.EQ.MEEGG)THEN

         DSIGE=MEEGGC(QPL4,QML4,GAML4,GAMSL4)

      ENDIF

C Calculate approximate cross section.
C Here the approximate sigma is symmetrized for k <--> ks

      DSIGA= 2.D0*(ALPHA/PI)**4 * QP0 / COSK1M / FQP**2 / (-T)
     >           *(  1.D0/(CSKS1P+EPSLON)*DXPHI(XPHIP1)
     >             + 1.D0/(CSKS1K+EPSLON)*DXPHI(XPHIK1) )
     >           /(1.D0 - KS/PBC + EPS) / KS**2 / K0**2
     >           *(-M**2*KAP2P) * QP0/(QP0**2-M**2) * (1.D0 + EPS)

      IF(LSWAP)THEN

         DSIGA= DSIGA
     >       +2.D0*(ALPHA/PI)**4 * QP0 / (CSKS1L+EPSLON) / FQP**2 / (-T)
     >       *(  1.D0/(1.D0+KZCKC+EPSLON)*DXPHI(XPHIP2)
     >         + 1.D0/(CSKS1K+EPSLON)*DXPHI(XPHIK2)     )
     >       /(1.D0 - KC/PBC + EPS) / KC**2 / KSL**2
     >       *(-M**2*KAP1P) * QP0/(QP0**2-M**2) * (1.D0 + EPS)

      ENDIF

C The weight of this trial event is,

      WGHT = DSIGE/DSIGA
      WMAX = MAX(WMAX,WGHT)
      W1MAX= MAX(W1MAX,WGHT1)

C Keep track of quantities for the total cross section calculation.

      SUMWGT = SUMWGT + WGHT
      SUMW2  = SUMW2  + WGHT**2

      IF(UNWGHT.AND.WGHT.LT.RND(11)*WGHTMX)GOTO 1

C An event has been accepted at this point
C ----------------------------------------

      NACC=NACC+1

C Look to see if the EPA is valid for the event sample

      Q2W2MX=MAX(Q2W2MX,-T/W2)

C Calculate the 4 vectors. Decide whether to interchange or not here.

      IF(RND(12).LT..5)THEN
         IMISS=0
         IOBSV=4
         RSIGN=+1.D0
      ELSE
         IMISS=4
         IOBSV=0
         RSIGN=-1.D0
      ENDIF

      P(IMISS+1)=QPL4(1) * RSIGN
      P(IMISS+2)=QPL4(2) * RSIGN
      P(IMISS+3)=QPL4(3) * RSIGN
      P(IMISS+4)=QPL4(4)

      P(IOBSV+1)=QML4(1) * RSIGN
      P(IOBSV+2)=QML4(2) * RSIGN
      P(IOBSV+3)=QML4(3) * RSIGN
      P(IOBSV+4)=QML4(4)

      P(9) =GAML4(1) * RSIGN
      P(10)=GAML4(2) * RSIGN
      P(11)=GAML4(3) * RSIGN
      P(12)=GAML4(4)

      P(13)=GAMSL4(1) * RSIGN
      P(14)=GAMSL4(2) * RSIGN
      P(15)=GAMSL4(3) * RSIGN
      P(16)=GAMSL4(4)

      RETURN
      END

CDECK  ID>, FQPEG.  
*.
*...FQPEG    calculates the maximum energy of the `missing' electron.
*.
*.  FQPEG is a double precision function that returns the minimum
*.  Eb-qp0, given the detector acceptance, for the e-gamma configuration
*.  A value of -1 is returned if the configuration is kinematically
*.  impossible.
*.
*. INPUT     : TEMIN  minimum theta of observed electron
*. INPUT     : TGMIN  minimum theta of observed photon
*. INPUT     : EEMIN  minimum energy of observed electron
*. INPUT     : EGMIN  minimum energy of observed photon
*. INPUT     : D      maximum theta of missing electron
*. INPUT     : EB     beam energy
*.
*. CALLED    : TEEGGL
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C DOUBLE PRECISION FUNCTION FQPEG:
C Returns the minimum Eb-qp0, given the detector acceptance (e-gamma).
C Returns -1 if configuration is kinematically impossible.
C-----------------------------------------------------------------------

      DOUBLE PRECISION FUNCTION FQPEG(TEMIN,TGMIN,EEMIN,EGMIN,D,EB)
      IMPLICIT NONE

      DOUBLE PRECISION TEMIN,TGMIN,EEMIN,EGMIN,D,EB
      DOUBLE PRECISION SQRTS,DELT,FQPTST,EETST,EGTST,SINED,SINGD,CON1
      DOUBLE PRECISION SIGND(2)/1.D0,-1.D0/
      INTEGER   I,J

      SQRTS=2.*EB
      FQPEG=2.*EB

C Go through each endpoint given by two of (TEMIN,TGMIN,EEMIN,EGMIN)
C with TEVETO= DELT and -DELT

C 1) TEMIN,TGMIN

      DO 1 I=1,2
         DELT=D*SIGND(I)
         FQPTST = EB*TAN((TEMIN+DELT)/2.D0)*TAN((TGMIN-DELT)/2.D0)
         EETST = (EB+FQPTST)*SIN(TGMIN-DELT)/
     >           ( SIN(TEMIN+DELT)+SIN(TGMIN-DELT) )
         EGTST = (EB+FQPTST-EETST)
         IF(EETST.GE.EEMIN .AND. EGTST.GE.EGMIN .AND.
     >      FQPTST.GE.0.D0 )FQPEG=MIN(FQPEG,FQPTST)
 1    CONTINUE

C 2) EGMIN,TGMIN

      DO 2 I=1,2
         DELT=D*SIGND(I)
         FQPTST =  EB * EGMIN * SIN( (TGMIN-DELT)/2.D0 )**2/
     >            (EB - EGMIN * COS( (TGMIN-DELT)/2.D0 )**2)
         EETST = EB+FQPTST-EGMIN
         SINED = EGMIN/EETST * SIN(TGMIN-DELT)
         IF(EETST.GE.EEMIN .AND. SINED .GE. SIN(TEMIN+DELT) .AND.
     >      FQPTST.GE.0.D0 .AND. SINED .LE. 1.D0)FQPEG=MIN(FQPEG,FQPTST)
 2    CONTINUE


C 3) EEMIN,TEMIN

      DO 3 I=1,2
         DELT=D*SIGND(I)
         FQPTST =  EB * EEMIN * SIN( (TEMIN+DELT)/2.D0 )**2/
     >            (EB - EEMIN * COS( (TEMIN+DELT)/2.D0 )**2)
         EGTST = EB+FQPTST-EEMIN
         SINGD = EEMIN/EGTST * SIN(TEMIN+DELT)
         IF(EGTST.GE.EGMIN .AND. SINGD .GE. SIN(TGMIN-DELT) .AND.
     >      FQPTST.GE.0.D0 .AND. SINGD .LE. 1.D0)FQPEG=MIN(FQPEG,FQPTST)
 3    CONTINUE

C 4) EGMIN,TEMIN

      DO 4 I=1,2
         DELT=D*SIGND(I)
         CON1= (EGMIN/2.D0)**2 - EB*(EB-EGMIN)*TAN((TEMIN+DELT)/2.D0)**2
         IF(CON1.GE.0.D0)THEN
            DO 41 J=1,2
               FQPTST = EGMIN/2.D0 + SIGND(J)*SQRT(CON1)
               EETST=EB+FQPTST-EGMIN
               SINGD = EETST/EGMIN * SIN (TEMIN+DELT)
               IF(EETST.GE.EEMIN .AND. SINGD .GE. SIN(TGMIN-DELT) .AND.
     >           FQPTST.GE.0.D0  .AND. SINGD .LE. 1.D0
     >           )FQPEG=MIN(FQPEG,FQPTST)
 41         CONTINUE
         ENDIF
 4    CONTINUE

C 5) EEMIN,TGMIN

      DO 5 I=1,2
         DELT=D*SIGND(I)
         CON1= (EEMIN/2.D0)**2 - EB*(EB-EEMIN)*TAN((TGMIN-DELT)/2.D0)**2
         IF(CON1.GE.0.D0)THEN
            DO 51 J=1,2
               FQPTST = EEMIN/2.D0 + SIGND(J)*SQRT(CON1)
               EGTST=EB+FQPTST-EEMIN
               SINED = EGTST/EEMIN * SIN (TGMIN-DELT)
               IF(EGTST.GE.EGMIN .AND. SINED .GE. SIN(TEMIN+DELT) .AND.
     >           FQPTST.GE.0.D0  .AND. SINED .LE. 1.D0
     >           )FQPEG=MIN(FQPEG,FQPTST)
 51         CONTINUE
         ENDIF
 5    CONTINUE

C 6) EEMIN,EGMIN

      DO 6 I=1,2
         DELT=D*SIGND(I)
         FQPTST = EEMIN + EGMIN - EB
         SINED = (EGMIN**2-(EB-FQPTST-EEMIN)**2)/4.D0/(EB-FQPTST)/EEMIN
         SINGD = (EEMIN**2-(EB-FQPTST-EGMIN)**2)/4.D0/(EB-FQPTST)/EGMIN
         IF(SINED.GE.SIN((TEMIN+DELT)/2.D0)**2 .AND. SINED.LE. 1.D0.AND.
     >      SINGD.GE.SIN((TGMIN-DELT)/2.D0)**2 .AND. SINGD.LE. 1.D0
     >     )FQPEG=MIN(FQPEG,FQPTST)
 6    CONTINUE

      IF(FQPEG.GT.EB)FQPEG=-1.D0

      RETURN
      END

CDECK  ID>, DMORK.  
*.
*...DMORK    calculates the soft and virtual correction.
*.
*.  DMORK is a double precision function that returns the soft and
*.  virtual radiative correction. This routine contains the corrections
*.  to the misprints as communicated by K.J. Mork.
*.  Reference: Phys. Rev. A4 (1971) 917.
*.
*. INPUT     : T      kinematical quantity
*. INPUT     : Y      kinematical quantity
*. INPUT     : U      kinematical quantity
*. INPUT     : E      kinematical quantity
*. INPUT     : DE     kinematical quantity
*.
*. CALLS     : SPENCE
*. CALLED    : T3BODY
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C DOUBLE PRECISION FUNCTION DMORK: Calculates the soft and virtual corr.
C This routine contains the corrections to the misprints as communicated
C by K.J. Mork. Reference: Phys. Rev. A4 (1971) 917.
C-----------------------------------------------------------------------

      DOUBLE PRECISION FUNCTION DMORK(T,Y,U,E,DE)
      IMPLICIT NONE

      DOUBLE PRECISION PI,ALPHA
      PARAMETER (PI=3.14159265358979D0 , ALPHA=1.D0/137.036D0)

      DOUBLE PRECISION T,Y,U,E,DE,TERM(10),SUM
      INTEGER   I

      DOUBLE PRECISION SPENCE
      EXTERNAL SPENCE

      TERM(1) = 2.D0*(1.D0-2.D0*Y)*U*LOG(2.D0*DE)
      TERM(2) = PI**2/6.D0*(4.D0-3.D0*T-1.D0/T-2.D0/E**4/T**3)
      TERM(3) = 4.D0*(2.D0-U)*Y**2
      TERM(4) = -4.D0*Y+1.5D0*U+2.D0/E**2/T**2
      TERM(5) = 4.D0*(1.D0-.5D0/T)*LOG(E)**2
      TERM(6) = (2.D0*T+1.D0/T-2.D0+2.D0/E**4/T**3)*SPENCE(1.D0-E**2*T)
      TERM(7) = (2.D0-5.D0*T-2.D0/T+4.D0*Y*(2.D0/T+T-2.D0))*LOG(E)
      TERM(8) = -.5D0*U*LOG(1-T)**2
      TERM(9) = -U*SPENCE(T)
      TERM(10)= (1.D0-2.D0/T-2.D0/E**2/T**2-.5D0*E**2/(1.D0-E**2*T)
     >           +4.D0*Y*(T-1.D0+.5D0/T))*LOG(E**2*T)

      SUM=0.D0
      DO 1 I=1,10
 1    SUM=SUM+TERM(I)

      DMORK=-ALPHA/PI/U * SUM

      RETURN
      END

CDECK  ID>, SPENCE. 
*.
*...SPENCE   calculates the spence function for x < 1.
*.
*. INPUT     : X
*.
*. CALLED    : DMORK
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.2
*. CREATED   : 29-Jun-87
*. LAST MOD  : 10-Apr-89
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*. 10-Apr-89   Dean Karlen   Replace code by CERNLIB DILOG function.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C DOUBLE PRECISION FUNCTION SPENCE: Calculates the Spence function.(X<1)
C-----------------------------------------------------------------------

C  DOUBLE PRECISION VERSION OF DILOGARITHM FUNCTION FROM CERNLIB.

      DOUBLE PRECISION FUNCTION SPENCE(X)
      IMPLICIT NONE

      DOUBLE PRECISION X,Y,Z,A,B,S,T

      Z=-1.644934066848226 D0
      IF(X .LT.-1.0 D0) GO TO 1
      IF(X .LE. 0.5 D0) GO TO 2
      IF(X .EQ. 1.0 D0) GO TO 3
      IF(X .LE. 2.0 D0) GO TO 4
C
      Z=3.289868133696453 D0
    1 T=1.0 D0/X
      S=-0.5 D0
      Z=Z-0.5 D0*DLOG(DABS(X))**2
      GO TO 5
C
    2 T=X
      S=0.5 D0
      Z=0. D0
      GO TO 5
C
    3 SPENCE=1.644934066848226 D0
      RETURN
C
    4 T=1.0 D0-X
      S=-0.5 D0
      Z=1.644934066848226 D0-DLOG(X)*DLOG(DABS(T))
C
    5 Y=2.666666666666667 D0*T+0.666666666666667 D0
      B=      0.00000 00000 00001 D0
      A=Y*B  +0.00000 00000 00004 D0
      B=Y*A-B+0.00000 00000 00011 D0
      A=Y*B-A+0.00000 00000 00037 D0
      B=Y*A-B+0.00000 00000 00121 D0
      A=Y*B-A+0.00000 00000 00398 D0
      B=Y*A-B+0.00000 00000 01312 D0
      A=Y*B-A+0.00000 00000 04342 D0
      B=Y*A-B+0.00000 00000 14437 D0
      A=Y*B-A+0.00000 00000 48274 D0
      B=Y*A-B+0.00000 00001 62421 D0
      A=Y*B-A+0.00000 00005 50291 D0
      B=Y*A-B+0.00000 00018 79117 D0
      A=Y*B-A+0.00000 00064 74338 D0
      B=Y*A-B+0.00000 00225 36705 D0
      A=Y*B-A+0.00000 00793 87055 D0
      B=Y*A-B+0.00000 02835 75385 D0
      A=Y*B-A+0.00000 10299 04264 D0
      B=Y*A-B+0.00000 38163 29463 D0
      A=Y*B-A+0.00001 44963 00557 D0
      B=Y*A-B+0.00005 68178 22718 D0
      A=Y*B-A+0.00023 20021 96094 D0
      B=Y*A-B+0.00100 16274 96164 D0
      A=Y*B-A+0.00468 63619 59447 D0
      B=Y*A-B+0.02487 93229 24228 D0
      A=Y*B-A+0.16607 30329 27855 D0
      A=Y*A-B+1.93506 43008 69969 D0
      SPENCE=S*T*(A-B)+Z
      RETURN
      END

CDECK  ID>, TBOORT. 
*.
*...TBOORT   boost 4-momentum from gamma-electron center of mass to lab
*.
*. INPUT     : IN     4-momentum in gamma-electron center of mass
*. INPUT     : SINTR  sin(theta rotation between systems)
*. INPUT     : COSTR  cos(theta rotation between systems)
*. INPUT     : GAMA   gamma between two systems
*. INPUT     : BETA   beta between two systems
*. INPUT     : SINQP  sin(theta of g-e system wrt lab system)
*. INPUT     : COSQP1 1 - cos(theta of g-e system wrt lab system)
*. INPUT     : PHIP   pi-phi of g-e system
*. OUTPUT    : OUT    4-momentum in lab system
*.
*. CALLED    : T4BODY
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C SUBROUTINE TBOORT: Boosts 4-momentum from g-e center of mass to lab.
C-----------------------------------------------------------------------

      SUBROUTINE TBOORT(IN,SINTR,COSTR,GAMA,BETA,SINQP,COSQP1,PHIP,OUT)
      IMPLICIT NONE

      DOUBLE PRECISION
     >       IN(4),SINTR,COSTR,GAMA,BETA,SINQP,COSQP1,PHIP,OUT(4)
      DOUBLE PRECISION
     >       INROT(4),ROTBOO(4),CONST,COSQP

      INROT(1)=IN(1)*COSTR - IN(3)*SINTR
      INROT(2)=IN(2)
      INROT(3)=IN(3)*COSTR + IN(1)*SINTR
      INROT(4)=IN(4)

      COSQP = 1.D0-COSQP1
      CONST = (GAMA-1.D0)*INROT(1)*SINQP + (GAMA-1.D0)*INROT(3)*COSQP
     >        - GAMA*BETA*INROT(4)

      ROTBOO(1) = INROT(1) + CONST*SINQP
      ROTBOO(2) = INROT(2)
      ROTBOO(3) = INROT(3) + CONST*COSQP
      ROTBOO(4) = GAMA * (INROT(4) - BETA*INROT(1)*SINQP
     >                              -BETA*INROT(3)*COSQP)

      OUT(1) = ROTBOO(1)*COS(PHIP) - ROTBOO(2)*SIN(PHIP)
      OUT(2) = ROTBOO(2)*COS(PHIP) + ROTBOO(1)*SIN(PHIP)
      OUT(3) = ROTBOO(3)
      OUT(4) = ROTBOO(4)

      RETURN
      END

CDECK  ID>, BEEGGC. 
*.
*...BEEGGC   calculates dbl radiative Bhabha according to CALKUL collab.
*.
*.  BEEGGC is a double precision function that calcualtes the squared
*.  matrix element for,
*.
*.    +  _      +  _
*.   e  e  --> e  e  gamma gamma
*.
*.using the equations supplied by Berends et al. Nucl.Phys.B264(1986)265
*.
*. COMMON    : TEVQUA
*. CALLS     : BCOLL BEEGGM TPRD
*. CALLED    : T4BODY
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C DOUBLE PRECISION FUNCTION BEEGGC: Calculates the matrix element for,
C     +  _      +  _
C    e  e  --> e  e  gamma gamma
C
C using the equations supplied by Berends et al. Nucl.Phys.B264(1986)265
C-----------------------------------------------------------------------

      DOUBLE PRECISION FUNCTION BEEGGC(M,EB,QP,QM,K1,K2
     >,            S1,S2,T,T1,T2,U1,U2,PPK1K2,PMK1K2,QPK1K2,QMK1K2
     >,            K1P,K1M,K2P,K2M,QPP,QPM,QMP,QMM
     >,            BPMK1,BPMK2,BQMK1,BQMK2,BK1K2)
      IMPLICIT NONE

      DOUBLE PRECISION ALPHA,PI
      PARAMETER
     >(           ALPHA = 1.D0/137.036D0
     >,           PI    = 3.14159265358979D0
     >)

      DOUBLE PRECISION TA,TP,SP,U,UP
      COMMON/TEVQUA/TA,TP,SP,U,UP

C Input parameters
      DOUBLE PRECISION M,EB,PP(4),PM(4),QP(4),QM(4),K1(4),K2(4)
     >,            S1,S2,T,T1,T2,U1,U2,PPK1K2,PMK1K2,QPK1K2,QMK1K2
     >,            K1P,K1M,K2P,K2M,QPP,QPM,QMP,QMM
     >,            BPMK1,BPMK2,BQMK1,BQMK2,BK1K2

C Real quantities
      DOUBLE PRECISION S,QPK1,QPK2,PPK1,PPK2
     >,      V1Q(4),V1P(4),V1QV1P(4),V2Q(4),V2P(4),V2QV2P(4)
     >,      ABSQM,COLCUT,CQMK2,CPMK2,SP2,TP2,UP2,KPP2M,KPP2P
     >,      TERM1,TERM2,TERM3

C Externals
      DOUBLE PRECISION
     >         TPRD,BEEGGM,BCOLL
      EXTERNAL TPRD,BEEGGM,BCOLL

      PP(1)=0.D0
      PP(2)=0.D0
      PP(3)=SQRT(EB**2 - M**2)
      PP(4)=EB

      PM(1)=0.D0
      PM(2)=0.D0
      PM(3)=-SQRT(EB**2 - M**2)
      PM(4)=EB

      S = 4.D0*EB**2

      QPK1 = TPRD(QP,K1)
      PPK1 = TPRD(PP,K1)

      V1Q(1)=QP(1)/QPK1 - QM(1)/BQMK1
      V1Q(2)=QP(2)/QPK1 - QM(2)/BQMK1
      V1Q(3)=QP(3)/QPK1 - QM(3)/BQMK1
      V1Q(4)=QP(4)/QPK1 - QM(4)/BQMK1

      V1P(1)=PP(1)/PPK1 - PM(1)/BPMK1
      V1P(2)=PP(2)/PPK1 - PM(2)/BPMK1
      V1P(3)=PP(3)/PPK1 - PM(3)/BPMK1
      V1P(4)=PP(4)/PPK1 - PM(4)/BPMK1

      V1QV1P(1) = V1Q(1) - V1P(1)
      V1QV1P(2) = V1Q(2) - V1P(2)
      V1QV1P(3) = V1Q(3) - V1P(3)
      V1QV1P(4) = V1Q(4) - V1P(4)

      QPK2 = TPRD(QP,K2)
      PPK2 = TPRD(PP,K2)

      V2Q(1)=QP(1)/QPK2 - QM(1)/BQMK2
      V2Q(2)=QP(2)/QPK2 - QM(2)/BQMK2
      V2Q(3)=QP(3)/QPK2 - QM(3)/BQMK2
      V2Q(4)=QP(4)/QPK2 - QM(4)/BQMK2

      V2P(1)=PP(1)/PPK2 - PM(1)/BPMK2
      V2P(2)=PP(2)/PPK2 - PM(2)/BPMK2
      V2P(3)=PP(3)/PPK2 - PM(3)/BPMK2
      V2P(4)=PP(4)/PPK2 - PM(4)/BPMK2

      V2QV2P(1) = V2Q(1) - V2P(1)
      V2QV2P(2) = V2Q(2) - V2P(2)
      V2QV2P(3) = V2Q(3) - V2P(3)
      V2QV2P(4) = V2Q(4) - V2P(4)

      ABSQM = SQRT(QM(4)**2-M**2)
      COLCUT=SQRT(M*EB)

C Check if a collinear cross section should be used...
C if K2 is collinear with both p- and q-, choose the smaller coll

      CPMK2=BCOLL(PM,K2)
      CQMK2=BCOLL(QM,K2)
      IF(MAX(CPMK2,CQMK2).LT.COLCUT)THEN
         IF(CPMK2.LT.CQMK2)THEN
            CQMK2=COLCUT*10.D0
         ELSE
            CPMK2=COLCUT*10.D0
         ENDIF
      ENDIF

      IF(CQMK2.LT.COLCUT)THEN

         SP2 = S1
         TP2 = T1
         UP2 = U1
         KPP2M = (BQMK2 - K2(4)*(QM(4)-ABSQM))/ABSQM
         KPP2P = 2.D0*K2(4)-KPP2M
         BEEGGC = -ALPHA**4/2.D0/PI**4/S
     >             * TPRD(V1QV1P,V1QV1P)
     >             * QM(4)*KPP2M/(2.D0*QM(4)+KPP2P)/KPP2P/BQMK2**2
     >             * ( 4.D0*QM(4)**2 + (2.D0*QM(4)+KPP2P)**2
     >                + M**2*KPP2P**3/4.D0/QM(4)**2/KPP2M )
     >             * ( S*SP2*(S**2+SP2**2) + T*TP2*(T**2+TP2**2)
     >                +U2*UP*(U2**2+UP**2) )
     >             / (S*SP2*T*TP2)

      ELSE IF(CPMK2.LT.COLCUT)THEN

         SP2 = S1
         TP2 = T1
         UP2 = U1
         BEEGGC = -ALPHA**4/2.D0/PI**4/S
     >             * TPRD(V1QV1P,V1QV1P)
     >             * EB*K2P/(2.D0*EB-K2M)/K2M/BPMK2**2
     >             * ( S + (2.D0*EB-K2M)**2 + M**2*K2M**3/S/K2P )
     >             * ( S2*SP*(S2**2+SP**2) + T*TP2*(T**2+TP2**2)
     >                +U*UP2*(U**2+UP2**2) )
     >             / (S2*SP*T*TP2)

      ELSE

         TERM1 =ALPHA**4/4.D0/PI**4/S
     >          * TPRD(V1QV1P,V1QV1P) * TPRD(V2QV2P,V2QV2P)
     >          *(S*SP*(S**2+SP**2)+T*TP*(T**2+TP**2)+U*UP*(U**2+UP**2))
     >          /(S*SP*T*TP)
         TERM2 =  4.D0*ALPHA**4 / PI**4 /S
     >             * BEEGGM(M,EB,PP,PM,QP,QM,K1,K2
     >,               S1,S2,T1,T2,U1,U2,PPK1K2,PMK1K2,QPK1K2,QMK1K2
     >,               K1P,K1M,K2P,K2M,QPP,QPM,QMP,QMM)
         TERM3 =  4.D0*ALPHA**4 / PI**4 /S
     >             * BEEGGM(M,EB,PP,PM,QP,QM,K2,K1
     >,               S2,S1,T2,T1,U2,U1,PPK1K2,PMK1K2,QPK1K2,QMK1K2
     >,               K2P,K2M,K1P,K1M,QPP,QPM,QMP,QMM)
         BEEGGC=TERM1+TERM2+TERM3

      ENDIF

      RETURN
      END

CDECK  ID>, BCOLL.  
*.
*...BCOLL    determines if collinear photon calcuation should be used.
*.
*. INPUT     : P      electron 4-momentum
*. INPUT     : K      photon 4-momentum
*.
*. CALLED    : BEEGGC
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C DOUBLE PRECISION FUNCTION BCOLL: Determines if photon is collinear
C with a fermion. Does not need to be very accurate.
C-----------------------------------------------------------------------

      DOUBLE PRECISION FUNCTION BCOLL(P,K)
      IMPLICIT NONE

      DOUBLE PRECISION P(4),K(4)
      DOUBLE PRECISION COST,SINT

      BCOLL=999.D0
      COST=(P(1)*K(1)+P(2)*K(2)+P(3)*K(3))
     >     /SQRT(P(1)**2+P(2)**2+P(3)**2)/K(4)
      SINT=SQRT(1.D0-COST**2)
      IF(COST.GT.0.D0)BCOLL=K(4)*SINT

      RETURN
      END

CDECK  ID>, BEEGGM. 
*.
*...BEEGGM   calculates the squared matrix element for the CAKCUL calc.
*.
*. COMMON    : TEVQUA
*. CALLED    : BEEGGC
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C DOUBLE PRECISION FUNCTION BEEGGM: Calculates the squared matrix elemnt
C-----------------------------------------------------------------------

      DOUBLE PRECISION FUNCTION BEEGGM(M,EB,PP,PM,QP,QM,K1,K2
     >,            S1,S2,T1,T2,U1,U2,PPK1K2,PMK1K2,QPK1K2,QMK1K2
     >,            K1P,K1M,K2P,K2M,QPP,QPM,QMP,QMM)
      IMPLICIT NONE

      COMPLEX*16 I
      PARAMETER( I = (0.D0,1.D0) )

      DOUBLE PRECISION T,TP,SP,U,UP
      COMMON/TEVQUA/T,TP,SP,U,UP

C Input parameters
      DOUBLE PRECISION M,EB,PP(4),PM(4),QP(4),QM(4),K1(4),K2(4)
     >,            S1,S2,T1,T2,U1,U2,PPK1K2,PMK1K2,QPK1K2,QMK1K2
     >,            K1P,K1M,K2P,K2M,QPP,QPM,QMP,QMM

      INTEGER   J

C Real quantities
      DOUBLE PRECISION ECM,S

C Complex quantities
      COMPLEX*16 QPT,QMT,K1T,K2T,WP,WM,W1,W2
     >,          A,A1,B,B1,C,C1,C11,C111,D,D1
     >,          M1,M1TERM(12),M2,M2TERM(8),M3,M3TERM(8)

C Externals
      DOUBLE PRECISION TPRD
      EXTERNAL TPRD

      ECM=2.D0*EB
      S=ECM**2

      QPT = QP(1) + I*QP(2)
      QMT = QM(1) + I*QM(2)
      K1T = K1(1) + I*K1(2)
      K2T = K2(1) + I*K2(2)

      WP = QPT/QPP
      WM = QMT/QMP
      W1 = K1T/K1P
      W2 = K2T/K2P

      A = QPP * CONJG(WP) + K1P * CONJG(W1)
      A1= QMP * CONJG(WM) + K1P * CONJG(W1)

      B = ECM - K1M + CONJG(K1T)*WP + K1T*CONJG(WM) - K1P*WP*CONJG(WM)
      B1= ECM - K1M + CONJG(K1T)*WM + K1T*CONJG(WP) - K1P*WM*CONJG(WP)

      C   = ECM - K1M + CONJG(K1T)*WP
      C1  = ECM - K1M + CONJG(K1T)*WM
      C11 = ECM - K2M + CONJG(K2T)*WP
      C111= ECM - K2M + CONJG(K2T)*WM

      D = (ECM-K2P)*CONJG(WM) + CONJG(K2T)
      D1= (ECM-K2P)*CONJG(WP) + CONJG(K2T)

      M1TERM(1) = SQRT(QPP/QMP) / (S1*K1P*K2P) * C/CONJG(W1)
     >            * C/(WP-W2)/(WM-W2)

      M1TERM(2) = SQRT(QMP/QPP) / (S2*K1P*K2P) * D/W2
     >            * D/CONJG(WP-W1)/CONJG(WM-W1)

      M1TERM(3) = ECM / SQRT(QPP*QMP) / (S*K1P*K2P) * C/(WP-W2)/(WM-W2)
     >            * D/CONJG(WP-W1)/CONJG(WM-W1)

      M1TERM(4) = SQRT(QPP*QMP) / ECM / (SP*K1P*K2P) * C/CONJG(W1)*D/W2

      M1TERM(5) = ECM / SQRT(QPP*QMP) / (T1*K1P*K2P)
     >            * A/CONJG(W1)/CONJG(WP-W1) * A/(WM-W2)

      M1TERM(6) = SQRT(QPP*QMP) / ECM / (T2*K1P*K2P)
     >            * B/CONJG(WM-W1) * B/W2/(WP-W2)

      M1TERM(7) =-SQRT(QPP/QMP) / (T*K1P*K2P) * A/(WM-W2)
     >            * B/CONJG(WM-W1)

      M1TERM(8) =-SQRT(QMP/QPP) / (TP*K1P*K2P)
     >            * A/CONJG(W1)/CONJG(WP-W1) *B/W2/(WP-W2)

      M1TERM(9) =-SQRT(QPP*QMP) / PPK1K2 * (1.D0/SP + 1.D0/TP)
     >            * CONJG(W2)/CONJG(W1)/W2 * ( B + (WP-W1)*D )

      M1TERM(10)= SQRT(QPP*QMP) / PMK1K2 * (1.D0/SP + 1.D0/T )
     >            *( CONJG(W2)*B + CONJG(WM-W2)*C )

      M1TERM(11)=-SQRT(QMP/QPP) * ECM/QPK1K2 * (1.D0/S + 1.D0/TP)
     >            * (WP-W1)/CONJG(WP-W1)/(WP-W2)
     >            *( CONJG(W2)*D + CONJG(W2-WM)*A )

      M1TERM(12)= SQRT(QPP/QMP) * ECM/QMK1K2 * (1.D0/S + 1.D0/T)
     >            * CONJG(WM-W2)/CONJG(WM-W1)/(WM-W2)
     >            *( C + (W1-WP)*A )

      M1 = (0.D0,0.D0)
      DO 1 J=1,12
 1    M1 = M1 + M1TERM(J)

      M2TERM(1) =-SQRT(QMP/QPP) / (S1*K1P*K2P) * C1/CONJG(W1)
     >            * C1/(WM-W2)/(WP-W2)

      M2TERM(2) =-SQRT(QPP/QMP) / (S2*K1P*K2P) * D1/W2
     >            * D1/CONJG(WM-W1)/CONJG(WP-W1)

      M2TERM(3) = ECM / SQRT(QPP*QMP) / (S*K1P*K2P) * C1/(WM-W2)/(WP-W2)
     >            * D1/CONJG(WM-W1)/CONJG(WP-W1)

      M2TERM(4) = SQRT(QPP*QMP)/ECM  / (SP*K1P*K2P) * C1/CONJG(W1)*D1/W2

      M2TERM(5) =-SQRT(QPP*QMP) / PPK1K2 * (1.D0/SP)
     >            * CONJG(W2)/CONJG(W1)/W2 * ( B1 + (WM-W1)*D1 )

      M2TERM(6) = SQRT(QPP*QMP) / PMK1K2 * (1.D0/SP)
     >            *( CONJG(W2)*B1 + CONJG(WP-W2)*C1)

      M2TERM(7) =-SQRT(QPP/QMP) * ECM/QMK1K2 * (1.D0/S)
     >            * (WM-W1)/CONJG(WM-W1)/(WM-W2)
     >            *( CONJG(W2)*D1 + CONJG(W2-WP)*A1 )

      M2TERM(8) = SQRT(QMP/QPP) * ECM/QPK1K2 * (1.D0/S)
     >            * CONJG(WP-W2)/CONJG(WP-W1)/(WP-W2)
     >            *( C1 + (W1-WM)*A1 )

      M2 = (0.D0,0.D0)
      DO 2 J=1,8
 2    M2 = M2 + M2TERM(J)

      M3TERM(1) =-SQRT(QPP/QMP) / (T2*K1P*K2P)
     >            * CONJG(D1)/CONJG(WM-W1) * CONJG(D1)/W2/(WP-W2)

      M3TERM(2) =-SQRT(QMP/QPP) / (T1*K1P*K2P)
     >            * C111/(WM-W2) * C111/CONJG(W1)/CONJG(WP-W1)

      M3TERM(3) = SQRT(QPP/QMP) / (T*K1P*K2P)
     >            * CONJG(D1)/CONJG(WM-W1) * C111/(WM-W2)

      M3TERM(4) = SQRT(QMP/QPP) / (TP*K1P*K2P)
     >            * CONJG(D1)/W2/(WP-W2) * C111/CONJG(W1)/CONJG(WP-W1)

      M3TERM(5) = SQRT(QPP*QMP) / PPK1K2 * (1.D0/TP)
     >            * CONJG(W2)/CONJG(W1)/W2
     >            * ( (WP-W1)*CONJG(D) + (W1-WM)*CONJG(D1) )

      M3TERM(6) =-SQRT(QPP*QMP) / PMK1K2 * (1.D0/T)
     >            *( (W1-WP)*C111 + (WM-W1)*C11 )

      M3TERM(7) = SQRT(QMP/QPP) * ECM/QPK1K2 * (1.D0/TP)
     >            * (WP-W1)/(WP-W2)/CONJG(WP-W1)
     >            *( C111 + CONJG(W2)*CONJG(D) )

      M3TERM(8) =-SQRT(QPP/QMP) * ECM/QMK1K2 * (1.D0/T)
     >            * (WM-W1)/CONJG(WM-W1)/(WM-W2)
     >            *( C11 +  CONJG(W2)*CONJG(D1) )

      M3 = (0.D0,0.D0)
      DO 3 J=1,8
 3    M3 = M3 + M3TERM(J)

      BEEGGM = ABS(M1)**2 + ABS(M2)**2 + ABS(M3)**2

      RETURN
      END

C End of non-APOLLO specific code

CDECK  ID>, TPRD.   
*.
*...TPRD     calcuates the invariant product of two 4-vectors
*.
*. INPUT     : A      a 4-vector
*. INPUT     : B      another 4-vector
*.
*. CALLED    : T4BODY BEEGGC
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C DOUBLE PRECISION FUNCTION TPRD: Calculates the invariant product.
C-----------------------------------------------------------------------

      DOUBLE PRECISION FUNCTION TPRD(A,B)
      IMPLICIT NONE
      DOUBLE PRECISION A(4),B(4)
      TPRD = A(4)*B(4) - A(1)*B(1) - A(2)*B(2) - A(3)*B(3)
      RETURN
      END

CDECK  ID>, INMART. 
*.
*...INMART   initializes some constants for Martinez/Miquel calculation
*.
*. SEQUENCE  : TEGCOM
*. COMMON    : MCONST MARQED MLEPT1
*. CALLED    : TEEGGL
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C SUBROUTINE INMART: Initialization of some constants of Martinez/Miquel
C-----------------------------------------------------------------------

      SUBROUTINE INMART
      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


      DOUBLE PRECISION PIMART,DR,SR2,PB,ALF,ALF2,ALDPI,ME,ME2
      COMMON /MCONST/PIMART,DR,SR2,PB
      COMMON /MARQED/  ALF,ALF2,ALDPI
      COMMON /MLEPT1/ME,ME2

      PIMART = PI
      SR2    = SQRT(2.D0)
      ALF    = ALPHA
      ALF2   = ALPHA**2
      ALDPI  = ALPHA/PI
      ME     = M
      ME2    = M**2

      RETURN
      END

CDECK  ID>, MEEGGC. 
*.
*...MEEGGC   provides the interface to the Martinez/Miquel calculation
*.
*. INPUT     : QPL4   4-momentum of final state positron in lab system
*. INPUT     : QML4   4-momentum of final state electron in lab system
*. INPUT     : GAML4  4-momentum of final state photon in lab system
*. INPUT     : GAMSL4 4-momentum of 2nd final state photon in lab system
*.
*. SEQUENCE  : TEGCOM
*. COMMON    : MOMENZ
*. CALLS     : ELEMAT
*. CALLED    : T4BODY
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C DOUBLE PRECISION FUNCTION MEEGGC: Interface to Martinez/Miquel program
C-----------------------------------------------------------------------


      DOUBLE PRECISION FUNCTION MEEGGC(QPL4,QML4,GAML4,GAMSL4)
      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


      DOUBLE PRECISION QPL4(4),QML4(4),GAML4(4),GAMSL4(4)
      DOUBLE PRECISION ANS
      COMMON / MOMENZ / P1,P2,P3,P4,P5,P6
      DOUBLE PRECISION P1(5),P2(5),P3(5),P4(5),P5(5),P6(5)

      INTEGER   I

      P1(1)=0.D0
      P1(2)=0.D0
      P1(3)=-EBP
      P1(4)=EB

      P2(1)=0.D0
      P2(2)=0.D0
      P2(3)=EBP
      P2(4)=EB

      DO 3 I=1,4
 3    P3(I)=QML4(I)
      DO 4 I=1,4
 4    P4(I)=QPL4(I)
      DO 5 I=1,4
 5    P5(I)=GAML4(I)
      DO 6 I=1,4
 6    P6(I)=GAMSL4(I)

      P1(5)=M
      P2(5)=M
      P3(5)=M
      P4(5)=M
      P5(5)=0.D0
      P6(5)=0.D0

      CALL ELEMAT(ANS)

      MEEGGC=ANS/(TWOPI**8)/2./S *2.

      RETURN
      END

CDECK  ID>, ELEMAT. 

C ----------------------------------------------------------------------
C MARTINEZ/MIQUEL SUBROUTINES:
C The routines below were provided by Martinez & Miquel.
C Reference: preprint UAB-LFAE 87-01 (Barcelona)
C ----------------------------------------------------------------------

C The following external references have had their names changed to
C protect the innocent (more obscure names so that conflicts are
C less likely).

C Original subprogram name        New name
C ------------------------        --------
C ELEMAT                           (same)
C AMTOT                            AMTOTM
C AMPLI                            AMPLIM
C Z                                ZMART
C SPININ                           (same)

C Original common block name      New name
C --------------------------      --------
C PRODUX                           (same)
C CONST                            MCONST
C QED                              MARQED
C LEPT1                            MLEPT1
C MOMENZ                           (same)

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C    THIS ROUTINE CALCULATES THE MATRIX ELEMENT SQUARED
C    FOR THE PROCESS
C    E-(P1) + E+(P2) ----> E-(P3) + E+(P4) + G(P5) + G(P6)
C    THE OUTPUT CONTAINS ALL FACTORS RELATED WITH MAT. ELEMENT
C    BUT NOT CONVERSION TO PB.
C
C    (THIS HELICITY AMPLITUDES METHOD IS DESCRIBED, FOR INSTANCE,
C     IN DESY 86-062 AND 86-114 REPORTS)
C
C                          M.MARTINEZ & R.MIQUEL   BARCELONA-87
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE ELEMAT(WT)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DIMENSION NCONF1(6,16),NCONF2(6,16),NCONF3(6,16),NCONF4(6,16)
      DATA NCONF1/
     . 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1,-1,
     . 1, 1, 1, 1,-1,-1,   1, 1, 1, 1,-1, 1,
     . 1, 1,-1,-1, 1, 1,   1, 1,-1,-1, 1,-1,
     . 1, 1,-1,-1,-1,-1,   1, 1,-1,-1,-1, 1,
     .-1,-1,-1,-1, 1, 1,  -1,-1,-1,-1, 1,-1,
     .-1,-1,-1,-1,-1,-1,  -1,-1,-1,-1,-1, 1,
     .-1,-1, 1, 1, 1, 1,  -1,-1, 1, 1, 1,-1,
     .-1,-1, 1, 1,-1,-1,  -1,-1, 1, 1,-1, 1/
      DATA NCONF2/
     . 1, 1, 1,-1, 1, 1,   1, 1, 1,-1, 1,-1,
     . 1, 1, 1,-1,-1,-1,   1, 1, 1,-1,-1, 1,
     . 1, 1,-1, 1, 1, 1,   1, 1,-1, 1, 1,-1,
     . 1, 1,-1, 1,-1,-1,   1, 1,-1, 1,-1, 1,
     .-1,-1,-1, 1, 1, 1,  -1,-1,-1, 1, 1,-1,
     .-1,-1,-1, 1,-1,-1,  -1,-1,-1, 1,-1, 1,
     .-1,-1, 1,-1, 1, 1,  -1,-1, 1,-1, 1,-1,
     .-1,-1, 1,-1,-1,-1,  -1,-1, 1,-1,-1, 1/
      DATA NCONF3/
     . 1,-1, 1, 1, 1, 1,   1,-1, 1, 1, 1,-1,
     . 1,-1, 1, 1,-1,-1,   1,-1, 1, 1,-1, 1,
     . 1,-1,-1,-1, 1, 1,   1,-1,-1,-1, 1,-1,
     . 1,-1,-1,-1,-1,-1,   1,-1,-1,-1,-1, 1,
     .-1, 1,-1,-1, 1, 1,  -1, 1,-1,-1, 1,-1,
     .-1, 1,-1,-1,-1,-1,  -1, 1,-1,-1,-1, 1,
     .-1, 1, 1, 1, 1, 1,  -1, 1, 1, 1, 1,-1,
     .-1, 1, 1, 1,-1,-1,  -1, 1, 1, 1,-1, 1/
      DATA NCONF4/
     . 1,-1, 1,-1, 1, 1,   1,-1, 1,-1, 1,-1,
     . 1,-1, 1,-1,-1,-1,   1,-1, 1,-1,-1, 1,
     . 1,-1,-1, 1, 1, 1,   1,-1,-1, 1, 1,-1,
     . 1,-1,-1, 1,-1,-1,   1,-1,-1, 1,-1, 1,
     .-1, 1,-1, 1, 1, 1,  -1, 1,-1, 1, 1,-1,
     .-1, 1,-1, 1,-1,-1,  -1, 1,-1, 1,-1, 1,
     .-1, 1, 1,-1, 1, 1,  -1, 1, 1,-1, 1,-1,
     .-1, 1, 1,-1,-1,-1,  -1, 1, 1,-1,-1, 1/
C
      NSPIN = 16
      CALL SPININ(0)
C
      WT = 0.D0
      DO 100 I=1,NSPIN
      PCONF = AMTOTM(NCONF1(1,I))
      WT  = WT + PCONF
 100  CONTINUE
      DO 200 I=1,NSPIN
      PCONF = AMTOTM(NCONF2(1,I))
      WT  = WT + PCONF
 200  CONTINUE
      DO 300 I=1,NSPIN
      PCONF = AMTOTM(NCONF3(1,I))
      WT  = WT + PCONF
 300  CONTINUE
      DO 400 I=1,NSPIN
      PCONF = AMTOTM(NCONF4(1,I))
      WT  = WT + PCONF
 400  CONTINUE
C
C   FACTOR 8 STANDS FOR AVERAGE OVER INITIAL POLS AND PHOT SYMM FACTOR
      WT = WT/8.D0
      RETURN
      END

CDECK  ID>, AMTOTM. 

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C    THIS FUNCTION ADDS THE CONTRIBUTION OF ALL THE POLARIZATION
C    CONFIGURATIONS BY THE ADEQUATE PERMUTATIONS OF THE ONE
C    CALCULATED IN AMPLI
C
C                           M.MARTINEZ & R.MIQUEL  BARCELONA-87
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      FUNCTION AMTOTM(L)
      IMPLICIT DOUBLE PRECISION(A-H,M,O-Z)
      COMPLEX*16 AMT,AMPLIM,SP,SM
      DIMENSION SP(6,6),SM(6,6),D(6,6),E(6),U(6),B(6)
      DIMENSION L(6)
      COMMON / PRODUX / SP,SM,U,E,D
      COMMON /MCONST/ PI,DR,SR2,PB
C
C  SR2 IS THE SQUARED ROOT OF 2
      COMMON /MARQED/ALF,ALF2,ALDPI
      DATA INIT/0/
      IF(INIT.NE.0)GO TO 100
      INIT=1
C
C  OVERALL FACTOR
      AMFAC = (4.D0*PI*ALF)**4
100   CONTINUE
C
      AMT =    AMPLIM (1,L(1),2,L(2),3,L(3),4,L(4),5, L(5),6, L(6),1)
     .+        AMPLIM (4,L(4),3,L(3),2,L(2),1,L(1),6, L(6),5, L(5),1)
     .+ DCONJG(AMPLIM (3,L(3),4,L(4),1,L(1),2,L(2),6,-L(6),5,-L(5),1)
     .    +    AMPLIM (2,L(2),1,L(1),4,L(4),3,L(3),5,-L(5),6,-L(6),1))
     .+        AMPLIM (1,L(1),2,L(2),3,L(3),4,L(4),5, L(5),6, L(6),2)
     .+        AMPLIM (4,L(4),3,L(3),2,L(2),1,L(1),6, L(6),5, L(5),2)
     .+        AMPLIM (1,L(1),2,L(2),3,L(3),4,L(4),5, L(5),6, L(6),3)
     .+ DCONJG(AMPLIM (3,L(3),4,L(4),1,L(1),2,L(2),5,-L(5),6,-L(6),3))
     .+        AMPLIM (1,L(1),2,L(2),3,L(3),4,L(4),5, L(5),6, L(6),4)
     .+ DCONJG(AMPLIM (3,L(3),4,L(4),1,L(1),2,L(2),5,-L(5),6,-L(6),4))
C
      AMT =    AMT
     .+        AMPLIM (1,L(1),2,L(2),3,L(3),4,L(4),6, L(6),5, L(5),1)
     .+        AMPLIM (4,L(4),3,L(3),2,L(2),1,L(1),5, L(5),6, L(6),1)
     .+ DCONJG(AMPLIM (3,L(3),4,L(4),1,L(1),2,L(2),5,-L(5),6,-L(6),1)
     .    +    AMPLIM (2,L(2),1,L(1),4,L(4),3,L(3),6,-L(6),5,-L(5),1))
     .+        AMPLIM (1,L(1),2,L(2),3,L(3),4,L(4),6, L(6),5, L(5),2)
     .+        AMPLIM (4,L(4),3,L(3),2,L(2),1,L(1),5, L(5),6, L(6),2)
     .+        AMPLIM (1,L(1),2,L(2),3,L(3),4,L(4),6, L(6),5, L(5),3)
     .+ DCONJG(AMPLIM (3,L(3),4,L(4),1,L(1),2,L(2),6,-L(6),5,-L(5),3))
     .+        AMPLIM (1,L(1),2,L(2),3,L(3),4,L(4),6, L(6),5, L(5),4)
     .+ DCONJG(AMPLIM (3,L(3),4,L(4),1,L(1),2,L(2),6,-L(6),5,-L(5),4))
C
      AMTOTM =  AMFAC*AMT*DCONJG(AMT)
      RETURN
      END

CDECK  ID>, AMPLIM. 

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C    THIS FUNCTION CALCULATES THE AMPLITUDE FOR THE
C    GAMMA IN T-CHANNEL FOR THE PROCESS
C    E-(P1) + E+(P2) ----> E-(P3) + E+(P4) + G(P5) + G(P6)
C    WITH BREMSS. FROM THE SAME                  E+ OR E-  WITH IND=1
C    WITH BREMSS. FROM DIFFERENT                 E+ OR E-  WITH IND=2
C    WITH BREMSS. FROM BOTH INITIAL OR FINAL     E+ &  E-  WITH IND=3
C    WITH BREMSS. FROM ONE INITIAL AND ONE FINAL E+ &  E-  WITH IND=4
C
C                            M.MARTINEZ & R.MIQUEL   BARCELONA-87
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      FUNCTION AMPLIM(P1,L1,P2,L2,P3,L3,P4,L4,P5,L5,P6,L6,IND)
      IMPLICIT DOUBLE PRECISION(A-H,M,O-Z)
      COMPLEX*16 ZMART,SP,SM
      COMPLEX*16 AMPLIM,ZREP1,ZREP5
      INTEGER P,P1,P2,P3,P4,P5,P6
      COMMON / PRODUX / SP,SM,U,E,D
      COMMON /MCONST / PI,DR,SR2,PB
      COMMON /MLEPT1/ME,ME2
C
C  ME IS THE ELECTRON MASS
C  ME2 = ME**2
      DIMENSION SP(6,6),SM(6,6),D(6,6),E(6),U(6),B(6)
C
C  INITIALIZATION
      DATA B/1.D0, 1.D0,-1.D0,-1.D0,-1.D0,-1.D0/
      DATA P/3/
C
      AMPLIM = (0.D0,0.D0)
C
C  NORMALIZATION FACTORS FOR THE PHOTON POLARIZATION VECTOR
      ZN5=1.D0/(SR2 * CDABS(SP(P,P5)) )
      ZN6=1.D0/(SR2 * CDABS(SP(P,P6)) )
C
C   LOOP OVER REPEATED INDEX "IL" AND  "ILP"
      DO 100 I1=1,2
      ILP   = 2*I1 - 3
      ZREP5 = ZMART(P5,ILP,P1,L1,P,L5,P5,L5)
      ZREP1 = ZMART(P1,ILP,P1,L1,P,L5,P5,L5)
      DO 100 I2=1,2
      IL    = 2*I2 - 3
      IF     (IND.EQ.1) THEN
      AMPLIM = AMPLIM +
     .   ZMART(P2,L2,P4,L4,P3,L3,P1,IL)             * B(P1) *
     .     (ZMART(P1,IL,P5,ILP,P,L6,P6,L6)  * ZREP5 * B(P5)
     .     +ZMART(P1,IL,P1,ILP,P,L6,P6,L6)  * ZREP1 * B(P1))
     . + ZMART(P2,L2,P4,L4,P3,L3,P5,IL)             * B(P5) *
     .     (ZMART(P5,IL,P5,ILP,P,L6,P6,L6)  * ZREP5 * B(P5)
     .     +ZMART(P5,IL,P1,ILP,P,L6,P6,L6)  * ZREP1 * B(P1))
     . + ZMART(P2,L2,P4,L4,P3,L3,P6,IL)             * B(P6) *
     .     (ZMART(P6,IL,P5,ILP,P,L6,P6,L6)  * ZREP5 * B(P5)
     .     +ZMART(P6,IL,P1,ILP,P,L6,P6,L6)  * ZREP1 * B(P1))
C
      ELSE IF(IND.EQ.2) THEN
      AMPLIM  = AMPLIM +
     .   ZMART(P3,L3,P6,IL,P,L6,P6,L6)              * B(P6) *
     .     (ZMART(P2,L2,P4,L4,P6,IL,P1,ILP) * ZREP1 * B(P1)
     .    + ZMART(P2,L2,P4,L4,P6,IL,P5,ILP) * ZREP5 * B(P5))
     . + ZMART(P3,L3,P3,IL,P,L6,P6,L6)              * B(P3) *
     .     (ZMART(P2,L2,P4,L4,P3,IL,P1,ILP) * ZREP1 * B(P1)
     .    + ZMART(P2,L2,P4,L4,P3,IL,P5,ILP) * ZREP5 * B(P5))
C
      ELSE IF(IND.EQ.3) THEN
      AMPLIM  = AMPLIM +
     .   ZMART(P2,L2,P6,IL,P,L6,P6,L6)              * B(P6) *
     .     (ZMART(P3,L3,P1,ILP,P6,IL,P4,L4) * ZREP1 * B(P1)
     .    + ZMART(P3,L3,P5,ILP,P6,IL,P4,L4) * ZREP5 * B(P5))
     . + ZMART(P2,L2,P2,IL,P,L6,P6,L6)              * B(P2) *
     .     (ZMART(P3,L3,P1,ILP,P2,IL,P4,L4) * ZREP1 * B(P1)
     .    + ZMART(P3,L3,P5,ILP,P2,IL,P4,L4) * ZREP5 * B(P5))
C
      ELSE IF(IND.EQ.4) THEN
      AMPLIM  = AMPLIM +
     .   ZMART(P6,IL,P4,L4,P,L6,P6,L6)              * B(P6) *
     .     (ZMART(P3,L3,P1,ILP,P2,L2,P6,IL) * ZREP1 * B(P1)
     .    + ZMART(P3,L3,P5,ILP,P2,L2,P6,IL) * ZREP5 * B(P5))
     . + ZMART(P4,IL,P4,L4,P,L6,P6,L6)              * B(P4) *
     .     (ZMART(P3,L3,P1,ILP,P2,L2,P4,IL) * ZREP1 * B(P1)
     .    + ZMART(P3,L3,P5,ILP,P2,L2,P4,IL) * ZREP5 * B(P5))
      ENDIF
 100  CONTINUE
C
C   PROPAGATORS
      PROP1 = B(P2)*B(P4)*D(P2,P4) + 2.D0*ME2
      PROP2 = B(P1)*B(P5)*D(P1,P5)
      PROP3 = B(P1)*B(P5)*D(P1,P5) +
     .        B(P1)*B(P6)*D(P1,P6) +
     .        B(P6)*B(P5)*D(P6,P5)
      PROP4 = B(P3)*B(P6)*D(P3,P6)
      PROP5 = B(P1)*B(P5)*D(P1,P5) +
     .        B(P1)*B(P3)*D(P1,P3) +
     .        B(P3)*B(P5)*D(P3,P5) + 2.D0*ME2
      PROP6 = B(P2)*B(P6)*D(P2,P6)
      PROP7 = B(P4)*B(P6)*D(P4,P6)
C
      IF (IND.EQ.1) AMPLIM = AMPLIM*ZN5*ZN6/PROP1/PROP2/PROP3
      IF (IND.EQ.2) AMPLIM = AMPLIM*ZN5*ZN6/PROP1/PROP2/PROP4*(-1.D0)
      IF (IND.EQ.3) AMPLIM = AMPLIM*ZN5*ZN6/PROP2/PROP5/PROP6*(-1.D0)
      IF (IND.EQ.4) AMPLIM = AMPLIM*ZN5*ZN6/PROP2/PROP5/PROP7
C
      RETURN
      END

CDECK  ID>, SPININ. 

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C    COMPUTATION OF THE BASIC QUANTITIES
C    NEEDED FOR THE HELICITY AMPLITUDES EVALUATION
C      INPUT   ==> VECTORS P1,P2,P3,P4,P5,P6    ( COMMON /MOMENZ/ )
C          FORMAT: (PX,PY,PZ,E,M)
C      OUTPUT  ==> BASIC QUANTITIES SP,SM,U,E,D ( COMMON /PRODUX/ )
C                  ( SP --> S+  / SM --> S- )
C
C                              C.MANA & M.MARTINEZ   DESY-86
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE SPININ(INF)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      COMPLEX*16 SP,SM
      COMMON / MOMENZ / P1,P2,P3,P4,P5,P6
      COMMON / PRODUX / SP,SM,U,E,D
      DIMENSION P1(5),P2(5),P3(5),P4(5),P5(5),P6(5)
      DIMENSION Q(5,6),SP(6,6),SM(6,6),D(6,6)
      DIMENSION E(6),U(6)
      EQUIVALENCE ( P1(1) , Q(1,1) )
C
      DO 1 I=1,6
      U(I) = DSQRT( 2.*( Q(4,I) - Q(1,I) )  )
      E(I) = Q(5,I)/U(I)
    1 CONTINUE
      DO 2 I=1,6
      DO 2 J=I,6
      SP(I,J)= DCMPLX( Q(2,I) , Q(3,I) ) * U(J)/U(I)
     .        -DCMPLX( Q(2,J) , Q(3,J) ) * U(I)/U(J)
      SP(J,I)=-SP(I,J)
      SM(I,J)=-DCONJG( SP(I,J) )
      SM(J,I)=-SM(I,J)
      D(I,J) = SP(I,J)*SM(J,I) + (E(I)*U(J))**2 + (E(J)*U(I))**2
      D(J,I) = D(I,J)
    2 CONTINUE
C
      IF(INF.LT.1) RETURN
      WRITE(6,100)
  100 FORMAT(' ',40(1H-),' SPININ INF  ',40(1H-))
      WRITE(6,101) (P1(I),P2(I),P3(I),P4(I),P5(I),P6(I),I=1,5)
  101 FORMAT('0INPUT (PX ,PY ,PZ ,E ,M ) ',/,(6G15.6))
      WRITE(6,102) (U(I),E(I),I=1,6)
  102 FORMAT('0VECTORS U(I) AND E(I)',/,(2G15.6))
      WRITE(6,104) ((SP(I,J),J=1,6),I=1,6)
  104 FORMAT('0MATRIX SP(I,J)',/,(6('  ',2G10.3)))
      WRITE(6,105) ((SM(I,J),J=1,6),I=1,6)
  105 FORMAT('0MATRIX SM(I,J)',/,(6('  ',2G10.3)))
      WRITE(6,107) ((D(I,J),J=1,6),I=1,6)
  107 FORMAT('0MATRIX D(I,J)',/,(6('  ',G15.6)))
      RETURN
      END

CDECK  ID>, ZMART.  

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C    CALCULATION OF ALL THE Z FUNCTIONS FOR GAMMA EXCHANGE
C
C                               C.MANA & M.MARTINEZ   DESY-86
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      FUNCTION ZMART(P1,L1,P2,L2,P3,L3,P4,L4)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      COMPLEX*16 ZMART,SP,SM
      INTEGER P1,P2,P3,P4,P5,P6
      DIMENSION SP(6,6),SM(6,6),D(6,6),E(6),U(6)
      COMMON / PRODUX / SP,SM,U,E,D
      LZ=9-4*L1-2*L2-L3-(L4+1)/2
      GOTO(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16),LZ
    1 ZMART= -2.D0*( SP(P1,P3)*SM(P2,P4)
     .        - U(P1)*U(P2)*E(P3)*E(P4)
     .        - U(P3)*U(P4)*E(P1)*E(P2) )
      GOTO 17
    2 ZMART= -2.D0*U(P2)*(    SP(P1,P3)*E(P4)
     .                 - SP(P1,P4)*E(P3) )
      GOTO 17
    3 ZMART= -2.D0*U(P1)*(    SM(P2,P3)*E(P4)
     .                 - SM(P2,P4)*E(P3) )
      GOTO 17
    4 ZMART= -2.D0*( SP(P1,P4)*SM(P2,P3)
     .        - U(P1)*U(P2)*E(P3)*E(P4)
     .        - U(P3)*U(P4)*E(P1)*E(P2) )
      GOTO 17
    5 ZMART= -2.D0*U(P4)*(    SP(P3,P1)*E(P2)
     .                 - SP(P3,P2)*E(P1) )
      GOTO 17
    6 ZMART=(0.D0,0.D0)
      GOTO 17
    7 ZMART=  2.D0*( E(P2)*U(P1) - E(P1)*U(P2) )
     .       *( E(P4)*U(P3) - E(P3)*U(P4) )
      GOTO 17
    8 ZMART=  2.D0*U(P3)*(    SP(P1,P4)*E(P2)
     .                 - SP(P2,P4)*E(P1) )
      GOTO 17
    9 ZMART=  2.D0*U(P3)*(    SM(P1,P4)*E(P2)
     .                 - SM(P2,P4)*E(P1) )
      GOTO 17
   10 ZMART=  2.D0*( E(P2)*U(P1) - E(P1)*U(P2) )
     .       *( E(P4)*U(P3) - E(P3)*U(P4) )
      GOTO 17
   11 ZMART=(0.D0,0.D0)
      GOTO 17
   12 ZMART=  2.D0*U(P4)*(    SM(P1,P3)*E(P2)
     .                 - SM(P2,P3)*E(P1) )
      GOTO 17
   13 ZMART= -2.D0*( SP(P2,P3)*SM(P1,P4)
     .        - U(P1)*U(P2)*E(P3)*E(P4)
     .        - U(P3)*U(P4)*E(P1)*E(P2) )
      GOTO 17
   14 ZMART= -2.D0*U(P1)*(    SP(P2,P3)*E(P4)
     .                 - SP(P2,P4)*E(P3) )
      GOTO 17
   15 ZMART= -2.D0*U(P2)*(    SM(P1,P3)*E(P4)
     .                 - SM(P1,P4)*E(P3) )
      GOTO 17
   16 ZMART= -2.D0*( SP(P2,P4)*SM(P1,P3)
     .        - U(P1)*U(P2)*E(P3)*E(P4)
     .        - U(P3)*U(P4)*E(P1)*E(P2) )
   17 CONTINUE
      RETURN
      END

C End of non-APOLLO specific code

************************************************************************
CDECK  ID>, TEGOPL. 
************************************************************************

CDECK  ID>, USINIT. 
*.
*...USINIT   GOPAL interface for TEEGG  - initialization
*.
*. SEQUENCE  : TEGCOM TEGCMX GCLUND GTFLAG GCFLAG RCREP
*. CALLS     : TEEGGI TEEGGX TEEGGL
*. CALLED    : UGINIT
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 1.0
*. CREATED   : 28-Sep-88
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*.
*.**********************************************************************
      SUBROUTINE USINIT

      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


      INTEGER NEV,NXTPAR
      REAL XTRATM
      COMMON/TEGCMX/NEV,NXTPAR,XTRATM
      CHARACTER*70 TITLE
      COMMON/TEGCMT/TITLE

C NEV    = Number of events to be generated.
C NXTPAR = Next set of parameters to be used. (for stand alone)
C XTRATM = extra time reqd. for ending run in secs. (for stand alone)
C TITLE  = event sample descriptor (for stand alone)

************************************************************************
      COMMON/GCLUND/IFLUND,ECLUND
      INTEGER IFLUND
      REAL ECLUND
C
      INTEGER       IDEBUG,IDEMIN,IDEMAX,ITEST,IDRUN,IDEVT,IEORUN
     +        ,IEOTRI,IEVENT,ISWIT,IFINIT,NEVENT,NRNDM
C
      COMMON/GCFLAG/IDEBUG,IDEMIN,IDEMAX,ITEST,IDRUN,IDEVT,IEORUN
     +        ,IEOTRI,IEVENT,ISWIT(10),IFINIT(20),NEVENT,NRNDM(2)
      COMMON/GCFLAX/BATCH, NOLOG
      LOGICAL BATCH, NOLOG
C
      CHARACTER*132 CHREP
      COMMON/RCREP/CHREP

      LOGICAL TEEGGL
      EXTERNAL TEEGGL

C Set default parameters
      CALL TEEGGI

C Let user set parameters
      CALL TEEGGX

C Check that the parameters are valid (if errors print on unit 6)
      IF(.NOT.TEEGGL(6))THEN
         CHREP='Invalid set of parameters (TEEGG). See output file for'
     >         //' further information.'
*         CALL REPORT('USINIT',1,'CRASH')
         WRITE(6,*)'CRASH at line 5006 of USINIT'
         STOP
      ENDIF

C Set the beam energy, number of events and random number seed
C for the GOPAL scheme.
      ECLUND=2.*EB
      NEVENT=NEV
      NRNDM(1)=ISEED

C Successful return
      RETURN
      END

CDECK  ID>, KIUSER. 
*.
*...KIUSER   GOPAL interface for TEEGG - event generation
*.
*.
*. SEQUENCE  : TEGCOM GTFLAG GCFLAG
*. CALLS     : TEEGG7 LPASS FILLOP
*. CALLED    : GUKINE
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 1.0
*. CREATED   : 28-Sep-88
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*.
*.**********************************************************************
      SUBROUTINE KIUSER

      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far

      INTEGER       IDEBUG,IDEMIN,IDEMAX,ITEST,IDRUN,IDEVT,IEORUN
     +        ,IEOTRI,IEVENT,ISWIT,IFINIT,NEVENT,NRNDM
C
      COMMON/GCFLAG/IDEBUG,IDEMIN,IDEMAX,ITEST,IDRUN,IDEVT,IEORUN
     +        ,IEOTRI,IEVENT,ISWIT(10),IFINIT(20),NEVENT,NRNDM(2)
      COMMON/GCFLAX/BATCH, NOLOG
      LOGICAL BATCH, NOLOG
C

      LOGICAL LPASS
      EXTERNAL LPASS

 1    CONTINUE
      NRNDM(1)=NXSEED
      CALL TEEGG7
      IF(.NOT.LPASS(0))GOTO 1

C Fill in the OPAL commons

      CALL FILLOP(P,EB,M)

      RETURN
      END

CDECK  ID>, FILLOP. 
*.
*...FILLOP   fills the LUJET common with 4-momenta from TEEGG
*.
*. INPUT     : PVEC   4-momenta for the final state electrons/photons
*. INPUT     : EB     electron/positron beam energy
*. INPUT     : M      electron mass
*.
*. SEQUENCE  : LUJETS
*. CALLS     : GOLINT GOLIFE
*. CALLED    : KIUSER
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 1.0
*. CREATED   : 28-Sep-88
*. LAST MOD  : 01-May-89
*.
*. Modification Log.
*. 01-May-89  Dean Karlen  Change the initial electron direction to +z
*.
*.**********************************************************************

      SUBROUTINE FILLOP(PVEC,EB,M)

      IMPLICIT NONE

      COMMON/LUJETS/N,K(4000,5),P(4000,5),V(4000,5)
      INTEGER N,K
      REAL P,V
      SAVE /LUJETS/
*

      DOUBLE PRECISION PVEC(4,4),EB,M
      INTEGER  ELCTRN,PHOTON,I,J
      PARAMETER  (ELCTRN=7,PHOTON=1)

      N = 5
      IF (PVEC(4,4).NE.0.) N = 6

C Set four momenta

      P(1,1)=0.
      P(1,2)=0.
      P(1,3)=SQRT(EB**2-M**2)
      P(1,4)=EB
      P(2,1)=0.
      P(2,2)=0.
      P(2,3)=-SQRT(EB**2-M**2)
      P(2,4)=EB
      DO 2 J=1,4
         DO 1 I=1,4
            P(J+2,I) = PVEC(I,J)
 1       CONTINUE
 2    CONTINUE

C Set masses

      DO 3 I=1,4
         P(I,5) = M
 3    CONTINUE
      P(5,5)=0.
      P(6,5)=0.

C Status and history:

      K(1,1) = 40000
      K(2,1) = 40000
      K(3,1) = 20001
      K(4,1) = 20002
      K(5,1) = 20001
      K(6,1) = 20001

C Particle ID

      K (1,2) =   ELCTRN
      K (2,2) = - ELCTRN
      K (3,2) =   ELCTRN
      K (4,2) = - ELCTRN
      K (5,2) =   PHOTON
      K (6,2) =   PHOTON

      write(6,*)'Turned off GOLINT and GOLIFE'

*      CALL GOLINT
*      CALL GOLIFE

      RETURN
      END

CDECK  ID>, USOUT.  
      SUBROUTINE USOUT
      RETURN
      END

CDECK  ID>, USLAST. 
*.
*...USLAST   GOPAL interface for TEEGG - print routine
*.
*. CALLS     : TEEGGC TEEGGP
*. CALLED    : UGLAST
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 1.0
*. CREATED   : 28-Sep-88
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*.
*.**********************************************************************
      SUBROUTINE USLAST
      CALL TEEGGC
      CALL TEEGGP(6)
      RETURN
      END

CDECK  ID>, LPASS.  
      LOGICAL FUNCTION LPASS(DUMMY)
      LPASS=.TRUE.
      RETURN
      END

************************************************************************
CDECK  ID>, TEGSTD. 
************************************************************************

*.**********************************************************************
*.                                                                     *
*. Main program for the TEEGG generator (stand alone)                  *
*.                                                                     *
*.**********************************************************************

CDECK  ID>, TEEGGM. 
*.
*...TEEGGM   Main program for the stand alone running of TEEGG.
*.
*.  TEEGG can be run in stand alone mode by using the TEEGG EXEC
*.  (or TEEGG.COM on Vax) and supplying the subroutine TEEGGX.
*.  The same subroutine can be used for GOPAL running to generate
*.  the same events.
*.
*. SEQUENCE  : TEGCMX
*. CALLS     : TEEGGI TEEGGX TEEGGL TEEGG7 LPASS USOUT TEEGGP
*. CALLS     : TIMEX USLAST
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 1.1
*. CREATED   : 28-Sep-88
*. LAST MOD  : 01-May-89
*.
*. Modification Log.
*. 01-May-89   Dean Karlen  Stop multiple configurations if NXTPAR < 0
*.
*.**********************************************************************

      PROGRAM TEEGGM

      IMPLICIT NONE

      INTEGER PLUN
      PARAMETER (PLUN=7)

      INTEGER I,PARNUM,NSET
      REAL TIMLFT,TIMUSD

      EXTERNAL TEEGGL,LPASS
      LOGICAL  TEEGGL,LPASS


      INTEGER NEV,NXTPAR
      REAL XTRATM
      COMMON/TEGCMX/NEV,NXTPAR,XTRATM
      CHARACTER*70 TITLE
      COMMON/TEGCMT/TITLE

C NEV    = Number of events to be generated.
C NXTPAR = Next set of parameters to be used. (for stand alone)
C XTRATM = extra time reqd. for ending run in secs. (for stand alone)
C TITLE  = event sample descriptor (for stand alone)

************************************************************************

C Set defaults for TEEGG
      CALL TEEGGI

C Initialize any other parameters

C.....NEV =  number of events requested
      NEV =  100

C.....NXTPAR = next set of parameters to use (for multi run stand alone)
      NXTPAR = 1

C.....XTRATM = extra CPU secs. required to end an event (stand alone)
      XTRATM = 2.

C.....TITLE = comment for this set of parameters
      TITLE = ' '

C Set a time limit for interactive running
      CALL TIMEST(100.)
      NSET=0

C Remember what the parameter number is for the next run.
 1    PARNUM = NXTPAR
      NSET=NSET+1

C Reset timer
      CALL TIMED(TIMUSD)

C Let the user set any parameters
      CALL TEEGGX

C Write out the title for the run
      WRITE(PLUN,'(''1'')')
      WRITE(PLUN,*)'Title: ',TITLE
      WRITE(PLUN,*)' '

C Check that the parameters are valid.
      IF(TEEGGL(PLUN))THEN

C Here is the Main loop.
C ---------------------

         DO 2 I=1,NEV

C Call the generating routine. (Generates one event).
 3          CALL TEEGG7
            IF(.NOT.LPASS(0))GOTO 3

C Call the user supplied event analysis routine.
            CALL USOUT
            
            CALL EVWRITE

C Check the time
            CALL TIMEL(TIMLFT)
            IF(TIMLFT.LT.XTRATM)THEN
               WRITE(PLUN,100)
 100           FORMAT(' **** Time ran out **** ')
               GOTO 4
            ENDIF

 2       CONTINUE

C Call the user supplied print routine (onto unit 6)
 4       CALL USLAST

C Write out stats to the PLUN unit

         CALL TEEGGC
         CALL TEEGGP(PLUN)

C Print out the CPU time used in this generation
         CALL TIMED(TIMUSD)
         WRITE(PLUN,101)TIMUSD
 101     FORMAT(' ',/,' CPU time used : ',F7.2,' seconds')

      ENDIF

C All done for this set of parameters. If another set of parameters
C should be called, start over.

      IF(NXTPAR.NE.PARNUM .AND. NXTPAR.GT.0)GOTO 1

C Write out total time used if more than one set of parameters used:

      IF(NSET.GT.1)THEN
         CALL TIMEX(TIMUSD)
         WRITE(PLUN,102)TIMUSD
 102     FORMAT(' ',/,/,' TOTAL CPU time used : ',F7.2,' seconds')
      ENDIF

      STOP
      END

************************************************************************
CDECK  ID>, TEGRND. 
************************************************************************
CDECK  ID>, RNDGEN. 
*.
*...RNDGEN   random number generator interface for TEEGG
*.
*. INPUT     : N      number of random number to fill in RND array
*.
*. SEQUENCE  : TEGCOM
*. CALLS     : ATRAN7 ITRAN7 TRAN7A
*. CALLED    : T3BODY T4BODY TEEGGX
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C Random number routine: put N random numbers in common RND

      SUBROUTINE RNDGEN(N)

      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


      INTEGER IR,N,NR,JSEED

      NR=MIN(NRNDMX,N)
      SEED=NXSEED

C Fill array RND with NR random numbers.
      CALL ATRAN7(RND(1),NR)
C Find the seed that continues the sequence.
      CALL ITRAN7(IR,1)
      NXSEED=IR

      RETURN

      ENTRY RNDIN(JSEED)
C TRAN7 requires a positive seed to work properly.
      CALL TRAN7A(ABS(JSEED))
      NXSEED=JSEED

      RETURN
      END

CDECK  ID>, ATRAN7. 
*.
*...ATRAN7   interface to RAND routine.
*.
*. INPUT     : NUM    number of elements in ARRAY to fill
*. OUTPUT    : ARRAY  array filled with random numbers
*.
*. CALLS     : RAND
*. CALLED    : RNDGEN
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C Interface to RAND routine
C
      SUBROUTINE ATRAN7(ARRAY,NUM)
      REAL ARRAY(1)
      INTEGER IARRAY(1)

      DO 1 I=1,NUM
 1    ARRAY(I)=RAND(IX)
      RETURN

      ENTRY ITRAN7(IARRAY,NUM)
      DO 2 I=1,NUM
      DUM=RAND(IX)
 2    IARRAY(I)=IX
      RETURN

      ENTRY TRAN7A(IY)
      IX=IY
      RETURN
      END

CDECK  ID>, RAND.   
*.
*...RAND     the RAN7 random number generator
*.
*. INPUT     : IX     seed
*.
*. CALLED    : ATRAN7
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 29-Jun-87
*.
*. Modification Log.
*.
*.**********************************************************************

C-----------------------------------------------------------------------
C This is the code for the RAN7 random number generator:
C
C Reference : P.A.W. Lewis, A.S. Goodman, and J.M. Miller,
C             "Pseudo-Random Number Generator for the System/360",
C             IBM Syst. J. 8,2 (1969) 136-146
C
                  FUNCTION RAND(IX)
C PORTABLE RANDOM NUMBER GENERATOR USING MULTIPLICATIVE
C CONGRUENTIAL METHOD, MULTIPLIER=16807, MODULUS=2**31-1.
C NOTE - IX MUST NOT BE CHANGED BETWEEN CALLS.
C
C SOME COMPILERS, E.G. THE HP3000, REQUIRE THE FOLLOWING
C DECLARATION TO BE INTEGER*4
      INTEGER A,P,IX,B15,B16,XHI,XALO,LEFTLO,FHI,K
C
C CONSTANTS   7**5,     2**15,     2**16,      2**31-1
      DATA A/16807/,B15/32768/,B16/65536/,P/2147483647/
C
C GET 15 HIGH-ORDER BITS OF IX
      XHI = IX / B16
C GET 16 LOW-ORDER BITS OF IX AND FORM LOW-ORDER PRODUCT
      XALO = (IX - XHI * B16) * A
C GET 15 HIGH-ORDER BITS OF LOW-ORDER PRODUCT
      LEFTLO = XALO / B16
C FORM THE 31 HIGHEST BITS OF THE FULL PRODUCT
      FHI = XHI * A + LEFTLO
C GET OVERFLOW PAST 31-ST BIT OF FULL PRODUCT
      K = FHI / B15
C ASSEMBLE ALL PARTS, PRESUBTRACT P (THE PARENS ARE ESSENTIAL)
      IX = (((XALO-LEFTLO*B16)-P) + (FHI-K*B15) * B16) + K
C ADD P BACK IN IF NECESSARY
      IF (IX .LT. 0) IX = IX + P
C MULTIPLY BY 1/(2**31-1)
      RAND = FLOAT(IX) * 4.656612875E-10
      RETURN
      END

************************************************************************
CDECK  ID>, TEGEXM. 
************************************************************************

CDECK  ID>, TEEGGX. 
*.
*...TEEGGX   example control subroutine for TEEGG
*.
*.           To use this in stand alone mode, copy the patch to
*.           fname CARDS, name the patch TEGX, and to execute:
*.             on IBM:  TEEGG fname
*.             on Vax:  @[OPAL.GENERATOR]TEEGG
*.           The same control subroutine can be used for event
*.           generation, just include it with the GOPAL job.
*.
*. SEQUENCE  : TEGCOM TEGCMX
*. CALLS     : RNDGEN
*. CALLED    : USINIT TEEGGM
*.
*. AUTHOR    : Dean Karlen
*. VERSION   : 7.1
*. CREATED   : 29-Jun-87
*. LAST MOD  : 28-Sep-88
*.
*. Modification Log.
*. 28-Sep-88   Dean Karlen   Change to conform to OPAL standards.
*.
*.**********************************************************************

C -------------------------TEEGG CONTROL FILE---------------------------
C This file controls the execution of TEEGG:
C  - Change any parameters as desired. (see patch TEGTEX)
C  - Set a comment title in TITLE.
C  - To do more than one configuration in a stand alone job, use NXTPAR
C  - To re-initialize the random number generator with seed in ISEED,
C    CALL RNDIN(ISEED).
C-----------------------------------------------------------------------

      SUBROUTINE TEEGGXP

      IMPLICIT NONE


C Version 7.2 - Common/Include file.

C Fundamental constants
      DOUBLE PRECISION ALPHA,ALPHA3,ALPHA4,M,PBARN,PI,TWOPI

      PARAMETER
     >(          ALPHA = 1.D0/137.036D0, ALPHA3=ALPHA**3,ALPHA4=ALPHA**4
     >,          M     = 0.5110034 D-3
     >,          PBARN = .389386 D9
     >,          PI    = 3.14159265358979 D0 , TWOPI=2.0D0*PI
     >)

C M     mass of the electron in GeV
C PBARN conversion of GeV-2 to pb

C Other constants

      INTEGER   HARD,SOFT,NONE    , EGAMMA,GAMMA,ETRON,GAMMAE
     >,         BK,BKM2,TCHAN,EPA , EPADC,BEEGG,MEEGG,HEEGG
      PARAMETER
     >(          HARD  = 1 , EGAMMA = 11 , BK    = 21 , EPADC = 31
     >,          SOFT  = 2 , ETRON  = 12 , BKM2  = 22 , BEEGG = 32
     >,          NONE  = 3 , GAMMA  = 13 , TCHAN = 23 , MEEGG = 33
     >,                      GAMMAE = 14 , EPA   = 24 , HEEGG = 34
     >)

C HARD generate e+ e- gamma gamma
C SOFT generate e+ e- gamma with soft and virt corrections
C NONE generate e+ e- gamma according to lowest order only
C EGAMMA e-gamma configuration
C ETRON  single electron configuration
C GAMMA  single gamma configuration
C GAMMAE single gamma configuration (modified for low Ee 4th order only)
C BK    Berends and Kleiss matrix element
C BKM2  Berends and Kleiss matrix element with m**2/t term
C TCHAN t channel matrix element only (two diagrams)
C EPA   equivalent photon approximation matrix element (for testing)
C EPADC EPA matrix element with double Compton (for RADCOR=HARD only)
C BEEGG Berends et al. e-e-gamma-gamma m.e.    (for RADCOR=HARD only)
C MEEGG Martinez/Miquel e-e-gamma-gamma m.e.   (for RADCOR=HARD only)
C HEEGG Hybrid of EPADC and BEEGG              (for RADCOR=HARD only)

C Input parameters common:

      DOUBLE PRECISION EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,                PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,                WGHT1M,WGHTMX, FRAPHI,EPSPHI
      INTEGER          ISEED, RADCOR,CONFIG,MATRIX,MTRXGG
      LOGICAL          UNWGHT

      COMMON/TINPAR/EB,TEVETO,TEMIN,TGMIN,TGVETO,EEMIN,EGMIN
     >,             PEGMIN,EEVETO,EGVETO,PHVETO,CUTOFF,EPS
     >,             WGHT1M,WGHTMX, FRAPHI,EPSPHI
     >,             ISEED, RADCOR,CONFIG,MATRIX,MTRXGG, UNWGHT

C EB     = energy of electron beam in GeV
C TEVETO = maximum theta of e+ in final state (in radians)
C TEMIN  = minimum angle between the e- and -z axis (egamma conf. only)
C TGMIN  = minimum angle between the gamma and -z axis
C TGVETO = maximum angle between the gamma and -z axis(etron conf. only)
C EEMIN  = minimum energy of the e- (egamma & etron configurations)
C EGMIN  = minimum energy of the gamma (egamma & gamma configurations)
C PEGMIN = minimum phi sep of e-gamma (egamma config with hard rad corr)
C EEVETO = minimum energy to veto(gamma  config with hard rad corr)
C EGVETO = minimum energy to veto(etron/gamma config with hard rad corr)
C PHVETO = minimum phi sep to veto(etron/gamma config with hard rad corr
C CUTOFF = cutoff energy for radiative corrections (in CM frame)
C EPS    = param. epsilon_s (smaller val. increases sampling of k_s^pbc)
C FRAPHI = fraction of time phi_ks is generated with peak(hard rad corr)
C EPSPHI = param. epsilon_phi ('cutoff' of the phi_ks peak)
C WGHT1M = maximum weight for generation of QP0, cos(theta QP)
C WGHTMX = maximum weight for the trial events
C ISEED  = initial seed
C RADCOR = specifies radiative correction (NONE SOFT or HARD)
C CONFIG = specifies the event configuration (EGAMMA GAMMA or ETRON)
C MATRIX = specifies which eeg matrix element (BK BKM2 TCHAN or EPA)
C MTRXGG = specifies which eegg matrix element (EPADC BEEGG or MEEGG)
C UNWGHT = logical variable. If true then generate unweighted events.

C Variable array sizes

      INTEGER    NRNDMX
      PARAMETER (NRNDMX=20)

C NRNDMX maximum number of random numbers that may be generated at once.

C Common for random number generator

      REAL        RND(NRNDMX)
      INTEGER         SEED,NXSEED,BSEED
      COMMON/TRND/RND,SEED,NXSEED,BSEED

C RND    = random numbers used for an event.
C SEED   = seed that generates the sequence of random numbers coming up.
C NXSEED = next seed that should be used if the sequence is to continue.
C BSEED  = beginning seed (same as ISEED except for multiple runs)

C Derived constants common

      DOUBLE PRECISION
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC
      COMMON/TCONST/
     >       S,SQRTS,EBP,EPSLON,CDELT,CDELT1,CTGVT1,ACTEM,ACTK
     >,      FQPMAX,QP0MIN,ZMAX,LOGZ0M,LOGRSM,FACT3,FACT7,CTGM1M,ASOFTC

C Calculated event quantities.

      DOUBLE PRECISION P(16),RSIGN
      COMMON/TEVENT/P,RSIGN
      DOUBLE PRECISION T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF
      COMMON/TEVQUA/T,TP,SP,U,UP,X1,X2,Y1,Y2,DSIGE,WGHT,WGHTSF

C P(16) = 4 four-vectors. (e+ e- gamma1 gamma2) (px,py,pz,E)
C RSIGN = indicates the charge that of the 'missing electron'.
C S,SP,T,TP,U,UP,X1,X2,Y1,Y2 = Berends/Kliess invariant products.
C DSIGE = calculated differential cross section
C WGHT  = weight (dsige/dsiga)
C WGHTSF= weight (1+delta)

C Event summary quantities

      DOUBLE PRECISION EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,                SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
      INTEGER       NTRIAL,NPASSQ,NACC
      COMMON/TSMMRY/EFFIC,SIGE,ERSIGE,W1MAX,WMAX,WMINSF,Q2W2MX
     >,             SUMW1,SUMW12,SUMWGT,SUMW2,CONVER
     >,             NTRIAL,NPASSQ,NACC

C EFFIC = efficiency of event generation = NACC/NTRIAL
C SIGE  = total cross section (pb)
C ERSIGE= error in the total cross section
C W1MAX = maximum observed weight for q+0 and cos(0q+) generation
C WMAX  = maximum event weight observed
C WMINSF= minimum soft correction weight observed
C Q2W2MX= maximum ratio of Q**2 to W**2  observed
C SUMW1 = sum of all weights of QP generation
C SUMW12= sum of all (weights of QP generation)**2
C SUMWGT= sum of all weights
C SUMW2 = sum of all (weights)**2
C CONVER= conversion factor of SUMWGT to (pb)
C NTRIAL= number of trials so far
C NPASSQ= number of times qp accepted
C NACC  = number of accepted events so far


      INTEGER NEV,NXTPAR
      REAL XTRATM
      COMMON/TEGCMX/NEV,NXTPAR,XTRATM
      CHARACTER*70 TITLE
      COMMON/TEGCMT/TITLE

C NEV    = Number of events to be generated.
C NXTPAR = Next set of parameters to be used. (for stand alone)
C XTRATM = extra time reqd. for ending run in secs. (for stand alone)
C TITLE  = event sample descriptor (for stand alone)

************************************************************************

C Decide which parameter set to use. (To `comment' one set out
C simply comment out the RETURN statement... the next set will
C be run.)

      GOTO (10,20,30),NXTPAR

 10   ISEED= 123454321
      CALL RNDIN(ISEED)
      XTRATM=5.

C-----------------------------
C A test e-gamma configuration
C-----------------------------

      RADCOR=NONE

      CONFIG=EGAMMA
      EB=49.
      TEVETO=30.D-3
      TGMIN= 15. * PI/180.
      TEMIN= 15. * PI/180.
      EGMIN=5.0D0
      EEMIN=5.0D0

      NEV=100
      WGHTMX=0.5
      TITLE=' A test of lowest order e-gamma configuration'
      NXTPAR=2
      RETURN

 20   NEV=50
      CUTOFF=0.01D0
      RADCOR=SOFT
      TITLE=' A test of e-gamma configuration with soft corr.'
      NXTPAR=3
      RETURN

 30   NEV=10
      WGHTMX=2.D0
      RADCOR=HARD
      TITLE=' A test of e-gamma configuration - (e-e-g-g)'
      RETURN

      END
      
      include 'teeggx.f'
      include 'evwrite.f'
