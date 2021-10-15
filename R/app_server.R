#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic

  mod_user_server("user_ui_1")

  observeEvent(input$close,{
    stopApp()
  })
}
