#' Get processes rsession
#'
#'
#' @return
#' data frame of process rsession
#' @export
#'
#' @importFrom ps ps
#' @importFrom dplyr filter
#' @importFrom stringr str_detect
#' @examples
#' get_process_rsession()
get_process_rsession <- function() {
  ps() %>% 
    filter(str_detect(name , "^rsession$"))
}
