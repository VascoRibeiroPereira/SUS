merge_my_data <- function() {

        my_year = readline(prompt="Enter year: ")
        
        ## Libraries
        library(dplyr)
        library(lubridate)
        
        ## Set directory
        setwd(paste0("./", my_year,"/tabelas_por_mes"))
        
        
        df <- list.files() %>% 
                lapply(read.csv) %>% 
                bind_rows
        
        
        ## Write
        write.csv2(df, file = "merged.csv", row.names = FALSE)
        
        ## Return to Home directory
        setwd("../../")
}