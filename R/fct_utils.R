# env for color
jcvdm <- new.env()


#' Cet unique entry from var
#'
#' @param .data data
#' @param var var to pull
#'
#' @return data.frame
#' @export
#'
#' @importFrom dplyr %>% pull
pull_unique <- function(.data, var){
  .data %>%
    pull({{var}}) %>%
    unique()
}


#' Get colors for r_version
#'
#' @param data data from get_info_all
#'
#' @return vector of color
#'
#' @importFrom dplyr bind_rows
#' @importFrom purrr set_names
color_r_version <- function(data){
  r_version <- data %>%
    pull_unique(r_version)

  if(is.null(jcvdm$colors)){
    color <- sample(colors(), length(r_version))
    jcvdm$colors <- data.frame(r_version = r_version, color = color)
  }else{
    new_r_version <- setdiff(r_version, jcvdm$colors$r_version)
    color <- sample(colors(), length(new_r_version))
    jcvdm$colors <- data.frame(r_version = new_r_version, color = color) %>%
      bind_rows(jcvdm$colors)
  }

  jcvdm$colors$color %>%
    set_names(jcvdm$colors$r_version)
}
