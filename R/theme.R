#' Theme shiny
#'
#' @return bs_theme
#'
theme_shiny <- function(){
  if(!requireNamespace("bslib")){
    return(NULL)
  }
  bslib::bs_theme( bg = "rgb(232, 231, 231)",
            primary = "#6DA974",
            font_scale = NULL,
            bootswatch = "materia",
            fg = "rgb(0, 0, 0)",
            spacer = "1.5rem")
}
