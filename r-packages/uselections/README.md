Overview
--------

The uselections package provides functionality for loading information about voter registration and election results in the
United States.  The initial goal is to provide data on registration in states that allow party affiliation as close to the
time of the 2016 general election as data are available, as well as 2016 presidential election results. We will iterate on this
initial goal to include historical data and also data from states that do not support party affiliation.

Installation
------------

We do not have immediate plans to push the package to CRAN, so you need to install directly from GitHub.  Note that this
will install all dependencies as well.  These dependencies include the rgeos package, which can be a little tricky to
install on some platforms.

``` r
# install.packages("devtools")
devtools::install_github("Data4Democracy/election-transparency/r-packages/uselections")
```

Usage - Party Registration Dataset
-----

To access the PartyRegistration data frame that is exposed by the package:

```
> uselections::PartyRegistration
# A tibble: 1,306 × 22
   State County  Year Month     D     G     L      N     O     R  Total      dPct      rPct     leanD     leanR unaffiliatedPct   otherPct
   <chr>  <chr> <dbl> <dbl> <int> <int> <int>  <int> <int> <int>  <dbl>     <dbl>     <dbl>     <dbl>     <dbl>           <dbl>      <dbl>
1     02  02013  2016    11   152     0    12   1071    43   211   1489 0.1020819 0.1417058 0.7203791 1.3881579       0.7192747 0.02887844
2     02  02016  2016    11   577     7    21   1387   101   448   2541 0.2270760 0.1763085 1.2879464 0.7764298       0.5458481 0.03974813
3     02  02020  2016    11 35841   601  4283 111946  6787 57352 216810 0.1653106 0.2645265 0.6249303 1.6001786       0.5163323 0.03130391
4     02  02050  2016    11  2573    30    70   5851   534  1164  10222 0.2517120 0.1138720 2.2104811 0.4523902       0.5723929 0.05224027
5     02  02060  2016    11    96     2     6    501    26   192    823 0.1166464 0.2332928 0.5000000 2.0000000       0.6087485 0.03159174
6     02  02068  2016    11   303    22    14    919    77   453   1788 0.1694631 0.2533557 0.6688742 1.4950495       0.5139821 0.04306488
7     02  02070  2016    11   651    10    26   1862   162   408   3119 0.2087207 0.1308112 1.5955882 0.6267281       0.5969862 0.05193972
8     02  02090  2016    11  9744   244   708  37042  2390 20890  71018 0.1372047 0.2941508 0.4664433 2.1438834       0.5215861 0.03365344
9     02  02100  2016    11   447    29    16   1270    92   444   2298 0.1945170 0.1932115 1.0067568 0.9932886       0.5526545 0.04003481
10    02  02105  2016    11   845    23    25   1875   131   580   3479 0.2428859 0.1667146 1.4568966 0.6863905       0.5389480 0.03765450
# ... with 1,296 more rows, and 5 more variables: dDRPct <dbl>, rDRPct <dbl>, CountyName <chr>, StateName <chr>, StateAbbr <chr>
> 
```

For detailed documentation on the data frame:  `?uselections::PartyRegistration`.  In short:

* State = 2-character FIPS code for the state
* StateAbbr = 2-character abbreviation for the state
* StateName = Name of the state
* County = 2-character FIPS code for the county
* CountyName = Name of the county
* Year = Year of registration
* Month = Month of registration
* D = Voters registered as affiliated with Democractic Party
* G = Voters registered as affiliated with Green Party
* L = Voters registered as affiliated with Libertarian Party
* N = Voters registered as unaffiliated with a party
* O = Voters registered as affiliated with some party other than D, G, L, R
* R = Voters registered as affiliated with Republican Party
* Total = Total # of voters registered
* dPct = Percentage Democratic Party Registration (D/Total)
* rPct = Percentage Republican Party Registration (R/Total)
* otherPct = Percentage Other Party Registration (O/Total)
* unaffiliatedPct = Percentage Unaffiliated Registration (N/Total)
* dDRPct = Democratic Party Registration as percentage of Democratic plus Republican Registration (D/(D+R))
* rDRPct = Republican Party Registration as percentage of Democratic plus Republican Registration (R/(D+R))
* leanD = Lean Democractic ratio (D/R)
* leanR = Lean Republican ratio (R/D)

