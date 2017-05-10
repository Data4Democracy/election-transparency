Overview
--------

The frelections package provides functionality for loading information about election results in France, starting initially with the 2017 Presidential election.

Installation
------------

We do not have immediate plans to push the package to CRAN, so you need to install directly from GitHub.

``` r
# install.packages("devtools")
devtools::install_github("Data4Democracy/election-transparency/r-packages/frelections")
```

Usage - Turnout Dataset
-----------------------

The Turnout2017 data frame contains data on the number of registered voters and the ballot status in each commune in the two rounds of the 2017 Presidential election.

To access the Turnout2017 data frame that is exposed by the package:

```
> frelections::Turnout2017
# A tibble: 71,034 × 15
   Region            RegionNom Departement DepartementNom CommuneCode                    CommuneName CommuneCodeINSEE     CommuneNomINSEE Round Abstentions Blancs Exprimés Inscrits  Nuls Votants
    <chr>                <chr>       <chr>          <chr>       <chr>                          <chr>            <chr>               <chr> <chr>       <int>  <int>    <int>    <int> <int>   <int>
1     084 AUVERGNE-RHONE-ALPES         001            AIN      001006             Commune de Ambléon            01006             AMBLEON     2          23     17       59       99     0      76
2     084 AUVERGNE-RHONE-ALPES         001            AIN      001006             Commune de Ambléon            01006             AMBLEON     1          20      2       77       99     0      79
3     084 AUVERGNE-RHONE-ALPES         001            AIN      001007            Commune de Ambronay            01007            AMBRONAY     2         336    138     1375     1880    31    1544
4     084 AUVERGNE-RHONE-ALPES         001            AIN      001007            Commune de Ambronay            01007            AMBRONAY     1         268     53     1548     1880    11    1612
5     084 AUVERGNE-RHONE-ALPES         001            AIN      001008            Commune de Ambutrix            01008            AMBUTRIX     2         107     39      419      581    16     474
6     084 AUVERGNE-RHONE-ALPES         001            AIN      001008            Commune de Ambutrix            01008            AMBUTRIX     1          91     12      473      581     5     490
7     084 AUVERGNE-RHONE-ALPES         001            AIN      001004   Commune de Ambérieu-en-Bugey            01004   AMBERIEU-EN-BUGEY     2        2312    601     5456     8586   217    6274
8     084 AUVERGNE-RHONE-ALPES         001            AIN      001004   Commune de Ambérieu-en-Bugey            01004   AMBERIEU-EN-BUGEY     1        1962    114     6452     8586    58    6624
9     084 AUVERGNE-RHONE-ALPES         001            AIN      001005 Commune de Ambérieux-en-Dombes            01005 AMBERIEUX-EN-DOMBES     2         259     77      812     1172    24     913
10    084 AUVERGNE-RHONE-ALPES         001            AIN      001005 Commune de Ambérieux-en-Dombes            01005 AMBERIEUX-EN-DOMBES     1         215     21      933     1172     3     957
# ... with 71,024 more rows
> 
```

For detailed documentation on the data frame:  `?frelections::Turnout2017`.  In short:

* Region: Region Code (INSEE)
* RegionNom: Region Name
* Departement: Departement Code (INSEE)
* DepartmentNom: Department Name
* CommuneCode: Commune Code (elections)
* CommuneName: Commune Name (elections)
* CommuneCodeINSEE: Commune Code (INSEE)
* CommuneNomINSEE: Commune Name (INSEE)
* Round: Round 1/2
* Inscrits: Number of Registered Voters
* Abstentions: Number of Abstentions
* Votants: Number of Ballots Cast
* Blancs: Number of Blank Votes
* Nuls: Number of Invalid/Null Votes
* Exprimés: Number of Candidate/Valid Votes

Usage - Results Dataset
-----------------------

The Results2017 data frame contains data on the results, by commune and candidate, of the two rounds of the 2017 Presidential election.

To access the Results2017 data frame that is exposed by the package:

```
> frelections::Results2017
# A tibble: 461,721 × 11
   Region            RegionNom Departement DepartementNom CommuneCode        CommuneName CommuneCodeINSEE CommuneNomINSEE Round                Candidate Votes
    <chr>                <chr>       <chr>          <chr>       <chr>              <chr>            <chr>           <chr> <chr>                    <chr> <int>
1     084 AUVERGNE-RHONE-ALPES         001            AIN      001006 Commune de Ambléon            01006         AMBLEON     2       M. Emmanuel MACRON    30
2     084 AUVERGNE-RHONE-ALPES         001            AIN      001006 Commune de Ambléon            01006         AMBLEON     2        Mme Marine LE PEN    29
3     084 AUVERGNE-RHONE-ALPES         001            AIN      001006 Commune de Ambléon            01006         AMBLEON     1    M. Jean-Luc MÉLENCHON    19
4     084 AUVERGNE-RHONE-ALPES         001            AIN      001006 Commune de Ambléon            01006         AMBLEON     1        Mme Marine LE PEN    18
5     084 AUVERGNE-RHONE-ALPES         001            AIN      001006 Commune de Ambléon            01006         AMBLEON     1       M. Emmanuel MACRON    15
6     084 AUVERGNE-RHONE-ALPES         001            AIN      001006 Commune de Ambléon            01006         AMBLEON     1       M. François FILLON    14
7     084 AUVERGNE-RHONE-ALPES         001            AIN      001006 Commune de Ambléon            01006         AMBLEON     1 M. Nicolas DUPONT-AIGNAN     4
8     084 AUVERGNE-RHONE-ALPES         001            AIN      001006 Commune de Ambléon            01006         AMBLEON     1          M. Benoît HAMON     3
9     084 AUVERGNE-RHONE-ALPES         001            AIN      001006 Commune de Ambléon            01006         AMBLEON     1       M. Philippe POUTOU     2
10    084 AUVERGNE-RHONE-ALPES         001            AIN      001006 Commune de Ambléon            01006         AMBLEON     1     Mme Nathalie ARTHAUD     1
# ... with 461,711 more rows
>
```

For detailed documentation on the data frame:  `?frelections::Results2017`.  In short:

* Region: Region Code (INSEE)
* RegionNom: Region Name
* Departement: Departement Code (INSEE)
* DepartmentNom: Department Name
* CommuneCode: Commune Code (elections)
* CommuneName: Commune Name (elections)
* CommuneCodeINSEE: Commune Code (INSEE)
* CommuneNomINSEE: Commune Name (INSEE)
* Round: Round 1/2
* Candidate: Name of candidate
* Votes: Number of Votes
