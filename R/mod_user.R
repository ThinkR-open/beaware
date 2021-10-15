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
    selectInput(inputId = ns("r_version"), label = "Choisir une version de R", choices = NULL),
    fluidRow(
      column(6,
             textOutput(ns("sessions_nb"))
      )
    ),
    fluidRow(
      column(6,
             h3("Memory info"),
             plotOutput(
               ns("ram_session")
             )
      ),
      column(6,
             h3("CPU info"),
             plotOutput(
               ns("cpu_session")
             )
      )
    ),
    hr(),
    fluidRow(
      # column(9,
             textOutput(
               ns("ram_total")
             ),
             tableOutput(
               ns("sessions_details")
             )
      # )
    )
  )
}

#' user Server Functions
#'
#' @importFrom dplyr pull filter count select
#' @importFrom stats rnorm
#'
#' @noRd
mod_user_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    local <- reactiveValues()

    invalide <- reactiveTimer(4000)

    observeEvent(invalide(),{

      local$info_all <- get_all_info() %>%
        select(pid, name, username, status, r_version, `%cpu`, `%mem`)

      if(!identical(local$info_all, local$old_data)){
        # TODO revoir reactivité car si get info se met à jour user et session aussi
        users <- local$info_all %>%
          pull_unique(username)

        updateSelectInput(session,
                          inputId = "users",
                          choices = users)

        r_version <- local$info_all %>%
          pull_unique(r_version)

        updateSelectInput(session,
                          inputId = "r_version",
                          choices = c("All", r_version)
        )
        local$invalide <- rnorm(1, 0, 10000)
        local$old_data <- local$info_all
      }

    })

    observeEvent(c(input$users, local$invalide),{

      req(local$info_all)

      local$info_user <- local$info_all %>%
        filter(username == input$users)

    }, priority = -1, ignoreInit = TRUE)

    observeEvent(c(input$r_version,local$invalide),{

      req(local$info_user)

      if(input$r_version == "All"){
        local$info_r_version <- local$info_user
      }else{
        local$info_r_version <- local$info_user %>%
          filter(r_version == input$r_version)
      }

    }, priority = -2, ignoreInit = TRUE)


    output$sessions_nb <- renderText({
      req(local$info_r_version)
      paste0("Nombre de sessions : ", nrow(local$info_r_version))
    })

    output$sessions_details <- renderTable({
      req(local$info_r_version)
      local$info_r_version
    })

    output$ram_session <- renderPlot({
      req(local$info_r_version)
      local$info_r_version %>%
        graph_mem()
    })

    output$ram_total <- renderText({
      local$invalide
      memory <- get_mem_info()
      used <- round(memory$usedmemory/memory$memtotal * 100, 2)
      paste0("Total of memory used: ", used)

    })

    output$cpu_session <- renderPlot({
      req(local$info_r_version)
      local$info_r_version %>%
        graph_cpu()
    })

  })
}

## To be copied in the UI
# mod_user_ui("user_ui_1")

## To be copied in the server
# mod_user_server("user_ui_1")
