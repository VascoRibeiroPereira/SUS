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
                bind_rows(read.xlsx("./2020/tabelas_por_mes/tabelas_Jan_to_Apr.xlsx", sheet = n, detectDates = TRUE))    
}

####################MAY NOW ANALYSING###################

contas2020_JAN_APR <- contas2020_JAN_APR %>% bind_rows(read.xlsx("./2020/tabelas_por_mes/May.xlsx", detectDates = TRUE))


########################################################

contas2020 <- contas2020_JAN_APR

## Correcção do CC ENCARGOS COM INSTALAÇÕES E COLABORADORES

contas2020$CENTRO.DE.CUSTO <- gsub("ENCARGOS COM INSTALAÇÕES", 
                                   "INSTALAÇÕES", contas2020$CENTRO.DE.CUSTO)

contas2020$CENTRO.DE.CUSTO <- gsub("ENCARGOS COM COLABORADORES", 
                                   "INSTALAÇÕES", contas2020$CENTRO.DE.CUSTO)

contas2020$RUBRICA <- gsub("ALIMENTAÇÃO", 
                                   "ENCARGOS COM COLABORADORES", contas2020$RUBRICA)


write.xlsx(contas2020, "./2020/contas2020.xlsx")


### The future
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./2020/tabelas_por_mes/April.xlsx"))
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./2020/tabelas_por_mes/May.xlsx"))
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./2020/tabelas_por_mes/Jun.xlsx"))
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./2020/tabelas_por_mes/Jully.xlsx"))
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./2020/tabelas_por_mes/August.xlsx"))
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./2020/tabelas_por_mes/September.xlsx"))
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./2020/tabelas_por_mes/October.xlsx"))
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./2020/tabelas_por_mes/November.xlsx"))
contas2020 <- contas2020 %>% bind_rows(read.xlsx("./2020/tabelas_por_mes/December.xlsx"))








