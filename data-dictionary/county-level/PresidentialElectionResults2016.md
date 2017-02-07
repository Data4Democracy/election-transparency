The [PresidentialElectionResults2016](https://data.world/data4democracy/election-transparency/file/PresidentialElectionResults2016.csv) file provides county level results for the 2016 Presidential Election. These data mostly came from a dataset compiled by Harvard Researchers (need to provide link). (Provide any information on things we needed to change in the file). The following variables are on the file for our use:

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
