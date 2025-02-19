# f_functions for flow work

# get_ziplist ----------------------------------

#' Function to get list of files in given folder
#' @param folder directory to look in
#' @param extension file extension (e.g., "*zip)
#' @return dataframe of files
#' @export
#' @example get_zip_list(glue("{dat_dir}/{subfold_dir}"), "*zip")

get_zip_list <- function(folder, extension){
  library(dplyr)
  library(fs)
  library(glue)
  fs::dir_info(folder, recurse = TRUE,
               type = "file",
               regexp = glue::glue("{extension}")) %>%
    dplyr::select(path, size) %>%
    dplyr::mutate(filename = fs::path_file(path))
}

# comid_filter ----------------------------------

#' Function to filter filter dataset by COMID column
#' @param comids A vector of comids that you want to filter by
#' @param fullpath The full path to the file you want to import
#' @return filtered dataframe
#' @export
#' @example comid_filter(coms, ziplist[1,]$path)

comid_filter <- function(comids, fullpath){
  library(purrr)
  library(vroom)
  f1 <- vroom(fullpath) %>% # fast readin of zips
    dplyr::rename_with(., toupper) %>%
    dplyr::filter({if("COMID" %in% names(.)) COMID else NULL} %in% comids)
}

# comid_writeout ----------------------------------

#' Function to filter filter dataset by COMID column
#' @param data dataframe to write out
#' @param folderOut direct you want to save to
#' @param fileName file name you want to use
#' @return filtered dataframe
#' @export

comid_writeout <- function(data, folderOut, fileName){
  write_csv(data, file = glue("{folderOut}/{fileName}.csv"))
}
