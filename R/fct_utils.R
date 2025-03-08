# env for app
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
#' @return vector of color
#'
#' @importFrom readr read_csv

color_and_r_version <- function(){

  file <- file.path(Sys.getenv('HOME'),".beaware_colors_r.csv")

  if(file.exists(file)){
    read_csv(file)
  }else{
    update_color_and_r_version()
    read_csv(file)
  }

}

#' Update file of colors and r_version
#'
#' read and write colors.csv file to get color and r_version. This file is inside your home called .beaware_colors_r.csv
#'
#' @param path_file path to home var env
#'
#' @return Nothing, used for this side effect
#' @export
#'
#' @importFrom readr read_csv write_csv
#' @importFrom dplyr bind_rows distinct
#' @importFrom grDevices colors
#'
#' @examples
#' update_color_and_r_version()
update_color_and_r_version <- function(path_file = Sys.getenv('HOME')){

  # if(version != 3){
  #   file <- file.path(path_file,".beaware_colors_r_version_2.rda")
  # }else{
    file <- file.path(path_file,".beaware_colors_r.csv")

  if(!file.exists(file)){
    jcvdm_colors <-  data.frame(r_version = NULL, color = NULL)
  }else{
    jcvdm_colors <- read_csv(file, show_col_types = FALSE)
  }

  r_version <- get_all_r_version()
    new_r_version <- setdiff(r_version, jcvdm_colors$r_version)
    color <- sample(colors()[!grepl(pattern = "seashell", x = colors())], length(new_r_version))
    jcvdm_colors <- data.frame(r_version = new_r_version, color = color) %>%
      bind_rows(jcvdm_colors) %>%
      bind_rows(data.frame(r_version = "Not found", color = "seashell1")) %>%
      distinct()
    write_csv(x = jcvdm_colors, file = file)
}


#' Get installed R versions on system
#'
#' @param path Path to R installed, by default '/opt/R'. You can cahnge this path by set up PATH_TO_R_INSTALLED in your Renviron.
#'
#' @return list of R versions
#'
#' @importFrom stringr str_extract
#' @importFrom attempt attempt
#'
get_all_r_version <- function(path = Sys.getenv("PATH_TO_R_INSTALLED", "/opt/R")){

  if(!dir.exists(path)){
    stop("path doesn't exist, ", path,
         ". Please check where you have install yours R. You may have to set PATH_TO_R_INSTALLED in your Renviron to precise the path where R versions are installed")
  }
  cmd <- paste0("ls ", path)
  liste_r <- attempt(system(cmd, intern = TRUE), msg = paste0("cannot ls ", path, ". Please check rights."))
  liste_r %>%
    str_extract("(.+\\d.\\d.\\d|\\d.\\d.\\d)") %>%
    str_extract("\\d.\\d.\\d") %>%
    unique() %>%
    sort(decreasing = TRUE)
}

#' Get users form system
#'
#' @param data result of get_all_info
#'
#' @return character vector
#'
#' @importFrom stringr str_detect str_extract
#' @importFrom attempt attempt
get_all_users <- function(data){
  # users <- attempt({system("cat /etc/passwd", intern = TRUE)}, msg = "You can not execute 'cat /etc/passwd', please contact your admin.")
  # filtre_users <- users[str_detect(users, "100[:digit:]")]
  # get_users <- str_extract(filtre_users, "[:alpha:]+")
  # get_users %>%
  #   sort()


  sort(unique(data$username))
}



#' clean_vec
#'
#' @param vec vector
#' @param verbose TRUE or FALSE
#' @param unique make it unique
#' @param keep_number keep number
#' @param translit TRUE or FALSE
#' @param punct check punct
#'
#' @importFrom stats ave
#'
clean_vec <- function (vec, verbose = FALSE, unique = TRUE, keep_number = FALSE,
                       translit = TRUE, punct = TRUE){
  old <- vec
  vec <- tolower(vec)
  make_unique <- function (vec, sep = "_") {
    vec[is.na(vec)] <- "NA"
    cs <- ave(vec == vec, vec, FUN = cumsum)
    vec[cs > 1] <- paste(vec[cs > 1], cs[cs > 1], sep = sep)
    vec
  }
  if (unique) {

    vec <- make_unique(vec)
  }
  if (translit) {
    vec <- stringi::stri_trans_general(vec, "latin-ascii")
  }
  if (!keep_number) {
    vec <- make.names(vec)
  }
  if (punct) {
    vec <- vec %>% gsub(perl = TRUE, "[[:punct:]]+", "_",
                        .)
  }
  vec <- vec %>% gsub(perl = TRUE, "[[:space:]]+", "_", .) %>%
    gsub(perl = TRUE, "^_+", "", .) %>% gsub(perl = TRUE,
                                             "_+$", "", .) %>% gsub(perl = TRUE, "_+", "_", .) %>%
    tolower
  if (!keep_number) {
    vec <- make.names(vec)
  }
  if (unique) {
    vec <- make_unique(vec)
  }
  if (verbose) {
    print(data.frame(old = old, new = vec))
  }
  invisible(vec)
}


#' killing process running inside the app
#'
#' @export
#'
killing_app <- function(){
  test <- try(jcvdm$process$is_alive(), silent = TRUE)
  test <- if(inherits(test, "try-error")){FALSE}else{test}
  if(test){
    jcvdm$process$kill()
  }
}

#' Launching app
#'
#' @param path result of path_rscript fct
#'
#' @importFrom processx process
#' @importFrom httpuv randomPort
#'
#' @export
launching_app <- function(path = path_rscript() ){

  message("---Stop app if running---")
  killing_app()
  message("---Starting app---")
  jcvdm$port <- randomPort()
  jcvdm$process <- processx::process$new(
    # stderr = "",
    # stdout = "",
    supervise = TRUE,
    path, c(
      "-e",
      paste0("options(shiny.port=",jcvdm$port,");beaware::run_app_memory()"))
  )
  Sys.sleep(3)
  jcvdm$url <- paste0("http://localhost:",jcvdm$port)
  open_app()
  message("---To kill this app, use killing_app function---")
}

#' Open app
#'
#' @return used for this side effect
#' @export
#'
#' @importFrom utils browseURL
#'
open_app <- function(){
  test <- try(jcvdm$process$is_alive(), silent = TRUE)
  test <- if(inherits(test, "try-error")){FALSE}else{ test }
  if(!test){
    stop("The app is not running")
  }
  browseURL(jcvdm$url)
}


#' Path to rscript
#'
#' @return path to rscript bin
#' @export
#'
#' @examples
#' path_rscript()
path_rscript <- function(){
  path <- Sys.getenv("RSCRIPT_PATH", file.path(R.home(),"bin","Rscript"))
  if(path == ""){
    stop("Please configure RSCRIPT_PATH in your Renviron to add the path to the rscript bin")
  }
  path
}
