#' Voter Party Registration Dataset
#'
#' This dataset contains voter registration by county in each political party,
#' in the 28 states plus DC that allow party registration under state law.
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
#' @format A data frame with 178 rows and 8 variables:
#' \describe{
#'  \item{State}{2-character FIPS code for the state}
#'  \item{County}{2-character FIPS code for the county}
#'  \item{D}{Democratic Party registration}
#'  \item{G}{Green Party registration}
#'  \item{L}{Libertarian Party registration}
#'  \item{N}{No Party / Unaffiliated registration}
#'  \item{O}{Other party registration}
#'  \item{R}{Republican Party registration}
#' }
"PartyRegistration"
