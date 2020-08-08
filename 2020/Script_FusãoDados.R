## Carregamento de bibliotecas
library(dplyr)
library(lubridate)
library(stringr)
library(openxlsx)

## Extracção dos dados
# dataFiles <- list.files("./2020/tabelas_por_mes", pattern = "xlsx$", full.names = TRUE)

contas2020_JAN_APR <- tibble()

for (n in 1:4){
        contas2020_JAN_APR <- contas2020_JAN_APR %>% 
                bind_rows(read.xlsx("./tabelas_por_mes/tabelas_Jan_to_Apr.xlsx", sheet = n, detectDates = TRUE))    
}

contas2020 <- contas2020_JAN_APR

rm(contas2020_JAN_APR)

## Correcção do CC ENCARGOS COM INSTALAÇÕES E COLABORADORES

contas2020$CENTRO.DE.CUSTO <- gsub("ENCARGOS COM INSTALAÇÕES", 
                                   "INSTALAÇÕES", contas2020$CENTRO.DE.CUSTO)

contas2020$CENTRO.DE.CUSTO <- gsub("ENCARGOS COM COLABORADORES", 
                                   "INSTALAÇÕES", contas2020$CENTRO.DE.CUSTO)

contas2020$RUBRICA <- gsub("ALIMENTAÇÃO", 
                                   "ENCARGOS COM COLABORADORES", contas2020$RUBRICA)


# Merging next months
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./tabelas_por_mes/May.xlsx", detectDates = TRUE))
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./tabelas_por_mes/Jun.xlsx", detectDates = TRUE))
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./tabelas_por_mes/Jul.xlsx", detectDates = TRUE))

# Exportação dos dados completos
write.xlsx(contas2020, "./contas2020.xlsx")

