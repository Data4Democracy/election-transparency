#' Turnout in French 2017 Presidential Election
#'
#' Data frame of turnout numbers from both rounds of the 2017 presidential election in France.
#'
#' @format A data frame with 71,034 rows and 15 variables:
#' \describe{
#'  \item{Region}{Region Code (INSEE)}
#'  \item{RegionNom}{Region Name}
#'  \item{Departement}{Departement Code (INSEE)}
#'  \item{DepartmentNom}{Department Name}
#'  \item{CommuneCode}{Commune Code (elections)}
#'  \item{CommuneName}{Commune Name (elections)}
#'  \item{CommuneCodeINSEE}{Commune Code (INSEE)}
#'  \item{CommuneNomINSEE}{Commune Name (INSEE)}
#'  \item{Round}{Round 1/2}
#'  \item{Inscrits}{Number of Registered Voters}
#'  \item{Abstentions}{Number of Abstentions}
#'  \item{Votants}{Number of Ballots Cast}
#'  \item{Blancs}{Number of Blank Votes}
#'  \item{Nuls}{Number of Invalid/Null Votes}
#'  \item{Exprimés}{Number of Candidate/Valid Votes}
#' }
"Turnout2017"

#' Results from French 2017 Presidential Election
#'
#' Data frame of results from both rounds of the 2017 presidential election in France.
#'
#' @format A data frame with 461,721 rows and 11 variables:
#' \describe{
#'  \item{Region}{Region Code (INSEE)}
#'  \item{RegionNom}{Region Name}
#'  \item{Departement}{Departement Code (INSEE)}
#'  \item{DepartmentNom}{Department Name}
#'  \item{CommuneCode}{Commune Code (elections)}
#'  \item{CommuneName}{Commune Name (elections)}
#'  \item{CommuneCodeINSEE}{Commune Code (INSEE)}
#'  \item{CommuneNomINSEE}{Commune Name (INSEE)}
#'  \item{Round}{Round 1/2}
#'  \item{Candidate}{Name of candidate}
#'  \item{Votes}{Number of Votes}
#' }
"Results2017"
