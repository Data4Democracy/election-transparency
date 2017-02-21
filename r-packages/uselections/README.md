Overview
--------

The uselections package provides functionality for loading information about voter registration and election results in the
United States.  The initial goal is to provide data on registration (including party affiliation in states that allow it) as close to the time of the 2016 general election as data are available, as well as 2016 presidential election results. We will iterate on this initial goal to include additional historical data.

We have also added a "County Characteristics" data frame, with interesting explanatory variables that could be useful in visualizing and/or modeling 2016 election results.

Installation
------------

We do not have immediate plans to push the package to CRAN, so you need to install directly from GitHub.  Note that this
will install all dependencies as well.  These dependencies include the rgeos package, which can be a little tricky to
install on some platforms.

``` r
# install.packages("devtools")
devtools::install_github("Data4Democracy/election-transparency/r-packages/uselections")
```

Usage - States Dataset
----------------------

The package includes a data frame containing some useful state-level variables, including:

* the number of electoral votes allocated to each state based on the 2010 census, applicable to Presidential elections in 2012, 2016, and 2020.
* whether state law allows party affiliation at registration

```
> uselections::States
# A tibble: 51 × 5
   State            StateName StateAbbr ElectoralVotes AllowsPartyRegistration
   <chr>                <chr>     <chr>          <int>                   <int>
1     01              Alabama        AL              9                       0
2     02               Alaska        AK              3                       1
3     04              Arizona        AZ             11                       0
4     05             Arkansas        AR              6                       0
5     06           California        CA             55                       1
6     08             Colorado        CO              9                       1
7     09          Connecticut        CT              7                       1
8     10             Delaware        DE              3                       1
9     11 District of Columbia        DC              3                       1
10    12              Florida        FL             29                       1
# ... with 41 more rows
>
```

Usage - Party Registration Dataset
----------------------------------

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
----------------------------

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

Usage - County Characteristics Dataset
--------------------------------------

To access the CountyCharacteristics data frame that is exposed by the package:

```
> uselections::CountyCharacteristics
# A tibble: 3,141 × 68
   County MedianHouseholdIncome TotalPopulation  Male Female Age0_4 Age5_9 Age10_14 Age15_19 Age20_24 Age25_34 Age35_44 Age45_54 Age55_59 Age60_64
    <chr>                 <int>           <int> <int>  <int>  <int>  <int>    <int>    <int>    <int>    <int>    <int>    <int>    <int>    <int>
1   01001                 51281           55221 26745  28476   3242   3890     4314     4034     3422     6724     7716     8173     3530     2698
2   01003                 50254          195121 95314  99807  10494  12787    12868    11793    10178    22740    24627    27202    13043    14013
3   01005                 32964           26932 14497  12435   1476   1752     1570     1493     1833     3870     3360     3783     1848     1622
4   01007                 38678           22604 12073  10531   1133   1458     1420     1603     1361     3086     3445     3131     1351     1361
5   01009                 45813           57710 28512  29198   3545   3773     3921     3923     3140     6768     7445     8246     3740     3697
6   01011                 31938           10678  5660   5018    675    660      575      456      874     1321     1686     1421      593      859
7   01013                 32229           20354  9502  10852   1243   1389     1314     1140     1272     2456     2353     2673     1422     1468
8   01015                 41703          116648 56274  60374   6816   7538     7168     7780     8646    14763    14167    15887     8110     7706
9   01017                 34177           34079 16258  17821   2040   1956     2058     2031     2180     3876     4171     4854     2790     2001
10  01019                 36296           26008 12975  13033   1285   1509     1554     1502     1424     2524     3059     3837     2004     2154
# ... with 3,131 more rows, and 53 more variables: Age65_74 <int>, Age75_84 <int>, Age85 <int>, MedianAge <dbl>, White <int>, Black <int>,
#   AmericanIndianAlaskaNative <int>, Asian <int>, NativeHawaiianPacificIslander <int>, OtherRace <int>, Hispanic <int>,
#   SimpsonDiversityIndex <dbl>, Population25Plus <int>, EdK8 <int>, Ed9_12 <int>, EdHS <int>, EdCollNoDegree <int>, EdAssocDegree <int>,
#   EdBachelorDegree <int>, EdGraduateDegree <int>, MedianHousingCosts <int>, Married <int>, Widowed <int>, Divorced <int>, Separated <int>,
#   NeverMarried <int>, Uninsured <int>, ForeignBorn <int>, NonCitizen <int>, Disability <int>, MfgEmp1970 <int>, MfgEmp1980 <int>,
#   MfgEmp1990 <int>, MfgEmp2001 <int>, MfgEmp2015 <int>, TotalEmp1970 <int>, TotalEmp1980 <int>, TotalEmp1990 <int>, TotalEmp2001 <int>,
#   TotalEmp2015 <int>, LandAreaSqMiles <dbl>, Employment <dbl>, LaborForce <dbl>, Unemployment <dbl>, TotalSSI <int>, AgedSSI <int>,
#   BlindDisabledSSI <int>, OASDI <int>, SSIPayments <int>, NCHS_UrbanRural2013 <chr>, NCHS_UrbanRural2006 <chr>, NCHS_UrbanRural1990 <chr>,
#   State <chr>
>```

For detailed documentation on the data frame:  `?uselections::CountyCharacteristics`.  In short:

