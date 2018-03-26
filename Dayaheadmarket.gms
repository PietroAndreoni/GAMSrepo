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

alias(z,k);

set    s(z,i) subject paired with respective zone of injection or drawning   ;

$call "GDXXRW.EXE i=Egmarketinput.xlsx o=data_egmkt.gdx set=s rng=MKTpartecipants!A2:A17 rdim=0 values=yn"
$GDXIN data_egmkt.gdx
$LOAD s
$GDXIN

set sup(s)

parameter nbid "different couple of (q,p) in the bid - max 4"     /1*4/
          cstr "if put equal to zero the model calculate network unconstrained equilibrium" /1/

parameters    pBID (s,nbid)  bidded prices for every partecipant in the market
              qBID (s,nbid)  bidded quantities for every partecipant in the market
              c(z,k)         "Network constraints between zones - FROM z TO k"   ;

$call "GDXXRW.EXE i=Egmarketinput.xlsx o=data_egmkt1.gdx par=pBID rng=BIDprice!A2:E17 rdim=1 cdim=1 values=yn par=qBID rng=BIDquantity!A2:E17 rdim=1 cdim=1 values=yn par=c rng=distance!A2:G8 rdim=1 cdim=1 values=yn"
$GDXIN data_egmkt.gdx
$LOAD pBID, qBID, c
$GDXIN

variables
          f(z,k)   "flows between zones - FROM z TO k - positive if exporting"
          p(z)  price in each zone
          qdem(z)  quantity demanded in each zone
          qsup(z)  quantity supplied in each zone
          qc(s) obligation in quantity for every partecipant in the market
          SUR     total surplus

equations
                DEMAND(z)
                SUPPLY(z)
                EQUILIBRIUM(z)
                GLOBALEQ
                SURPLUS
                TRASMCONSTR(z,k)
                QTYCONSTR(s);

DEMAND(z)..                p(z)                   =g=     sum(s,k,nbid, pBID(s,nbid) $ ( (qBID(s,nbid) GR 0)  AND (qBID(s,nbid) EQ (qsup(z) - f(z,k) $ (z NE k))) )
SUPPLY(z)..                p(z)                   =l=     sum(s,k,nbid, pBID(s,nbid) $ ( (qBID(s,nbid) LO 0)  AND (qBID(s,nbid) EQ (qdem(z) - f(z,k) $ (z NE k))) )
EQUILIBRIUM(z)..           qdem(z)                =e=     qsup(z) - sum(k, f(z,k) $ (z NE k))
GLOBALEQ..                 sum(z,qdem(z))         =e=     sum(z,qsup(z))
TRASMCONSTR..              f(z,k) $ (cstr EQ 1)   =l=     c(z,k)
QTYCONSTR..                qc(s)                  =l=     sum(nbid,qBID(s,nbid))