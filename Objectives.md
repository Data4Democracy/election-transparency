### Data For Democracy - Election Transparency Project

This (living) document tracks our project's goals, in terms of the research questions we plan to investigate.  We anticipate continuing to
update (add content to, as well as restructure as needed) the document as we identify additional interesting questions.  To suggest
questions, please raise them on the #election-transparency Slack channel within d4d.  Or submit diffs to this document via a PR.

#### Key Questions

We are initially focused on three questions (in rough priority order, based upon availability of data):

1. Examine factors that explain county-level Presidential election results in 2016, and identify counties exhibiting anomalies or unexplained variation.
1. Examine ways in which the 2016 election differed from recent (or maybe even not-so-recent) elections, taking socio-economic and demographic characteristics of the electorate into account.
1. Examine the significance and impact of redistricting on election outcomes.

#### Important Links:

* [Project github home](https://github.com/Data4Democracy/election-transparency)
* [General election-transparency project overview](https://github.com/Data4Democracy/election-transparency/blob/master/README.md)
* [Project space on data.world](https://data.world/data4democracy/election-transparency)

#### Summary of our datasets

Our data currently include, for every county in the United States:

* Vote counts for Trump (R), Clinton (D), Johnson (L), Stein (G), and Other candidates in the 2016 election ([data.world](https://data.world/data4democracy/election-transparency/file/PresidentialElectionResults2016.csv))
* Number of registered voters eligible to vote in the 2016 election ([data.world](https://data.world/data4democracy/election-transparency/file/PartyRegistration.csv))
	* In the 28 states plus the District of Columbia where state law allows party affiliation at registration, the total number of voters registered in the following parties:
		* Democratic
		* Green
		* Libertarian
		* Republican
		* Unaffiliated
		* Other
	* In the other 22 states, just total registered voters (categorized as "unaffiliated")
* Limited (but growing) voter registration data for periods earlier than the 2016 general election
* For most counties (i.e., where data are available), various socio-economic and demographic variables (data.world link pending)
	* From the American Community Survey, 2015, 5-year estimates:
		* Total population
		* Age (population by Census age categories, median age)
		* Sex
		* Race
		* Ethnicity (Hispanic / non-Hispanic)
		* Educational attainment (population by Census categories)
		* Median household income
		* Employment and Labor Market Participation
	* Oct 2016 employment and unemployment (From the Census Current Population Survey, via Bureau of Labor Statistics)
	* Total employment and manufacturing employment in 1980, 1990, 2000, 2010, and 2016 from the Bureau of Economic Analysis
* Election-related attributes of each of the 50 states plus DC, including:  Number of electoral votes, type of voter ID law in place in 2016 ([data.world](https://data.world/data4democracy/election-transparency/file/States.csv))

We also have the FIPS county code, county name, state FIPS code, state name, and state abbreviation to support creation of choropleths and geographic rollups.

#### Key Question 1: Cross-section study of 2016 Presidential Election

This category is our initial priority, because it is best supported by the data we have initially on-hand.  The overall objective here is to examine factors that explain
county-level Presidential election results in 2016, and also to identify counties exhibiting anomalies or unexplained variation.

##### Useful summarizations:

* State/county choropleths for the swing states (viz)
* Some basic viz (e.g., stacked bar charts) of (candidate vote totals, party reg, D/R victory margin) ~ (each of the socio-economic and demographic factors)
* Imbalance of the "impact" of a vote due to the electoral college (viz)
* Characteristics of the n closest counties (n=20?  n=50?).  What made things so close in Winnebago County (Rockford), Illinois anyway, where HRC won 55,713 to 55,624, a margin of 0.08%??
* Characteristics of counties where Johnson and Stein votes were greater than the margin of victory.  Which candidate won?
* Scatterplots (blue (D) vs red (R)) dots, possibly with dot size representing victory margin) for 2D crosstabs (viz).  Like:
	* Educational attainment / unemployment
	* Age / Race
	* Race / manufacturing decline
* Turnout and margin of victory (i.e., did more voters turn out in counties where the race wound up being close)
* Counties where margin of victory was significantly different than that party's registration margin (in 28 states + DC that allow affiliation) (viz - maps and tables)

##### Modeling ideas:

* Basic regressions (various combinations...expect this will be an iterative process!):
	* D/R victory margin ~ median age; % white non-hispanic; % high school ed only; % college and above; income; manufacturing decline; unemployment; LFPR; turnout; party registration
	* (logistic) D (or R) win ~ ^^^^
	* Once we get a model with a good fit, look at the residuals and see if that helps identify some anomalies
* Train various classification models, then look at counties that consistently aren't classified properly
