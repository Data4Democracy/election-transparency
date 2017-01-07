# Script to export dataframe to package

dfs <- list(
  voterregus::loadAlaska(),
  voterregus::loadArizona(),
  voterregus::loadCalifornia(),
  voterregus::loadConnecticut()
)

PartyRegistration <- dplyr::select(dplyr::mutate(dplyr::bind_rows(dfs), State=substr(County, 1, 2)), State, County, D, G, L, N, O, R)
devtools::use_data(PartyRegistration, overwrite=TRUE)