Usage - 2016 Results Dataset
-----

To access the PresidentialElectionResults2016 data frame that is exposed by the package:

```
> uselections::PresidentialElectionResults2016
# A tibble: 3,141 × 18
   County clinton trump johnson stein other totalvotes CountyName StateName StateAbbr       dPct      rPct      leanD      leanR    otherPct     dDRPct
    <chr>   <int> <int>   <int> <int> <int>      <int>      <chr>     <chr>     <chr>      <dbl>     <dbl>      <dbl>      <dbl>       <dbl>      <dbl>
1   01001    5936 18172     546   105   214      24973    Autauga   Alabama        AL 0.23769671 0.7276659 0.32665639  3.0613208 0.008569255 0.24622532
2   01003   18458 72883    2464   456   954      95215    Baldwin   Alabama        AL 0.19385601 0.7654571 0.25325522  3.9485860 0.010019430 0.20207793
3   01005    4871  5454      93    18    33      10469    Barbour   Alabama        AL 0.46527844 0.5209667 0.89310598  1.1196879 0.003152164 0.47176755
4   01007    1874  6738     124    17    66       8819       Bibb   Alabama        AL 0.21249575 0.7640322 0.27812407  3.5955176 0.007483842 0.21760334
5   01009    2156 22859     338    89   146      25588     Blount   Alabama        AL 0.08425825 0.8933484 0.09431734 10.6025046 0.005705800 0.08618829
6   01011    3530  1140      22    10     8       4710    Bullock   Alabama        AL 0.74946921 0.2420382 3.09649123  0.3229462 0.001698514 0.75588865
7   01013    3726  4901      65    13    27       8732     Butler   Alabama        AL 0.42670637 0.5612689 0.76025301  1.3153516 0.003092075 0.43189985
8   01015   13242 32865    1116   262   379      47864    Calhoun   Alabama        AL 0.27665887 0.6866330 0.40292104  2.4818758 0.007918268 0.28720151
9   01017    5784  7843     168    44    61      13900   Chambers   Alabama        AL 0.41611511 0.5642446 0.73747291  1.3559820 0.004388489 0.42445146
10  01019    1547  8953     147    26    60      10733   Cherokee   Alabama        AL 0.14413491 0.8341563 0.17279124  5.7873303 0.005590236 0.14733333
# ... with 3,131 more rows, and 2 more variables: rDRPct <dbl>, State <chr>
>
```

For detailed documentation on the data frame:  `?uselections::PresidentialElectionResults2016`.  In short:

* State = 2-character FIPS code for the state
* StateAbbr = 2-character abbreviation for the state
* StateName = Name of the state
* County = 2-character FIPS code for the county
* CountyName = Name of the county
* clinton = Votes for Hillary Clinton
* stein = Votes for Jill Stein
* johnson = Votes for Gary Johnson
* trump = Votes for Donald Trump
* other = Votes for other candidates
* totalvotes = Total ballots cast for president
* dPct = Percentage of total votes for Clinton (clinton/totalvotes)
* rPct = Percentage of total votes for Trump (trump/totalvotes)
* otherPct = Percentage Other votes (other/totalvotes)
* dDRPct = Clinton votes as percentage of Clinton plus Trump votes (clinton/(clinton+trump))
* rDRPct = Trump votes as percentage of Clinton plus Trump votes (trump/(clinton+trump))
* leanD = Lean Clinton ratio (clinton/trump)
* leanR = Lean Trump ratio (trump/clinton)

