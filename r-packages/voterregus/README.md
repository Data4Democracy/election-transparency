Overview
--------

The voterregus (Voter Reg(istration) US) package provides functionality for loading information about...voter registration in the
United States.  The initial goal is to provide data on registration in states that allow party affiliation as close to the
time of the 2016 general election as data are available.  We will iterate on this initial goal to include historical data
and also data from states that do not support party affiliation.

Installation
------------

We do not have immediate plans to push the package to CRAN, so you need to install directly from GitHub.  Note that this
will install all dependencies as well.  These dependencies include the rgeos package, which can be a little tricky to
install on some platforms.

``` r
# install.packages("devtools")
devtools::install_github("Data4Democracy/voter-fraud/r-packages/voterregus")
```

Usage
-----

Most users will just want to access the PartyRegistration data frame that is exposed by the package:

```
> voterregus::PartyRegistration
# A tibble: 1,231 × 8
   State County     D     G     L      N     O     R
   <chr>  <chr> <int> <int> <int>  <int> <int> <int>
1     02  02013   152     0    12   1071    43   211
2     02  02016   577     7    21   1387   101   448
3     02  02020 35841   601  4283 111946  6787 57352
4     02  02050  2573    30    70   5851   534  1164
5     02  02060    96     2     6    501    26   192
6     02  02068   303    22    14    919    77   453
7     02  02070   651    10    26   1862   162   408
8     02  02090  9744   244   708  37042  2390 20890
9     02  02100   447    29    16   1270    92   444
10    02  02105   845    23    25   1875   131   580
# ... with 1,221 more rows
>
```

For detailed documentation on the data frame:  `?voterregus::PartyRegistration`.  In short:

* State = 2-character FIPS code for the state
* County = 5-character FIPS code for the county
* D = Voters registered as affiliated with Democractic Party
* G = Voters registered as affiliated with Green Party
* L = Voters registered as affiliated with Libertarian Party
* N = Voters registered as unaffiliated with a party
* O = Voters registered as affiliated with some party other than D, G, L, R
* R = Voters registered as affiliated with Republican Party
