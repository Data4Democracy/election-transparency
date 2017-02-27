#' Voter Party Registration Dataset
#'
#' This dataset contains voter registration by county.
#' In the 30 states plus DC that allow party registration under state law, the registration
#' by party is included in separate fields; in the other states, all voters are tallied under
#' the N=Unaffiliated field.
#'
#' The data in this dataset were sourced from state elections websites.  We have a todo
#' to produce a detailed document listing the data sources.
#'
#' Note: There is considerable variation across states in reporting registration
#' for parties other than Democratic or Republican.  Most states report
#' Green Party and Libertarian, but not all.  Some states report other parties
#' as well.  The "other" variable captures all registrations for parties in
#' that county that are not NA.  That is, if the Green Party has a non-NA
#' value for a county, then the Green Party is not counted in "other" for that
#' county.
#'
#' Note:  Not all states capture No Party or Unaffiliated separately.  If these
#' are reported separately for a state, they are combined in the N variable.
#'
#' This data frame has more rows than PresidentialElectionResults2016 because there are 29 extra annual registration obs for Hawaii (x4 counties = 116 rows)
#' and 5 extra 2016 monthly obs for Arizona (x15 counties = 75 rows).  3141+75+116=3332.
#'
#' @format A data frame with 3,332 rows and 22 variables:
#' \describe{
#'  \item{State}{2-character FIPS code for the state}
#'  \item{StateAbbr}{2-character abbreviation for the state}
#'  \item{StateName}{Name of the state}
#'  \item{County}{2-character FIPS code for the county}
#'  \item{CountyName}{Name of the county}
#'  \item{D}{Democratic Party registration}
#'  \item{G}{Green Party registration}
#'  \item{L}{Libertarian Party registration}
#'  \item{N}{No Party / Unaffiliated registration}
#'  \item{O}{Other party registration}
#'  \item{R}{Republican Party registration}
#'  \item{Total}{Total registration}
#'  \item{dPct}{Percentage Democratic Party Registration (D/Total)}
#'  \item{rPct}{Percentage Republican Party Registration (R/Total)}
#'  \item{otherPct}{Percentage Other Party Registration (O/Total)}
#'  \item{unaffiliatedPct}{Percentage Unaffiliated Registration (N/Total)}
#'  \item{dDRPct}{Democratic Party Registration as percentage of Democratic plus Republican Registration (D/(D+R))}
#'  \item{rDRPct}{Republican Party Registration as percentage of Democratic plus Republican Registration (R/(D+R))}
#'  \item{leanD}{Lean Democractic ratio (D/R)}
#'  \item{leanR}{Lean Republican ratio (R/D)}
#'  \item{Year}{Year of Reporting}
#'  \item{Month}{Month of Reporting}
#' }
"PartyRegistration"

#' Presidential Election Results Dataset (2016)
#'
#' This dataset contains county-level results of the 2016 presidential election.
#'
#' The data in this dataset were sourced from state elections websites, but most were
#' obtained through the intermediary of the Steven Pettigrew dataverse dataset
#' at https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/MLLQDH.
#'
#' Note: Alaska published results for absentee and early voting by district, not precint.
#' Since districts do not roll up to Boroughs (county equivalents), we allocated these
#' votes to precincts according to the share of each precinct's total ballots within its district, before
#' rolling all Alaska precincts up into their counties.
#'
#' @format A data frame with 3,141 rows and 18 variables:
#' \describe{
#'  \item{State}{2-character FIPS code for the state}
#'  \item{StateAbbr}{2-character abbreviation for the state}
#'  \item{StateName}{Name of the state}
#'  \item{County}{2-character FIPS code for the county}
#'  \item{CountyName}{Name of the county}
#'  \item{clinton}{Votes for Hillary Clinton}
#'  \item{stein}{Votes for Jill Stein}
#'  \item{johnson}{Votes for Gary Johnson}
#'  \item{trump}{Votes for Donald Trump}
#'  \item{other}{Votes for other candidates}
#'  \item{totalvotes}{Total ballots cast for president}
#'  \item{dPct}{Percentage of total votes for Clinton (clinton/totalvotes)}
#'  \item{rPct}{Percentage of total votes for Trump (trump/totalvotes)}
#'  \item{otherPct}{Percentage Other votes (other/totalvotes)}
#'  \item{dDRPct}{Clinton votes as percentage of Clinton plus Trump votes (clinton/(clinton+trump))}
#'  \item{rDRPct}{Trump votes as percentage of Clinton plus Trump votes (trump/(clinton+trump))}
#'  \item{leanD}{Lean Clinton ratio (clinton/trump)}
#'  \item{leanR}{Lean Trump ratio (trump/clinton)}
#' }
"PresidentialElectionResults2016"

