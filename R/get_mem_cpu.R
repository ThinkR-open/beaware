#' Get cpu and mem info
#'
#'
#' @return
#' data frame of process rsession
#' @export
#'
#' @importFrom attempt attempt
#' @importFrom dplyr mutate_at
#' @importFrom purrr map_df set_names
#' @importFrom stringr str_replace_all str_trim str_split
#' @examples
#' get_mem_cpu()
get_mem_cpu <- function(){
  process <-  attempt(
    system("ps -C rsession -o 'pid,%cpu,%mem'", intern = TRUE), 
    msg = "Cannot run ps command in terminal, please chek your rights"
  )
  
  result_process <- process %>% 
    str_replace_all("\\s+", " ") %>%
    str_trim() %>% 
    str_split(" ") 
  
  
  map_df(
    result_process[-1],
    ~ set_names(.x, tolower(result_process[[1]]))
  ) %>% 
    mutate_at(c("pid", "%mem", "%cpu"), as.numeric)
}
