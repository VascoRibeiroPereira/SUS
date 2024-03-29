
mensalFunction <- function(currentYear, fileName){

        ## enter the year as is (i.e. 2019, 2020, 2021, ...)
        ## enter the file name with quotes and extention (i.e. "myTest.csv")
        
        
## Carregamento de bibliotecas
library(dplyr)
library(lubridate)
library(stringr)
library(openxlsx)


setwd("/Users/vascoalbertofiliperibeiro/R/SUS/")
        
myYear <- paste(getwd(),currentYear, sep="/")

setwd(myYear)

contasDF <- read.delim(paste("./extratos/", fileName, sep = ""), sep = ";")

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

## Securitas
if (sum(grepl("00026322892", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = ifelse(grepl("00026322892", DESCRIÇÃO), "INSTALAÇÕES", "NA"))
        contasDF <- mutate(contasDF, RUBRICA = ifelse(grepl("00026322892", DESCRIÇÃO), "SECURITAS - ALARME", "NA"))
}

#SMAS
if (sum(grepl("96611566046", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = ifelse(grepl("96611566046", DESCRIÇÃO), "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = ifelse(grepl("96611566046", DESCRIÇÃO), "CONSUMO ÁGUA (SMAS)", RUBRICA))
}

#Imposto de selo e despesas bancárias
if (sum(grepl("I.SELO|COMISSÃO MANUTENÇÃO", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("I.SELO|COMISSÃO MANUTENÇÃO", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("I.SELO|COMISSÃO MANUTENÇÃO", DESCRIÇÃO), "DESP. BANCÁRIAS", RUBRICA))
}

# VODAFONE
if (sum(grepl("00531446107", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("00531446107", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("00531446107", DESCRIÇÃO), "COMUNICAÇÕES", RUBRICA))
}

# MAFEP
if (sum(grepl("10367661", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("10367661", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("10367661", DESCRIÇÃO), "ALUGUER EXTINTORES", RUBRICA))
}


# EDP - CONSUMO ELECTRICIDADE Jesélia e SUS
if (sum(grepl("P05100001520", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("P05100001520", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("P05100001520", DESCRIÇÃO), "CONSUMO ELECTRICIDADE", RUBRICA))
}

# Seguros
if (sum(grepl("11034", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("11034", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("11034", DESCRIÇÃO), "SEGUROS", RUBRICA))
}

# Limpezas
if (sum(grepl("PT50000700000032524109823", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("PT50000700000032524109823", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("PT50000700000032524109823", DESCRIÇÃO), "SERVIÇO DE LIMPEZA", RUBRICA))
}

# Manutenção e Obras Gaspar Fontes
if (sum(grepl("PT50003501810000046033029", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("PT50003501810000046033029", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("PT50003501810000046033029", DESCRIÇÃO), "MANUTENÇÃO/OBRAS", RUBRICA))
}

# SPA
if (sum(grepl("PT50003300000000812850405", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("PT50003300000000812850405", DESCRIÇÃO), 
                                          "NOITE DAS CAMÉLIAS", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("PT50003300000000812850405", DESCRIÇÃO), "IGAC / SPA", RUBRICA))
}

# Gás
if (sum(grepl("PT50003600509910031520496", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("PT50003600509910031520496", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("PT50003600509910031520496", DESCRIÇÃO), "GÁS", RUBRICA))
}

# RENDA RESTAURANTE
if (sum(grepl("JOSE ANTONIO AZEVEDO UNIPES", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("JOSE ANTONIO AZEVEDO UNIPES", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("JOSE ANTONIO AZEVEDO UNIPES", DESCRIÇÃO), "RENDA", RUBRICA))
}

# Adição de factor de mês para separar a tabela
contasDF <- contasDF %>% mutate(Mês = as.factor(month(contasDF$DATA.MOV.)))
contasDF <- contasDF[, c(8, 1:7)] # colocação do factor na coluna inicial


return(write.xlsx(contasDF, file = paste("./tabelas_por_mes/", 
                                         month(month(as.integer(levels(contasDF$Mês))), label = TRUE),".xlsx", sep=""))) ## mudar para 001 002 003 ... 012

}