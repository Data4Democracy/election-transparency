The [PartyRegistration](https://data.world/data4democracy/election-transparency/file/PartyRegistration.csv) file reports voter registration (by party where available) by month and year. In states where registration by party is not allowed, all those registered to vote are grouped under `'N' = Voters registered as unaffiliated with a party`. These data were collected from each state's Secretary of State Website. 

Below is a listing of each of the variables in the dataset with a short description:

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
