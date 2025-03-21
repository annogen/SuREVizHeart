#-----------------------------------------------------------------------------------------------
# Shiny Application Initialization Script
# Author: Vartika Bisht
# Date: 19.08.2024
#-----------------------------------------------------------------------------------------------
# This script initializes and runs a Shiny application. It specifies directories for application
# and data files, sources the necessary UI and server scripts, defines the UI and server functions,
# and then launches the Shiny app.
#-----------------------------------------------------------------------------------------------

# Max upload 2GB
options(shiny.maxRequestSize = 30 * 1024^2)

# Define directories for application and data
library(here)
appDIR <- here()
dataDIR <- file.path(dirname(appDIR),"data")

#---------------------------------------------------------------------------------------------
# Initial Setup: Load necessary scripts for initializing values
# This script sets up the initial environment and variables for the app's operation.
#---------------------------------------------------------------------------------------------
source(file.path(appDIR, "global.R"), local = TRUE )

#-----------------------------------------------------------------------------------------------
# Initialize Render Memory
# A variable to keep track of render state, ensuring that memory is cleared before each render.
#-----------------------------------------------------------------------------------------------
render_mem <- 0

# Source individual UI component scripts
# Each of these scripts defines a part of the user interface for the Shiny application.
source(file.path(appDIR, "ui", "header.R"), local = TRUE ) # Defines the header of the dashboard
source(file.path(appDIR, "ui", "sidebar.R"), local = TRUE ) # Defines the sidebar of the dashboard
source(file.path(appDIR, "ui", "bodyStyles.R"), local = TRUE ) # Defines custom CSS styles for the body
source(file.path(appDIR, "ui", "queryBox.R"), local = TRUE ) # Defines the query box UI component
source(file.path(appDIR, "ui", "tabContent.R"), local = TRUE ) # Defines the tab content for the dashboard

#-----------------------------------------------------------------------------------------------
# Define UI and Server
# 'defineUI' and 'defineSERVER' functions should be defined in the sourced scripts to set up the
# user interface and server-side functionality.
#-----------------------------------------------------------------------------------------------
ui <- dashboardPage(
    header(), # Call the function to create the dashboard header
    sidebar(), # Call the function to create the dashboard sidebar
    dashboardBody(
        useShinyjs(), # Initialize shinyjs for advanced JavaScript interactions
        useShinyalert(), # Initialize shinyalert for customizable alerts
        bodyStyles(), # Apply custom CSS styles to the dashboard body
        verbatimTextOutput("warning_output"), # Output area for displaying warnings
        queryBox(), # Display the query box UI component
        tabContent() # Display the tab content UI component
    )
)