* State = 2-character FIPS code for the state
* County = 5-character FIPS code for the county
* MedianHouseholdIncome = Median Household Income (2015 ACS 5-year estimate)
* TotalPopulation = Total County Population (2015 ACS 5-year estimate)
* Male = Total County Male Population (2015 ACS 5-year estimate)
* Female = County Female Population (2015 ACS 5-year estimate)
* Age0_4 = County Population Age 0-4 (2015 ACS 5-year estimate)
* Age5_9 = County Population Age 5-9 (2015 ACS 5-year estimate)
* Age10_14 = County Population Age 10-14 (2015 ACS 5-year estimate)
* Age15_19 = County Population Age 15-19 (2015 ACS 5-year estimate)
* Age20_24 = County Population Age 20-24 (2015 ACS 5-year estimate)
* Age25_34 = County Population Age 25-34 (2015 ACS 5-year estimate)
* Age35_44 = County Population Age 35-44 (2015 ACS 5-year estimate)
* Age45_54 = County Population Age 45-54 (2015 ACS 5-year estimate)
* Age55_59 = County Population Age 55-59 (2015 ACS 5-year estimate)
* Age60_64 = County Population Age 60-64 (2015 ACS 5-year estimate)
* Age65_74 = County Population Age 65-74 (2015 ACS 5-year estimate)
* Age75_84 = County Population Age 75-84 (2015 ACS 5-year estimate)
* Age85 = County Population Age 85+ (2015 ACS 5-year estimate)
* MedianAge = Median Age in County (2015 ACS 5-year estimate)
* White = County Population, Race=White (2015 ACS 5-year estimate)
* Black = County Population, Race=Black (2015 ACS 5-year estimate)
* AmericanIndianAlaskaNative = County Population, Race=American Indian / Alaska Native (2015 ACS 5-year estimate)
* Asian = County Population, Race=Asian (2015 ACS 5-year estimate)
* NativeHawaiianPacificIslander = County Population, Race=Native Hawaiian / Pacific Islander (2015 ACS 5-year estimate)
* OtherRace = County Population, Race=Other (2015 ACS 5-year estimate)
* Hispanic = County Population, Ethnicity=Hispanic (2015 ACS 5-year estimate)
* SimpsonDiversityIndex = Inverse Simpson Diversity Index
* Population25Plus = County Population Age 25+ (2015 ACS 5-year estimate)
* EdK8 = County Population with Education 8th grade or less (2015 ACS 5-year estimate)
* Ed9_12 = County Population with Education 9th-12th grade (2015 ACS 5-year estimate)
* EdHS = County Population, High School Graduate / equivalent (2015 ACS 5-year estimate)
* EdCollNoDegree = County Population, some college (2015 ACS 5-year estimate)
* EdAssocDegree = County Population, associate degree (2015 ACS 5-year estimate)
* EdBachelorDegree = County Population, bachelor degree (2015 ACS 5-year estimate)
* EdGraduateDegree = County Population, graduate degree (2015 ACS 5-year estimate)
* MedianHousingCosts = Median County Monthly Housing Costs (2015 ACS 5-year estimate)
* MfgEmp1970 = County Manufacturing Employment in 1970
* MfgEmp1980 = County Manufacturing Employment in 1980
* MfgEmp1990 = County Manufacturing Employment in 1990
* MfgEmp2001 = County Manufacturing Employment in 2001
* MfgEmp2015 = County Manufacturing Employment in 2015
* TotalEmp1970 = County Total Employment in 1970
* TotalEmp1980 = County Total Employment in 1980
* TotalEmp1990 = County Total Employment in 1990
* TotalEmp2001 = County Total Employment in 2001
* TotalEmp2015 = County Total Employment in 2015
* LandAreaSqMiles = County Land Area (in square miles)
* Employment = County Employment, Oct 2016
* LaborForce = County Labor Force, Oct 2016
* Unemployment = County Unemployment, Oct 2016
* NCHS_UrbanRural2013 = CDC census-based NCHS Urban-Rural Classification Scheme for Counties (2010 Census)
* NCHS_UrbanRural2006 = CDC census-based NCHS Urban-Rural Classification Scheme for Counties (2000 Census)
* NCHS_UrbanRural1990 = CDC census-based NCHS Urban-Rural Classification Scheme for Counties (1990 Census)
* Married = Total married population (2015 ACS 5-year estimates)
* Widowed = Total widowed population (2015 ACS 5-year estimates)
* Separated = Total separated population (2015 ACS 5-year estimates)
* Divorced = Total divorced population (2015 ACS 5-year estimates)
* NeverMarried = Total never-married population (2015 ACS 5-year estimates)
* Uninsured = Total without health insurance (2015 ACS 5-year estimates)
* ForeignBorn = Total foreign born population (2015 ACS 5-year estimates)
* NonCitizen = Total non-citizen population (2015 ACS 5-year estimates)
* Disability = Total population with disability (2015 ACS 5-year estimates)
* TotalSSI = Total persons receiving SSI benefits in 2015 (SSI Recipients by State/County)
* AgedSSI = Total persons receiving SSI aged benefits in 2015 (SSI Recipients by State/County)
* BlindDisabledSSI = Total persons receiving SSI blind/disabled benefits in 2015 (SSI Recipients by State/County)
* OASDI = Total persons receiving OASDI benefits in 2015 (SSI Recipients by State/County)
* SSIPayments = Total SSI payments received in 2015 (SSI Recipients by State/County)