#' States and certain electoral attributes
#'
#' @format A data frame with 51 rows and 4 variables:
#' \describe{
#'  \item{State}{2-character FIPS code for the state}
#'  \item{StateAbbr}{2-character abbreviation for the state}
#'  \item{StateName}{Name of the state}
#'  \item{ElectoralVotes}{Number of electoral votes allocated to the state in 2010 Census for 2012, 2016, and 2020 elections}
#'  \item{AllowsPartyRegistration}{=1 if state allows party affiliation at voter registration, =0 otherwise}
#' }
"States"

#' Mapping of Alaska precincts to boroughs / census areas, based on precinct boundaries drawn for three different periods:
#'
#' * Year=2010: Elections prior to 2012
#' * Year=2012: 2012 general election
#' * Year=2013: Elections after 2012
#'
#' @format A data frame with 1,335 rows and 3 variables:
#' \describe{
#'  \item{Year}{Year boundaries were in effect (see details above)}
#'  \item{Precinct}{The precinct identifier}
#'  \item{County}{the 3-digit FIPS code (i.e., minus the state prefix) for the borough or census area}
#' }
"AlaskaPrecinctBoroughMapping"

#' Socio-economic and demographic characteristics of counties
#'
#' @format A data frame with 3,141 rows and 54 variables:
#' \describe{
#' \item{State}{2-character FIPS code for the state}
#' \item{County}{5-character FIPS code for the county}
#' \item{MedianHouseholdIncome}{Median Household Income (2015 ACS 5-year estimate)}
#' \item{TotalPopulation}{Total County Population (2015 ACS 5-year estimate)}
#' \item{Male}{Total County Male Population (2015 ACS 5-year estimate)}
#' \item{Female}{County Female Population (2015 ACS 5-year estimate)}
#' \item{Age0_4}{County Population Age 0-4 (2015 ACS 5-year estimate)}
#' \item{Age5_9}{County Population Age 5-9 (2015 ACS 5-year estimate)}
#' \item{Age10_14}{County Population Age 10-14 (2015 ACS 5-year estimate)}
#' \item{Age15_19}{County Population Age 15-19 (2015 ACS 5-year estimate)}
#' \item{Age20_24}{County Population Age 20-24 (2015 ACS 5-year estimate)}
#' \item{Age25_34}{County Population Age 25-34 (2015 ACS 5-year estimate)}
#' \item{Age35_44}{County Population Age 35-44 (2015 ACS 5-year estimate)}
#' \item{Age45_54}{County Population Age 45-54 (2015 ACS 5-year estimate)}
#' \item{Age55_59}{County Population Age 55-59 (2015 ACS 5-year estimate)}
#' \item{Age60_64}{County Population Age 60-64 (2015 ACS 5-year estimate)}
#' \item{Age65_74}{County Population Age 65-74 (2015 ACS 5-year estimate)}
#' \item{Age75_84}{County Population Age 75-84 (2015 ACS 5-year estimate)}
#' \item{Age85}{County Population Age 85+ (2015 ACS 5-year estimate)}
#' \item{MedianAge}{Median Age in County (2015 ACS 5-year estimate)}
#' \item{White}{County Population, Race=White (2015 ACS 5-year estimate)}
#' \item{Black}{County Population, Race=Black (2015 ACS 5-year estimate)}
#' \item{AmericanIndianAlaskaNative}{County Population, Race=American Indian / Alaska Native (2015 ACS 5-year estimate)}
#' \item{Asian}{County Population, Race=Asian (2015 ACS 5-year estimate)}
#' \item{NativeHawaiianPacificIslander}{County Population, Race=Native Hawaiian / Pacific Islander (2015 ACS 5-year estimate)}
#' \item{OtherRace}{County Population, Race=Other (2015 ACS 5-year estimate)}
#' \item{Hispanic}{County Population, Ethnicity=Hispanic (2015 ACS 5-year estimate)}
#' \item{SimpsonDiversityIndex}{Inverse Simpson Diversity Index}
#' \item{Population25Plus}{County Population Age 25+ (2015 ACS 5-year estimate)}
#' \item{EdK8}{County Population with Education 8th grade or less (2015 ACS 5-year estimate)}
#' \item{Ed9_12}{County Population with Education 9th-12th grade (2015 ACS 5-year estimate)}
#' \item{EdHS}{County Population, High School Graduate / equivalent (2015 ACS 5-year estimate)}
#' \item{EdCollNoDegree}{County Population, some college (2015 ACS 5-year estimate)}
#' \item{EdAssocDegree}{County Population, associate degree (2015 ACS 5-year estimate)}
#' \item{EdBachelorDegree}{County Population, bachelor degree (2015 ACS 5-year estimate)}
#' \item{EdGraduateDegree}{County Population, graduate degree (2015 ACS 5-year estimate)}
#' \item{MedianHousingCosts}{Median County Monthly Housing Costs (2015 ACS 5-year estimate)}
#' \item{MfgEmp1970}{County Manufacturing Employment in 1970}
#' \item{MfgEmp1980}{County Manufacturing Employment in 1980}
#' \item{MfgEmp1990}{County Manufacturing Employment in 1990}
#' \item{MfgEmp2001}{County Manufacturing Employment in 2001}
#' \item{MfgEmp2015}{County Manufacturing Employment in 2015}
#' \item{TotalEmp1970}{County Total Employment in 1970}
#' \item{TotalEmp1980}{County Total Employment in 1980}
#' \item{TotalEmp1990}{County Total Employment in 1990}
#' \item{TotalEmp2001}{County Total Employment in 2001}
#' \item{TotalEmp2015}{County Total Employment in 2015}
#' \item{LandAreaSqMiles}{County Land Area (in square miles)}
#' \item{Employment}{County Employment, Oct 2016}
#' \item{LaborForce}{County Labor Force, Oct 2016}
#' \item{Unemployment}{County Unemployment, Oct 2016}
#' \item{NCHS_UrbanRural2013}{CDC census-based NCHS Urban-Rural Classification Scheme for Counties (2010 Census)}
#' \item{NCHS_UrbanRural2006}{CDC census-based NCHS Urban-Rural Classification Scheme for Counties (2000 Census)}
#' \item{NCHS_UrbanRural1990}{CDC census-based NCHS Urban-Rural Classification Scheme for Counties (1990 Census)}
#' \item{Married}{Total married population (2015 ACS 5-year estimates)}
#' \item{Widowed}{Total widowed population (2015 ACS 5-year estimates)}
#' \item{Separated}{Total separated population (2015 ACS 5-year estimates)}
#' \item{Divorced}{Total divorced population (2015 ACS 5-year estimates)}
#' \item{NeverMarried}{Total never-married population (2015 ACS 5-year estimates)}
#' \item{Uninsured}{Total without health insurance (2015 ACS 5-year estimates)}
#' \item{ForeignBorn}{Total foreign born population (2015 ACS 5-year estimates)}
#' \item{NonCitizen}{Total non-citizen population (2015 ACS 5-year estimates)}
#' \item{Disability}{Total population with disability (2015 ACS 5-year estimates)}
#' \item{TotalSSI}{Total persons receiving SSI benefits in 2015 (SSI Recipients by State/County)}
#' \item{AgedSSI}{Total persons receiving SSI aged benefits in 2015 (SSI Recipients by State/County)}
#' \item{BlindDisabledSSI}{Total persons receiving SSI blind/disabled benefits in 2015 (SSI Recipients by State/County)}
#' \item{OASDI}{Total persons receiving OASDI benefits in 2015 (SSI Recipients by State/County)}
#' \item{SSIPayments}{Total SSI payments received in 2015 (SSI Recipients by State/County)}
#' \item{WoodardAmericanNation}{The "Nation" to which the county belongs, in Colin Woodard's "American Nations"}
#' \item{FoundryCounty}{Whether the county is part of "The Foundry", one of the nine Nations of North America defined by Joel Garreau (roughly, the rustbelt)}
#' \item{MexicanBorderCounty}{Whether the county is within approximately 75 miles of the Mexican border}
#' \item{TotalReligiousAdherents}{Total number of religious adherents (2010 ARDA Religious Cong/Membership Survey)}
#' \item{EvangelicalAdherents}{Evangelical religious adherents (2010 ARDA Religious Cong/Membership Survey)}
#' \item{CatholicAdherents}{Catholic religious adherents (2010 ARDA Religious Cong/Membership Survey)}
#' \item{MormonAdherents}{Mormon religious adherents (2010 ARDA Religious Cong/Membership Survey)}
#' }
"CountyCharacteristics"

