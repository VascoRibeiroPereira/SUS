library(dplyr)
library(lubridate)
library(tidyr)
library(openxlsx)


listaSocios <- read.delim("./sócios/Lista de Sócios/Sócios-Tabela 1.csv", sep = ";")

listaSocios <- as_tibble(listaSocios)


## Remoção de sócios anónimos
listaSocios <- listaSocios %>% filter(Nome != "")

## Tratamento da variável Quota
listaSocios$Quota <- as.character(listaSocios$Quota)


listaSocios$Quota[grep("0,50", listaSocios$Quota)] <- "0.50"
listaSocios$Quota[grep("1,00", listaSocios$Quota)] <- "1.00"
listaSocios$Quota <- as.numeric(listaSocios$Quota)
listaSocios$Quota <- replace_na(listaSocios$Quota, 0.5)




## Tratamento Variáveis gerais
listaSocios$Nome <- as.character(listaSocios$Nome)
listaSocios$Morada <- as.character(listaSocios$Morada)
listaSocios$C..Postal <- as.character(listaSocios$C..Postal)
listaSocios$Localidade <- as.character(listaSocios$Localidade)
listaSocios$E.Mail <- as.character(listaSocios$E.Mail)
listaSocios$Telefone <- as.character(listaSocios$Telefone)
listaSocios$Data.Nasc. <- dmy(listaSocios$Data.Nasc.)
listaSocios$Nº.Sócio <- as.numeric(listaSocios$Nº.Sócio)
listaSocios$Observações <- as.character(listaSocios$Observações)
listaSocios$Admissão <- as.integer(listaSocios$Admissão)
listaSocios$Homenagem.25.anos <- listaSocios$Admissão + 25
listaSocios$Homenagem.50.anos <- listaSocios$Admissão + 50


## Adição da idade
listaSocios <- listaSocios %>% mutate(Idade = year(Sys.Date())-year(listaSocios$Data.Nasc.))

## Arranjo da lista por data de admissão
listaSocios <- arrange(listaSocios, Admissão)

## Arranjo do número de Sócio por Data de admissão
        ## NOTA: COMPLETAR DADOS EM FALTA PARA ESTE NUMERO ESTAR BEM AFERIDO

listaSocios$Nº.Sócio <- 1:length(listaSocios$Nº.Sócio)

## Compilação para tabela exterior
write.xlsx(listaSocios, file = "./sócios/listaSocios.xlsx")




