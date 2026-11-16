
# ============================================================
# PUNE REAL ESTATE PRICE PREDICTION SYSTEM
# Complete Interactive Machine Learning Dashboard
# Developed using R, Shiny and Machine Learning
# ============================================================

# 1. LOAD LIBRARIES
# ============================================================

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)

# ============================================================
# 2. LOAD TRAINED MODEL AND DATA
# ============================================================

model_bundle <- readRDS("house_price_model_bundle.rds")

model <- model_bundle$model
model_name <- model_bundle$model_name
locations <- model_bundle$locations
location_levels <- model_bundle$location_levels
x_columns <- model_bundle$x_columns

property_data <- model_bundle$dataset
model_comparison <- model_bundle$model_comparison

# Validate required data

required_columns <- c(
  "location",
  "size",
  "total_sqft",
  "bath",
  "balcony",
  "price"
)

if (!all(required_columns %in% names(property_data))) {
  stop("The saved dataset is missing required columns.")
}

if (is.null(model) || is.null(model_comparison)) {
  stop("The trained model or comparison table is missing.")
}

# Identify model type

is_svm <- inherits(model, "svm")
is_rf <- inherits(model, "randomForest")
is_lm <- inherits(model, "lm")
is_tree <- inherits(model, "rpart")

if (!is_svm && !is_rf && !is_lm && !is_tree) {
  stop("Unsupported trained model type.")
}

# ============================================================
# 3. USER INTERFACE
# ============================================================

