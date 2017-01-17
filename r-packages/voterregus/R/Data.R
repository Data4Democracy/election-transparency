#' Voter Party Registration Dataset (2016)
#'
#' This dataset contains voter registration by county in each political party,
#' in the 28 states plus DC that allow party registration under state law, at the time closest to the 2016
#' General Election as source data allow.
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
#' @format A data frame with 1,231 rows and 8 variables:
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
#' }
"PartyRegistration2016"

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
#' @format A data frame with 3,036 rows and 18 variables:
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
