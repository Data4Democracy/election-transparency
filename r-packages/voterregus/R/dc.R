#' @import dplyr
#' @import tibble
#' @export
loadDC <- function() {

  # Census counts DC has having only one county.  So easier just to enter this by hand...
  # Source: https://www.dcboee.org/popup.asp?url=/pdf_files/StatRep_31Dec2016.PDF

  df <- data_frame(County="11001", D=366695, R=30086, O=3641+2384, N=79551, G=NA, L=NA) %>%
    mutate_each("as.integer", -County)

  df

}
