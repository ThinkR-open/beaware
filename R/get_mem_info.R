#' Get mem info
#'
#' @return data.frame 
#' @export
#'
#' @importFrom attempt attempt
#' @importFrom stringr str_split str_trim str_extract
#' @importFrom purrr map imap flatten set_names
#' @importFrom thinkr clean_vec
#'
#' @examples
#' get_mem_info()
get_mem_info <- function(){
  process <-  attempt(
    system("cat /proc/meminfo", intern = TRUE), 
    msg = "Cannot get memory info, please chek your rights"
  )
  
  ok <- process  %>% 
  str_split(":") %>% 
  map(str_trim) %>% 
  map(~ {
    c(.x[1],  
      .x[2] %>%
        str_extract("[:digit:]+")
        )
    }) %>% 
  map(~ .x[2] %>% set_names(clean_vec(.x[1]))) %>% 
  flatten() %>% 
  imap(~ as.numeric(.x) / (1024*1024))


data.frame( usedmemory = ok$memtotal - (ok$memfree + (ok$buffers + ok$cached +ok$sreclaimable - ok$shmem)),
            memtotal = ok$memtotal,
            time = Sys.time())
}
