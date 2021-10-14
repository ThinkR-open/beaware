#' user UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_user_ui <- function(id){
  ns <- NS(id)
  tagList(
   selectInput(inputId = ns("users"), label = "Choisir un user", choices = NULL),
   selectInput(inputId = ns("r_versio"), label = "Choisir une version de R", choices = NULL),
   textOutput(ns("sessions")),
   fluidRow(
     h3("Memory info"),
     column(6,
            plotOutput(
              ns("ram_session")
              )
            ),
    column(6,
           plotOutput(
             ns("ram_total")
             )
           )
  ),
  hr(),
  fluidRow(
    h3("CPU info"),
    column(6,
           plotOutput(
             ns("cpu_session")
           )
    )
  )
)
}

#' user Server Functions
#'
#' @noRd
mod_user_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(invalidateLater(2000),{
      info_all <- get_all_info()

      info_ram_total <- get_mem_info()
    })
  })
}

## To be copied in the UI
# mod_user_ui("user_ui_1")

## To be copied in the server
# mod_user_server("user_ui_1")
