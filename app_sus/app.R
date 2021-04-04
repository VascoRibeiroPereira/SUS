source("libs_form.R")


# define some credentials
credentials <- data.frame(
  user = c("sus", "ricardo"), # mandatory
  password = c("test1", "test2"), # mandatory
  start = c(NA), # optional (all others)
  expire = c(NA, NA), # input a date like "2022-12-31"
  admin = c(TRUE, FALSE),
  comment = "Simple and secure authentification mechanism 
  for single ‘Shiny’ applications.",
  stringsAsFactors = FALSE
)

key_set("R-shinymanager-key", "obiwankenobi")

create_db(
  credentials_data = credentials,
  sqlite_path = "database.sqlite", # will be created
  passphrase = key_get("R-shinymanager-key", "obiwankenobi")
  # passphrase = "passphrase_wihtout_keyring"
)

ui <- dashboardPage(
  
  skin = "red",
  
  
  dashboardHeader(title = "Estudo Financeiro SUS"
  ),
  
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Processamento", tabName = "proc", icon = icon("table")),
      menuItem("Instruções", tabName = "instr", icon = icon("question-circle")),
      menuItem(a("Created by Vasco Pereira", href = "https://www.linkedin.com/in/vascoribeirosintra/")),
      menuItem(tags$img(src = "logo.jpeg", height = 92, width = 92, align = "right"))
    )
    
  ),
  
  ## Body content
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "proc",
              fluidRow(
                
                box(
                  fileInput("file1", "Upload de um ficheiro CSV",
                            accept = c(
                              "text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv")
                  ),
                  radioButtons("sep", "Separador", choices = c(";", ","), inline = TRUE),
                  actionButton("gobutton","Start"),
                  downloadButton("downloadData", "Download"),
                ),
                
                box(
                  numericInput("rowsHeader", "Número de Linhas no Cabeçalho", value = 8, min = 0),
                  p(""),
                  p(""),
                  numericInput("nCols", "Número de Colunas", value = 5, min = 1),
                ),
                
                box(
                  dataTableOutput("contents"), width = 12
                )
                
                
                
              )
      ),
      
      # Second tab content
      tabItem(tabName = "instr",
              h2("Instruções desta Ferramenta")
      )
    )
  ),
  useShinyjs()
)

# Wrap your UI with secure_app
ui <- secure_app(ui, enable_admin = TRUE)

server <- function(input, output) {
  
  # check_credentials directly on sqlite db
  res_auth <- secure_server(
    check_credentials = check_credentials(
      "database.sqlite",
      passphrase = key_get("R-shinymanager-key", "obiwankenobi")
      # passphrase = "passphrase_wihtout_keyring"
    )
  )
  
  output$auth_output <- renderPrint({
    reactiveValuesToList(res_auth)
  })
  
  
  data <- eventReactive(input$gobutton,{
    if(is.null(input$file1)){
      return()
    }
    
    inFile <- input$file1
    myDF <- read.csv(inFile$datapath, skip = input$rowsHeader, sep = input$sep)[,1:input$nCols]
    
    
    ## CODE THAT READS AND PERFORMS A TRANSFORMATION TO MY DF - AUTOMATISM
    
    myDF <- mensalFunction(myDF)
    
    
    for (i in 1:nrow(myDF)) {
      
      if (is.na(myDF$CENTRO.DE.CUSTO[i]) ) {
        myDF$CENTRO.DE.CUSTO[i] <- as.character(selectInput(paste0("sel", i), "", choices = CC, width = "100px"))
      }
      
      if (is.na(myDF$RUBRICA[i]) ) {
        myDF$RUBRICA[i] <- as.character(selectInput(paste0("sel2", i), "", choices = CCrub, width = "100px"))
        
      }
    }
    
    myDF
  })
  
  output$contents <- DT::renderDataTable(
    data(), escape = FALSE, selection = 'none', server = FALSE,
    options = list(dom = 't', paging = FALSE, ordering = FALSE),
    callback = JS("table.rows().every(function(i, tab, row) {
        var $this = $(this.node());
        $this.attr('id', this.data()[0]);
        $this.addClass('shiny-input-container');
      });
      Shiny.unbindAll(table.table().node());
      Shiny.bindAll(table.table().node());")
  )
  
  selector_CC <- renderPrint({ ## algo aqui esta a correr mal
    str(sapply(1:nrow(data()), function(i) input[[paste0("sel", i)]]))
  })
  
  selector_R <- renderPrint({ ## algo aqui esta a correr mal
    str(sapply(1:nrow(data()), function(i) input[[paste0("sel2", i)]]))
  })
  
  # Trigger the oberveEvent whenever the value of rv$download_flag changes
  rv <- reactiveValues(download_flag = 0)
  
  observeEvent(rv$download_flag, {
    shinyjs::refresh()
  }, ignoreInit = TRUE)
  
  # Download file
  
  output$downloadData <- downloadHandler(
    
    filename = function() {
      paste0(letters[as.integer(levels(data()$Mês))], "_", 
             month(month(as.integer(levels(data()$Mês))), label = TRUE),".csv")
    },
    
    content = function(file) {
      
      RUBRICA <- unlist(str_extract_all(selector_R(), "[A-Z-Ç Ã Á É Ó Õ - . ( ) /]+")) %>% trimws()
      RUBRICA <- RUBRICA[2:length(RUBRICA)]
      RUBRICA <- RUBRICA[grep("[A-Z]", RUBRICA)]
      
      tmpVector <- grep("NULL", RUBRICA)
      
      for (i in 1:length(tmpVector)){ ## extract auto value and merge it to the selected vector
        RUBRICA[tmpVector[i]] <- data()$RUBRICA[tmpVector[i]]
      }
      
      CENTRO.DE.CUSTO <- unlist(str_extract_all(selector_CC(), "[A-Z-Ç Ã Á É Ó Õ - . ( ) /]+")) %>% trimws()
      CENTRO.DE.CUSTO <- CENTRO.DE.CUSTO[2:length(CENTRO.DE.CUSTO)]
      CENTRO.DE.CUSTO <- CENTRO.DE.CUSTO[grep("[A-Z]", CENTRO.DE.CUSTO)]
      
      tmpVector <- grep("NULL", CENTRO.DE.CUSTO)
      
      for (i in 1:length(tmpVector)){ ## extract auto value and merge it to the selected vector
        CENTRO.DE.CUSTO[tmpVector[i]] <- data()$CENTRO.DE.CUSTO[tmpVector[i]]
      }
      
      finalDF <- bind_cols(data() %>% 
                             select(-CENTRO.DE.CUSTO,-RUBRICA), 
                           CENTRO.DE.CUSTO = CENTRO.DE.CUSTO,
                           RUBRICA = RUBRICA)
      
      write.csv(finalDF, file, row.names = FALSE)
      
      # When the downloadHandler function runs, increment rv$download_flag - trigger the refresh command
      rv$download_flag <- rv$download_flag + 1
    }
  )

}

shinyApp(ui, server)