server <- function(input, output, session) {
    # Define reactive values
    hover_reactive <- reactiveVal()
    chr_value <- reactiveVal(NULL)
    flank_value <- reactiveVal(NULL)
    pos_value <- reactiveVal(NULL)
    variant_view <- reactiveVal(NULL)
    input_pass_test <- reactiveVal(FALSE)
    user_defined_files <- reactiveValues(files = list())

    message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Server started"))

    #---------------------------------------------------------------------------------------------
    # Reactive Value Initialization: Reset 'input_pass_test' at app start or when necessary
    # This observer ensures that the alert confirmation status is reset each time the app starts.
    #---------------------------------------------------------------------------------------------
    observe({
        input_pass_test(FALSE) # Reset alert confirmation status
    })

    message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Initial run: Programmatic button click on app start"))

    #---------------------------------------------------------------------------------------------
    # Initial Run: Programmatic Button Click on App Start
    # This triggers the first iteration of the app by simulating a click on the 'runButton'.
    #---------------------------------------------------------------------------------------------
    session$onFlushed(function() {
        isolate({
            shinyjs::click("runButton") # Programmatically click the 'runButton' on app start
        })
    })

    #---------------------------------------------------------------------------------------------
    # File Input Observation: Monitor and Handle File Inputs
    # This section loads a script to observe and process file inputs when they are provided by the user.
    #---------------------------------------------------------------------------------------------
    source(file.path(appDIR, "server", "handle_file_input.R"), local = TRUE )

    #---------------------------------------------------------------------------------------------
    # Button Click Observation: Monitor 'Run' Button Click and Process Input Data
    # This observer handles the actions that should be taken when the 'runButton' is clicked.
    #---------------------------------------------------------------------------------------------
    observeEvent(input$runButton, {

        message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Observed render button"))

        # Retrieve input values from the UI
        search_query <- input$search_query # Get search query input from the user
        flank <- to_number(input$flank) # Convert flank input to a numeric value

        message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", paste0("Observed search query : ", search_query, " flank : ", flank)))

        # Reformat the search query as needed by the application
        source(file.path(appDIR, "main", "reformat.input.R"), local = TRUE )
        assign("query_snps", query_snps , envir = .GlobalEnv)

        #-------------------------------------------------------------------------------------------
        # Conditional Processing Based on Alert Confirmation
        # Only proceed with processing if the alert has been confirmed, i.e. test passed.
        #-------------------------------------------------------------------------------------------
        if (input_pass_test()) {

        message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Query SNP defined as :"))
        print(query_snps)

        # chekck user defined inputs
        source(file.path(appDIR, "server", "check.user.input.R"), local = TRUE)

        #-------------------------------------------------------------------------------------------
        # Conditional Processing Based on Alert Confirmation
        # Only proceed with processing if the alert has been confirmed, i.e. test passed.
        #-------------------------------------------------------------------------------------------
        if (input_pass_test()) {
            message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Input follows the guidlines. Processing underway. ✅"))
            # Trigger the confetti effect
            shinyjs::runjs("showConfetti();")
            # Show the popup with a rendering message
            showModal(
                modalDialog(
                    title = "Rendering in Progress",
                    tags$div(
                        style = "text-align: center; color: #333;",
                        # First GIF (Loading spinner)
                        tags$img(src = "https://i.gifer.com/ZKZg.gif", height = "100px"),
                        tags$p("Please wait while rendering..."),
                        tags$hr(), # Optional horizontal line for separation

                        # Second GIF or Icon (Scroll Down instruction)
                        tags$div(
                            style = "text-align: center; margin-top: 20px;",
                            tags$img(src = "https://i.gifer.com/UrB4.gif", height = "50px"), # Example scroll-down GIF
                            tags$p("Scroll down to see the results below!")
                        )
                    ),
                    easyClose = FALSE, # Prevent closing by clicking outside
                    footer = NULL # No footer to remove the close button
                )
            )

            # Update reactive values based on input
            chr_value(chr) # Update chromosome value
            flank_value(flank) # Update flank value
            pos_value(pos) # Update position value

            # Source the script that handles the main processing and rendering of plots
            source(file.path(appDIR, "main", "render.process.R"), local = TRUE)
        } else {
            message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Input does not follow the guidlines. Reasons must have been specified above. No processing done. ❌"))
            message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Alert not confirmed. Skipping further processing."))
        }} else {
            message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Input does not follow the guidlines. Reasons must have been specified above. No processing done. ❌"))
            message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Alert not confirmed. Skipping further processing."))
        }
    })

    #---------------------------------------------------------------------------------------------
    # Plot Click Observation: Handle User Clicks on Plots
    # This observer tracks clicks on the plot and updates the reactive values accordingly.
    #---------------------------------------------------------------------------------------------
    observe({
        click_data_val <- event_data("plotly_click") # Retrieve data from the plot click event

        # Determine if the clicked data point requires updating the render memory
        new_render_mem <- ifelse(is.null(click_data_val), "0", click_data_val$x)

        # Only proceed if there is a change in the render memory
        if (render_mem != new_render_mem) {
            render_mem <<- new_render_mem # Update the global render memory

            #-----------------------------------------------------------------------------------------
            # Validate Click and Update Plot Parameters
            # Proceed if a valid plot point is clicked and render memory is updated.
            #-----------------------------------------------------------------------------------------
            if (!is.null(click_data_val) && render_mem != 0 && !is.integer(click_data_val$y)) {
                # Access current chromosome and flank values
                chr <- chr_value()
                flank <- flank_value()

                # Extract the position of the clicked point
                new_pos <- click_data_val$x

                # Update the position value based on the clicked point
                pos_value(new_pos)

                # Recalculate position range for plotting
                pos <- new_pos
                pos1 <- pos - flank
                pos2 <- pos + flank

                # Update the search query with the new position
                search_query <- paste0(chr, ":", pos)

                # Reset click data and user response
                hover_reactive(NULL)
                click_data_val <- NULL

                #---------------------------------------------------------------------------------------
                # User Confirmation Dialog: Confirm Plot Update
                # Display a confirmation dialog to the user before proceeding with plot updates.
                #---------------------------------------------------------------------------------------
                shinyalert::shinyalert(
                    title = "Plotting the selected SNP",
                    text = paste0("Make new plots for selected position \n", chr, ":", new_pos),
                    type = "info",
                    showCancelButton = TRUE,
                    cancelButtonText = "No",
                    confirmButtonText = "Yes",
                    callbackR = function(x) {
                        # x contains the user's response (TRUE for Yes, FALSE for No)
                        if (x) {
                            # Check if the new updated files are all valid
                            source(file.path(appDIR, "server", "check.user.input.R"), local = TRUE)
                            if (input_pass_test()) {
                                # Update the textInput with the new search_query value
                                updateTextInput(session, "search_query", value = search_query)
                                # Trigger the confetti effect
                                shinyjs::runjs("showConfetti();")
                                # Show the popup with a rendering message
                                showModal(
                                    modalDialog(
                                        title = "Rendering in Progress",
                                        tags$div(
                                            style = "text-align: center; color: #333;",
                                            # First GIF (Loading spinner)
                                            tags$img(src = "https://i.gifer.com/ZKZg.gif", height = "100px"),
                                            tags$p("Please wait while rendering..."),
                                            tags$hr(), # Optional horizontal line for separation

                                            # Second GIF or Icon (Scroll Down instruction)
                                            tags$div(
                                                style = "text-align: center; margin-top: 20px;",
                                                tags$img(src = "https://i.gifer.com/UrB4.gif", height = "50px"), # Example scroll-down GIF
                                                tags$p("Scroll down to see the results below!")
                                            )
                                        ),
                                        easyClose = FALSE, # Prevent closing by clicking outside
                                        footer = NULL # No footer to remove the close button
                                    )
                                )

                                # User confirmed to proceed with plotting
                                message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", paste0("Valid click. Captured search query : ", search_query, " flank : ", flank)))
                                # Reformat the search query as needed by the application
                                source(file.path(appDIR, "main", "reformat.input.R"), local = TRUE)
                                assign("query_snps", query_snps, envir = .GlobalEnv)
                                message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Query SNP defined as :"))
                                print(query_snps)
                                # Source the script that handles the main processing and rendering of plots
                                source(file.path(appDIR, "main", "render.process.R"), local = TRUE)
                            } else {
                                message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Input does not follow the guidlines. Reasons must have been specified above. No processing done. ❌"))
                                message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Alert not confirmed. Skipping further processing."))
                            }
                        } else {
                            message(paste(format(Sys.time(), "%d/%m/%Y %H:%M:%S"), ":", "Invalid click. User selected 'No, Do not proceed with plotting'."))
                            # User opted not to proceed with the plotting
                            cat("User selected 'No, Do not proceed with plotting'.\n")
                            # Source the script for handling the download of output data
                            source(file.path(appDIR, "main", "downloadData.R"), local = TRUE)
                        }
                    }
                )
            }
        }
    })

}



#-----------------------------------------------------------------------------------------------
# Run the Shiny Application
# Launch the Shiny app using the defined UI and server functions.
#-----------------------------------------------------------------------------------------------
shinyApp(ui, server) # Start the Shiny app with the specified UI and server components
