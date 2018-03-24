$OnText
This model simulate day ahead market for electricity in a 4 zone market


$OffText

set z        zones of the market     /Northeast
                                      Northwest
                                      Center
                                      South
                                      Sicily
                                      Sardinia             /

    i        subjects in the market  /n1, n2, n3, n4, n5, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10   / ;

alias(z,k)

set    s(z,i) subject sorted by respective zone of injection or drawning   ;

$call "GDXXRW.EXE i=Egmarketinput.xlsx o=data_egmkt.gdx set=s rng=MKTpartecipants!A2:A17 rdim=0 values=yn"
$GDXIN data_egmkt.gdx
$LOAD s
$GDXIN

parameter nbid "different couple of (q,p) in the bid - max 4"     /1*4/    ;

parameters    pBID (c,nbid)  bidded prices for every partecipant in the market
              qBID (c,nbid)  bidded quantities for every partecipant in the market
              c(z,k)         Network constraints between zones    ;

$call "GDXXRW.EXE i=Egmarketinput.xlsx o=data_egmkt1.gdx par=pBID rng=BIDprice!A2:E17 rdim=1 cdim=1 values=yn par=qBID rng=BIDquantity!A2:E17 rdim=1 cdim=1 values=yn par=c rng=distance!A2:G8 rdim=1 cdim=1 values=yn"
$GDXIN data_egmkt.gdx
$LOAD pBID, qBID, c
$GDXIN

variables
          f(z,k)   flows between zones
          p(z)  price in each zone
          qdem(z)  quantity demanded in each zone
          qsup(z)  quantity supplied in each zone
          qc(s) obligation in quantity for every partecipant in the market
          SUR     total surplus

equations
                DEMAND(z)
                SUPPLY(z)
                EQUILIBRIUM(z)
                SURPLUS;

DEMAND(z)..                p(z)    =g=   sum()
SUPPLY(z)..                p(z)    =l=   sum()
EQUILIBRIUM..              qdem(z) =e=   qsup(z)