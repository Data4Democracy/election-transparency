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

Electoral Votes Dataset
-----------------------

The package includes a data frame containing the number of electoral votes allocated to each state based on the 2010 census, applicable to
Presidential elections in 2012, 2016, and 2020.

```
> uselections::ElectoralVotes2010
# A tibble: 51 × 4
   State            StateName StateAbbr ElectoralVotes
   <chr>                <chr>     <chr>          <int>
1     01              Alabama        AL              9
2     02               Alaska        AK              3
3     04              Arizona        AZ             11
4     05             Arkansas        AR              6
5     06           California        CA             55
6     08             Colorado        CO              9
7     09          Connecticut        CT              7
8     10             Delaware        DE              3
9     11 District of Columbia        DC              3
10    12              Florida        FL             29
# ... with 41 more rows
>
```

Usage - Party Registration Dataset
-----

To access the PartyRegistration data frame that is exposed by the package:

```
> uselections::PartyRegistration
# A tibble: 3,250 × 22
   State County  Year Month     D     G     L      N     O     R  Total  dPct  rPct leanD leanR unaffiliatedPct otherPct dDRPct rDRPct CountyName StateName StateAbbr
   <chr>  <chr> <int> <int> <int> <int> <int>  <int> <int> <int>  <dbl> <dbl> <dbl> <dbl> <dbl>           <dbl>    <dbl>  <dbl>  <dbl>      <chr>     <chr>     <chr>
1     01  01001  2016    11    NA    NA    NA  34310    NA    NA  34310    NA    NA    NA    NA               1       NA     NA     NA    Autauga   Alabama        AL
2     01  01003  2016    11    NA    NA    NA 128743    NA    NA 128743    NA    NA    NA    NA               1       NA     NA     NA    Baldwin   Alabama        AL
3     01  01005  2016    11    NA    NA    NA  16218    NA    NA  16218    NA    NA    NA    NA               1       NA     NA     NA    Barbour   Alabama        AL
4     01  01007  2016    11    NA    NA    NA  12108    NA    NA  12108    NA    NA    NA    NA               1       NA     NA     NA       Bibb   Alabama        AL
5     01  01009  2016    11    NA    NA    NA  34276    NA    NA  34276    NA    NA    NA    NA               1       NA     NA     NA     Blount   Alabama        AL
6     01  01011  2016    11    NA    NA    NA   7258    NA    NA   7258    NA    NA    NA    NA               1       NA     NA     NA    Bullock   Alabama        AL
7     01  01013  2016    11    NA    NA    NA  13171    NA    NA  13171    NA    NA    NA    NA               1       NA     NA     NA     Butler   Alabama        AL
8     01  01015  2016    11    NA    NA    NA  67364    NA    NA  67364    NA    NA    NA    NA               1       NA     NA     NA    Calhoun   Alabama        AL
9     01  01017  2016    11    NA    NA    NA  22002    NA    NA  22002    NA    NA    NA    NA               1       NA     NA     NA   Chambers   Alabama        AL
10    01  01019  2016    11    NA    NA    NA  15090    NA    NA  15090    NA    NA    NA    NA               1       NA     NA     NA   Cherokee   Alabama        AL
# ... with 3,240 more rows
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

