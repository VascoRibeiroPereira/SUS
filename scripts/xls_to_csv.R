xls_to_csv <- function() {
        my_year = readline(prompt="Enter year: ")
        
        ## Libraries
        
        library(dplyr)
        library(lubridate)
        
        ## Get the file names
        xls = dir(path = paste0("../", my_year,"/extratos/OriginaisExcel"), pattern = "xls", full.names = TRUE)
        
        ## Copy files to the "extratos" folder
        file.copy(from=xls, to=paste0("../", my_year,"/extratos"), 
                  overwrite = FALSE, recursive = FALSE, 
                  copy.mode = TRUE)
        
        setwd(paste0("../", my_year,"/extratos"))
        
        ## Get the file names (again)
        xls = dir(pattern = "xls", full.names = TRUE)
        
        ## Change their extension
        newfiles <- gsub(".xls$", ".csv", xls)
        file.rename(xls, newfiles)
        
        ## Get the file names (yet again)
        csv = dir(pattern = "csv", full.names = TRUE)
        
        
        ## Clean all csv files
        for (i in csv) {
                
                myTable = read.csv(i, skip = 8, 
                                   col.names = c("DATA MOV.","DATA VALOR","DESCRIÇÃO","IMPORTÂNCIA","SALDO CONTABILÍSTICO","delete"), 
                                   sep = "\t", encoding = "latin1")
                
                myTable = myTable[,-6]
                
                myTable$DATA.MOV. = myTable$DATA.MOV. %>% as_date()
                myTable$DATA.VALOR = myTable$DATA.VALOR %>% as_date()
                
                myTable$IMPORTÂNCIA = myTable$IMPORTÂNCIA %>% 
                        gsub(pattern = "\\.", replacement = "") %>% 
                        gsub(pattern = ",", replacement = ".") %>% as.numeric()
                
                myTable$SALDO.CONTABILÍSTICO = myTable$SALDO.CONTABILÍSTICO %>% 
                        gsub(pattern = "\\.", replacement = "") %>% 
                        gsub(pattern = ",", replacement = ".") %>% as.numeric()
                
                myTable = myTable[complete.cases(myTable),] %>% tibble()
                
                write.csv2(myTable, i)
                
        }
        
        setwd("../../scripts")
}




## Change the csv file name to something like "done" and remove the trash csv. Compare if theres a done skip the csv processing