ui <- dashboardPage(
  
  skin = "blue",
  
  dashboardHeader(
    title = "Pune Property Predictor",
    titleWidth = 300
  ),
  
  dashboardSidebar(
    
    width = 260,
    
    sidebarMenu(
      
      menuItem(
        "Overview",
        tabName = "overview",
        icon = icon("dashboard")
      ),
      
      menuItem(
        "Predict Price",
        tabName = "predict",
        icon = icon("calculator")
      ),
      
      menuItem(
        "Model Performance",
        tabName = "models",
        icon = icon("bar-chart")
      ),
      
      menuItem(
        "Prediction History",
        tabName = "history",
        icon = icon("history")
      )
      
    )
  ),
  
  dashboardBody(
    
    tags$head(
      
      tags$style(HTML("

        .content-wrapper {
          background-color: #f4f6f9;
        }

        .main-header .logo {
          font-weight: bold;
        }

        .box {
          border-radius: 9px;
        }

        .big-price {
          color: #15803d;
          font-size: 36px;
          font-weight: bold;
          text-align: center;
          padding: 25px;
        }

        .section-description {
          color: #64748b;
          font-size: 14px;
        }

        .main-footer {
          background-color: white;
        }

      "))
      
    ),
    
    tabItems(
      
      # ==================================================
      # TAB 1: OVERVIEW
      # ==================================================
      
      tabItem(
        
        tabName = "overview",
        
        h2("Pune Real Estate Analytics"),
        
        p(
          class = "section-description",
          "Machine Learning Based Property Price Analysis System"
        ),
        
        fluidRow(
          
          valueBoxOutput(
            "total_properties",
            width = 4
          ),
          
          valueBoxOutput(
            "average_price",
            width = 4
          ),
          
          valueBoxOutput(
            "average_area",
            width = 4
          )
          
        ),
        
        fluidRow(
          
          box(
            
            title = "Property Price Distribution",
            
            status = "primary",
            solidHeader = TRUE,
            
            width = 6,
            
            plotOutput(
              "price_distribution",
              height = 300
            )
            
          ),
          
          box(
            
            title = "Top 10 Locations by Average Price",
            
            status = "primary",
            solidHeader = TRUE,
            
            width = 6,
            
            plotOutput(
              "location_chart",
              height = 300
            )
            
          )
          
        ),
        
        fluidRow(
          
          box(
            
            title = "Dataset Information",
            
            status = "info",
            solidHeader = TRUE,
            
            width = 12,
            
            tableOutput("dataset_summary")
            
          )
          
        )
        
      ),
      
      # ==================================================
      # TAB 2: PREDICT PRICE
      # ==================================================
      
      tabItem(
        
        tabName = "predict",
        
        h2("Predict Your Property Price"),
        
        fluidRow(
          
          box(
            
            title = "Enter Property Details",
            
            status = "primary",
            solidHeader = TRUE,
            
            width = 5,
            
            selectInput(
              
              "location",
              
              "Select Property Location",
              
              choices = locations,
              
              selected = locations[1]
              
            ),
            
            numericInput(
              
              "size",
              
              "Number of BHK",
              
              value = 2,
              
              min = 1,
              max = 10,
              step = 1
              
            ),
            
            numericInput(
              
              "total_sqft",
              
              "Total Area (Square Feet)",
              
              value = 1200,
              
              min = 100,
              max = 50000
              
            ),
            
            numericInput(
              
              "bath",
              
              "Number of Bathrooms",
              
              value = 2,
              
              min = 1,
              max = 15,
              step = 1
              
            ),
            
            numericInput(
              
              "balcony",
              
              "Number of Balconies",
              
              value = 1,
              
              min = 0,
              max = 10,
              step = 1
              
            ),
            
            br(),
            
            actionButton(
              
              "predict",
              
              "Predict Property Price",
              
              icon = icon("calculator"),
              
              class = "btn-primary",
              
              width = "100%"
              
            ),
            
            br(),
            br(),
            
            actionButton(
              
              "clear",
              
              "Clear Inputs",
              
              class = "btn-default",
              
              width = "100%"
              
            )
            
          ),
          
          box(
            
            title = "Prediction Results",
            
            status = "success",
            solidHeader = TRUE,
            
            width = 7,
            
            uiOutput("price_output"),
            
            hr(),
            
            h4("Property Summary"),
            
            tableOutput("property_summary"),
            
            br(),
            
            strong(
              textOutput("prediction_model")
            ),
            
            br(),
            
            p(
              
              class = "section-description",
              
              "Note: This is an estimated property price ",
              "generated using historical property data. ",
              "Actual market prices may vary."
              
            )
            
          )
          
        )
        
      ),
      
      # ==================================================
      # TAB 3: MODEL PERFORMANCE
      # ==================================================
      
      tabItem(
        
        tabName = "models",
        
        h2("Machine Learning Model Comparison"),
        
        p(
          class = "section-description",
          "Comparison of four machine learning algorithms"
        ),
        
        fluidRow(
          
          box(
            
            title = "Model Performance Table",
            
            status = "primary",
            solidHeader = TRUE,
            
            width = 12,
            
            tableOutput("model_table")
            
          )
          
        ),
        
        fluidRow(
          
          box(
            
            title = "R-Squared Comparison",
            
            status = "primary",
            solidHeader = TRUE,
            
            width = 6,
            
            plotOutput(
              "r2_chart",
              height = 320
            )
            
          ),
          
          box(
            
            title = "RMSE Comparison",
            
            status = "primary",
            solidHeader = TRUE,
            
            width = 6,
            
            plotOutput(
              "rmse_chart",
              height = 320
            )
            
          )
          
        ),
        
        fluidRow(
          
          valueBoxOutput(
            "best_algorithm",
            width = 12
          )
          
        )
        
      ),
      
      # ==================================================
      # TAB 4: PREDICTION HISTORY
      # ==================================================
      
      tabItem(
        
        tabName = "history",
        
        h2("Prediction History"),
        
        p(
          class = "section-description",
          "View property predictions made during the current session."
        ),
        
        fluidRow(
          
          box(
            
            title = "Previous Predictions",
            
            status = "primary",
            solidHeader = TRUE,
            
            width = 12,
            
            tableOutput("history_table"),
            
            br(),
            
            actionButton(
              
              "clear_history",
              
              "Clear Prediction History",
              
              class = "btn-danger"
              
            )
            
          )
          
        )
        
      )
      
    ),
    
    tags$footer(
      
      style = "
        text-align:center;
        padding:15px;
        color:#777;
      ",
      
      "Pune Real Estate Price Prediction System | ",
      "Machine Learning Project"
      
    )
    
  )
)

# ============================================================
# 4. SERVER
# ============================================================

server <- function(input, output, session) {
  
  # ----------------------------------------------------------
  # PREDICTION HISTORY
  # ----------------------------------------------------------
  
  history_data <- reactiveVal(
    
    data.frame(
      
      Date = character(),
      
      Location = character(),
      
      BHK = integer(),
      
      Area = numeric(),
      
      Predicted_Price = numeric()
      
    )
    
  )
  
  latest_prediction <- reactiveVal(NULL)
  
  # ----------------------------------------------------------
  # OVERVIEW: TOTAL PROPERTIES
  # ----------------------------------------------------------
  
  output$total_properties <- renderValueBox({
    
    valueBox(
      
      format(
        nrow(property_data),
        big.mark = ","
      ),
      
      "Properties Analysed",
      
      icon = icon("building"),
      
      color = "blue"
      
    )
    
  })
  
  # ----------------------------------------------------------
  # OVERVIEW: AVERAGE PRICE
  # ----------------------------------------------------------
  
  output$average_price <- renderValueBox({
    
    valueBox(
      
      paste0(
        "Rs. ",
        round(
          mean(property_data$price, na.rm = TRUE),
          2
        ),
        " Lakhs"
      ),
      
      "Average Property Price",
      
      icon = icon("money-bill"),
      
      color = "green"
      
    )
    
  })
  
  # ----------------------------------------------------------
  # OVERVIEW: AVERAGE AREA
  # ----------------------------------------------------------
  
  output$average_area <- renderValueBox({
    
    valueBox(
      
      paste0(
        round(
          mean(property_data$total_sqft, na.rm = TRUE)
        ),
        " sqft"
      ),
      
      "Average Property Area",
      
      icon = icon("ruler-combined"),
      
      color = "yellow"
      
    )
    
  })
  
  # ----------------------------------------------------------
  # PRICE DISTRIBUTION GRAPH
  # ----------------------------------------------------------
  
  output$price_distribution <- renderPlot({
    
    ggplot(
      property_data,
      aes(x = price)
    ) +
      
      geom_histogram(
        
        bins = 30,
        
        fill = "steelblue",
        
        color = "white"
        
      ) +
      
      labs(
        
        title = "Distribution of Property Prices",
        
        x = "Price (Lakhs)",
        
        y = "Number of Properties"
        
      ) +
      
      theme_minimal()
    
  })
  
  # ----------------------------------------------------------
  # TOP 10 LOCATIONS
  # ----------------------------------------------------------
  
  output$location_chart <- renderPlot({
    
    location_data <- property_data %>%
      
      group_by(location) %>%
      
      summarise(
        
        average_price = mean(
          price,
          na.rm = TRUE
        ),
        
        .groups = "drop"
        
      ) %>%
      
      arrange(
        desc(average_price)
      ) %>%
      
      slice_head(n = 10)
    
    ggplot(
      
      location_data,
      
      aes(
        
        x = reorder(location, average_price),
        
        y = average_price
        
      )
      
    ) +
      
      geom_col(
        fill = "steelblue"
      ) +
      
      coord_flip() +
      
      labs(
        
        x = "Location",
        
        y = "Average Price (Lakhs)"
        
      ) +
      
      theme_minimal()
    
  })
  
  # ----------------------------------------------------------
  # DATASET SUMMARY
  # ----------------------------------------------------------
  
  output$dataset_summary <- renderTable({
    
    data.frame(
      
      Metric = c(
        
        "Total Properties",
        
        "Unique Locations",
        
        "Average Price (Lakhs)",
        
        "Minimum Price (Lakhs)",
        
        "Maximum Price (Lakhs)",
        
        "Average Area (sqft)"
        
      ),
      
      Value = c(
        
        nrow(property_data),
        
        length(unique(property_data$location)),
        
        round(
          mean(property_data$price, na.rm = TRUE),
          2
        ),
        
        round(
          min(property_data$price, na.rm = TRUE),
          2
        ),
        
        round(
          max(property_data$price, na.rm = TRUE),
          2
        ),
        
        round(
          mean(property_data$total_sqft, na.rm = TRUE),
          2
        )
        
      )
      
    )
    
  })
  
  # ==========================================================
  # PREDICTION ENGINE
  # ==========================================================
  
  observeEvent(input$predict, {
    
    tryCatch({
      
      req(input$location)
      
      # Validate input values
      
      validate(
        
        need(
          is.finite(input$size) &&
            input$size >= 1 &&
            input$size <= 10 &&
            input$size == floor(input$size),
          "Enter a valid BHK value."
        ),
        
        need(
          is.finite(input$total_sqft) &&
            input$total_sqft >= 100 &&
            input$total_sqft <= 50000,
          "Enter a valid property area."
        ),
        
        need(
          is.finite(input$bath) &&
            input$bath >= 1 &&
            input$bath <= 15 &&
            input$bath == floor(input$bath),
          "Enter a valid bathroom count."
        ),
        
        need(
          is.finite(input$balcony) &&
            input$balcony >= 0 &&
            input$balcony <= 10 &&
            input$balcony == floor(input$balcony),
          "Enter a valid balcony count."
        )
        
      )
      
      # Create prediction input data
      
      new_property <- data.frame(
        
        location = factor(
          
          input$location,
          
          levels = location_levels
          
        ),
        
        size = as.integer(input$size),
        
        total_sqft = as.numeric(input$total_sqft),
        
        bath = as.integer(input$bath),
        
        balcony = as.integer(input$balcony)
        
      )
      
      # Check location compatibility
      
      if (is.na(new_property$location)) {
        
        stop(
          "Selected location is not supported by the model."
        )
        
      }
      
      # ------------------------------------------------------
      # SVM AND RANDOM FOREST
      # ------------------------------------------------------
      
      if (is_svm || is_rf) {
        
        # Generate numeric feature matrix
        
        new_x <- model.matrix(
          
          ~ location + size + total_sqft + bath + balcony,
          
          data = new_property
          
        )[, -1, drop = FALSE]
        
        # Align columns with the original training matrix
        
        if (
          is.null(x_columns) ||
          length(x_columns) == 0
        ) {
          
          stop(
            "Training feature names are missing from the model bundle."
          )
          
        }
        
        aligned_x <- matrix(
          
          0,
          
          nrow = 1,
          
          ncol = length(x_columns),
          
          dimnames = list(
            NULL,
            x_columns
          )
          
        )
        
        common_columns <- intersect(
          
          x_columns,
          
          colnames(new_x)
          
        )
        
        aligned_x[, common_columns] <-
          new_x[, common_columns, drop = FALSE]
        
        # Generate prediction
        
        predicted_price <- predict(
          
          model,
          
          newdata = aligned_x
          
        )
        
      } else {
        
        # LINEAR REGRESSION OR DECISION TREE
        
        predicted_price <- predict(
          
          model,
          
          newdata = new_property
          
        )
        
      }
      
      predicted_price <- as.numeric(predicted_price)
      
      # Validate prediction result
      
      if (
        length(predicted_price) != 1 ||
        !is.finite(predicted_price) ||
        predicted_price <= 0
      ) {
        
        stop(
          "The model returned an invalid price. Try different property details."
        )
        
      }
      
      # Store latest prediction
      
      latest_prediction(
        
        list(
          
          price = predicted_price,
          
          details = new_property
          
        )
        
      )
      
      # Add prediction to history
      
      new_record <- data.frame(
        
        Date = format(
          Sys.time(),
          "%d-%m-%Y %H:%M"
        ),
        
        Location = input$location,
        
        BHK = as.integer(input$size),
        
        Area = as.numeric(input$total_sqft),
        
        Predicted_Price = round(
          predicted_price,
          2
        )
        
      )
      
      history_data(
        
        rbind(
          history_data(),
          new_record
        )
        
      )
      
      showNotification(
        
        "Property price predicted successfully!",
        
        type = "message"
        
      )
      
    }, error = function(e) {
      
      showNotification(
        
        conditionMessage(e),
        
        type = "error",
        
        duration = 8
        
      )
      
    })
    
  })
  
  # ==========================================================
  # DISPLAY PREDICTION
  # ==========================================================
  
  output$price_output <- renderUI({
    
    result <- latest_prediction()
    
    if (is.null(result)) {
      
      return(
        
        h4(
          "Enter property details and click Predict."
        )
        
      )
      
    }
    
    div(
      
      class = "big-price",
      
      paste0(
        
        "Rs. ",
        
        round(result$price, 2),
        
        " Lakhs"
        
      )
      
    )
    
  })
  
  # ----------------------------------------------------------
  # PROPERTY SUMMARY
  # ----------------------------------------------------------
  
  output$property_summary <- renderTable({
    
    result <- latest_prediction()
    
    if (is.null(result)) {
      return(NULL)
    }
    
    data.frame(
      
      Feature = c(
        
        "Location",
        
        "BHK",
        
        "Total Area",
        
        "Bathrooms",
        
        "Balconies"
        
      ),
      
      Value = c(
        
        as.character(
          result$details$location
        ),
        
        result$details$size,
        
        paste(
          result$details$total_sqft,
          "sqft"
        ),
        
        result$details$bath,
        
        result$details$balcony
        
      )
      
    )
    
  }, striped = TRUE, bordered = TRUE)
  
  # ----------------------------------------------------------
  # MODEL USED FOR PREDICTION
  # ----------------------------------------------------------
  
  output$prediction_model <- renderText({
    
    paste(
      "Machine Learning Algorithm:",
      model_name
    )
    
  })
  
  # ==========================================================
  # CLEAR INPUTS
  # ==========================================================
  
  observeEvent(input$clear, {
    
    updateSelectInput(
      
      session,
      
      "location",
      
      selected = locations[1]
      
    )
    
    updateNumericInput(
      session,
      "size",
      value = 2
    )
    
    updateNumericInput(
      session,
      "total_sqft",
      value = 1200
    )
    
    updateNumericInput(
      session,
      "bath",
      value = 2
    )
    
    updateNumericInput(
      session,
      "balcony",
      value = 1
    )
    
    latest_prediction(NULL)
    
  })
  
  # ==========================================================
  # MODEL PERFORMANCE TABLE
  # ==========================================================
  
  output$model_table <- renderTable({
    
    model_comparison
    
  }, striped = TRUE, bordered = TRUE)
  
  # ----------------------------------------------------------
  # R-SQUARED GRAPH
  # ----------------------------------------------------------
  
  output$r2_chart <- renderPlot({
    
    ggplot(
      
      model_comparison,
      
      aes(
        
        x = reorder(Model, R2),
        
        y = R2
        
      )
      
    ) +
      
      geom_col(
        fill = "steelblue"
      ) +
      
      coord_flip() +
      
      labs(
        
        title = "R-Squared Comparison",
        
        x = "Algorithm",
        
        y = "R-Squared"
        
      ) +
      
      theme_minimal()
    
  })
  
  # ----------------------------------------------------------
  # RMSE GRAPH
  # ----------------------------------------------------------
  
  output$rmse_chart <- renderPlot({
    
    ggplot(
      
      model_comparison,
      
      aes(
        
        x = reorder(Model, RMSE),
        
        y = RMSE
        
      )
      
    ) +
      
      geom_col(
        fill = "darkorange"
      ) +
      
      coord_flip() +
      
      labs(
        
        title = "RMSE Comparison",
        
        x = "Algorithm",
        
        y = "RMSE (Lakhs)"
        
      ) +
      
      theme_minimal()
    
  })
  
  # ----------------------------------------------------------
  # BEST MODEL
  # ----------------------------------------------------------
  
  output$best_algorithm <- renderValueBox({
    
    valueBox(
      
      model_name,
      
      "Best Performing Model (Lowest RMSE)",
      
      icon = icon("trophy"),
      
      color = "green"
      
    )
    
  })
  
  # ==========================================================
  # PREDICTION HISTORY
  # ==========================================================
  
  output$history_table <- renderTable({
    
    history_data()
    
  }, striped = TRUE, bordered = TRUE)
  
  # ----------------------------------------------------------
  # CLEAR HISTORY
  # ----------------------------------------------------------
  
  observeEvent(input$clear_history, {
    
    history_data(
      
      data.frame(
        
        Date = character(),
        
        Location = character(),
        
        BHK = integer(),
        
        Area = numeric(),
        
        Predicted_Price = numeric()
        
      )
      
    )
    
    showNotification(
      
      "Prediction history cleared successfully.",
      
      type = "message"
      
    )
    
  })
  
}

# ============================================================
# 5. LAUNCH APPLICATION
# ============================================================

shinyApp(
  
  ui = ui,
  
  server = server
  
)
