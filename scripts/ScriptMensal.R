
mensalFunction <- function(currentYear, fileName){
        
        ## enter the year as is (i.e. 2019, 2020, 2021, ...)
        ## enter the file name with quotes and extention (i.e. "myTest.csv")
        
        
        ## Carregamento de bibliotecas
        library(dplyr)
        library(lubridate)
        library(stringr)
        library(openxlsx)
        
        
        setwd("~/R/SUS/")
        
        
        ## Carregar tabela com o automatismo - conjunto de códigos de movimentos bancários associados a cc e rubricas
        auto_cc_r <- read.csv("app_sus/auto_cc_r.csv")
        
        myYear <- paste(getwd(),currentYear, sep="/")
        
        setwd(myYear)
        
        contasDF <- read.delim(paste("./extratos/", fileName, sep = ""), sep = ";", 
                               skip = 8)[,1:5]
        
        ## Conversão para formato de data
        contasDF$DATA.MOV. <- ymd(contasDF$DATA.MOV.)
        contasDF$DATA.VALOR <- ymd(contasDF$DATA.VALOR)
        
        ## Correcção da formatação para valores numericos
        contasDF$IMPORTÂNCIA <- contasDF$IMPORTÂNCIA %>% 
                str_replace_all("[.]", "") %>%
                str_replace_all("[,]", ".") %>%
                as.numeric()
        
        ## Correcção da formatação para valores numericos
        contasDF$SALDO.CONTABILÍSTICO <- contasDF$SALDO.CONTABILÍSTICO %>% 
                str_replace_all("[.]", "") %>%
                str_replace_all("[,]", ".") %>%
                as.numeric()
        
        
        ## Adicionar as colunas novas e popular com o automatismo
        
        contasDF$CENTRO.DE.CUSTO <-  NA
        contasDF$RUBRICA <-  NA
        
        for (i in 1:nrow(auto_cc_r)) {
                if (sum(grepl(auto_cc_r$scode[i], contasDF$DESCRIÇÃO)) > 0) {
                        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = ifelse(grepl(auto_cc_r$scode[i], DESCRIÇÃO), auto_cc_r$ccusto[i], CENTRO.DE.CUSTO))
                        contasDF <- mutate(contasDF, RUBRICA = ifelse(grepl(auto_cc_r$scode[i], DESCRIÇÃO), auto_cc_r$rub[i], RUBRICA))
                }
        }
        
        
        # Adição de factor de mês para separar a tabela
        contasDF <- contasDF %>% mutate(Mês = as.factor(month(contasDF$DATA.MOV.)))
        contasDF <- contasDF[, c(8, 1:7)] # colocação do factor na coluna inicial
        
        dir.create("tabelas_por_mes", showWarnings = FALSE)
        
        return(write.xlsx(contasDF, file = paste("./tabelas_por_mes/", letters[as.integer(levels(contasDF$Mês))], "_", 
                                                 month(month(as.integer(levels(contasDF$Mês))), label = TRUE),".xlsx", sep="")))
        
}