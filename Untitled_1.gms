$OnText
This model simulate day ahead market for electricity in a 4 zone market


$OffText

set z      zones of the market     /North-est
                                    North-west
                                    Center
                                    South
                                    Sicily
                                    Sardinia/

    c(z)   consumers
    p(z)   producers


parameters b(c,p)

table c(z,z)        / North-est North-west Center South Sicily Sardinia
         North-est        INF     2000      1000    0      0       0
         North-west       2000    INF       2000    0      0       0
         Center           1000    2000      INF    1500    0      1500
         South             0       0        1500   INF    2000     0
         Sicily            0       0         0     2000   INF     500
         Sardinia          0       0        1500    0     500     INF/ ;

variables p(z)  price in each zone and in every hour of day ahead
          q(z)  quantity traded in each zone and in every hour of day ahead
          S     total surplus
