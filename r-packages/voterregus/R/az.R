#' @import dplyr
#' @importFrom readr read_delim read_lines
#' @export

loadArizona <- function() {
  file_list <- lapply(list.files("data-raw/az", full.names = TRUE), list.files, full.names = TRUE)

  df <- NULL
  for (item in 1:length(file_list)){
    for (file in 1:length(file_list[[item]])){
      year <- format(as.Date(regmatches(file_list[[item]][file], regexpr("[0-9].*[0-9]", file_list[[item]][file])), format="%Y-%m-%d"), "%Y")
      month <- format(as.Date(regmatches(file_list[[item]][file], regexpr("[0-9].*[0-9]", file_list[[item]][file])), format="%Y-%m-%d"), "%m")

      if (item == 1){
        lines <- read_lines(file_list[[item]][file])
        filteredLines <- character()

        readFirstDistrict <- FALSE
        readLastDistrict <- FALSE

        for (line in lines) {

          readFirstDistrict <- readFirstDistrict | grepl(x=line, pattern="Congressional District 1")

          if (readFirstDistrict & !readLastDistrict) {

            if (!grepl(x=line, pattern="Congressional District|TOTALS")) {
              filteredLines <- c(filteredLines, line)
            }

          }

          readLastDistrict <- readLastDistrict | grepl(x=line, pattern="STATE TOTALS")

        }

        countyNameFIPSMapping <- getCountyNameFIPSMapping('04')

        columnCounts <- c(12, 12, 13, 12)

        df_temp <- read_delim(paste(filteredLines, collapse="\n"), delim=",", col_names=paste0('X', seq(columnCounts[file])),
                              col_types=paste(rep('c', columnCounts[file]), collapse='')) %>%
          select(CountyName=X4, D=X6, G=X8, L=X9, R=X10, O=X11) %>%
          mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
          mutate_each("as.integer", -CountyName) %>%
          group_by(CountyName) %>%
          summarize_each(funs(sum(., na.rm=TRUE))) %>%
          ungroup() %>%
          inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
          select(-CountyName) %>%
          mutate(Year = as.numeric(year), Month = as.numeric(month))

        df <- df %>% bind_rows(df_temp)
      } else if(item == 2) {

        lines <- read_lines(file_list[[item]][file], skip=5, n_max=45)

        countyNameFIPSMapping <- getCountyNameFIPSMapping('04')

        df_temp <- read_delim(paste(lines, collapse="\n"), delim=",", col_names=paste0('X', 1:11), col_types="ccccccccccc") %>%
          select(CountyName=X2, D=X5, G=X7, L=X8, R=X9, O=X10, filt=4) %>%
          mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
          mutate_each("as.integer", -CountyName, -filt) %>%
          filter(filt == "16-May") %>%
          select(-filt) %>%
          inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
          select(-CountyName) %>%
          mutate(Year = as.numeric(year), Month = as.numeric(month))

        df <- df %>% bind_rows(df_temp)
      } else if (item == 3){
        lines <- read_lines(file_list[[item]][file])
        filteredLines <- character()

        readFirstDistrict <- FALSE
        readLastDistrict <- FALSE

        for (line in lines) {

          readFirstDistrict <- readFirstDistrict | grepl(x=line, pattern="Congressional District 1")

          if (readFirstDistrict & !readLastDistrict) {

            if (!grepl(x=line, pattern="Congressional District|TOTALS")) {
              filteredLines <- c(filteredLines, line)
            }

          }

          readLastDistrict <- readLastDistrict | grepl(x=line, pattern="STATE TOTALS")

        }

        countyNameFIPSMapping <- getCountyNameFIPSMapping('04')

        df_temp <- read_delim(paste(filteredLines, collapse="\n"), delim=",", col_names=paste0('X', 1:13), col_types="ccccccccccccc") %>%
          select(CountyName=X1, O1=X4, D=X5, G=X6, L=X7, R=X8, O2=X9) %>%
          mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
          mutate_each(funs(gsub(x=., pattern="^\\s+", replacement=""))) %>%
          mutate_each("as.integer", -CountyName) %>%
          mutate(O=O1+O2) %>%
          select(-O1, -O2) %>%
          group_by(CountyName) %>%
          summarize_each(funs(sum(., na.rm=TRUE))) %>%
          ungroup() %>%
          filter(!is.na(CountyName)) %>%
          inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
          select(-CountyName) %>%
          mutate(Year = as.numeric(year), Month = as.numeric(month))

        df <- df %>% bind_rows(df_temp)
      }
    }
  }
  df
}

