# Tratamento de dados mensal

1.  Entrar no site Montepio  
2.  Contas à Ordem  
3.  Movimentos  
4.  Pesquisa de Movimentos  
5.  Selecionar do dia 1 ao último dia do mês em análise  
6.  Consultar  
7.  Carregar no simbolo de download (descarrega um `.xls`)  
8.  Colocar o ficheiro na pasta **/ano/extratos/OriginaisExcel**  
9.  Com software Numbers ou outro, guardar o documento como `.csv` na
    pasta **/ano/extratos**  
10. Abrir e correr o script “ScriptMensal.R”  
11. Correr a função descrita no script:
    `mensalFunction(currentYear, fileName)`

### Listas de tarefas

1.  Criar rubricas detalhadas no cc Noite das Camélias - por exemplo:
    Artigos Decorativos; Rama; Camélia; Cenário

2.  Construir uma Shinny App para automatizar todo este processo sem
    necessidade de skills de programação

# Repositório da tesouraria da SUS

Este repositório serve para tratamento dos dados e gerar relatórios de
contas a apresentar nas reuniões de direção e na Assembleia.

# Centros de Custo

Os centros de custo podem ser adaptados conforme as necessidades
mediante diálogo com o tesoureiro de forma a facilitar o ajuste da
programação.  
Nota:

    ccRubri <- read.delim("CentrosdeCusto.csv", sep = ";")
    knitr::kable(ccRubri)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">CENTRO.DE.CUSTO</th>
<th style="text-align: left;">RUBRICA</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">BAR</td>
<td style="text-align: left;">COMPRAS</td>
</tr>
<tr class="even">
<td style="text-align: left;">BAR</td>
<td style="text-align: left;">RECEITA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">BAR</td>
<td style="text-align: left;">EQUIPAMENTOS</td>
</tr>
<tr class="even">
<td style="text-align: left;">BAR</td>
<td style="text-align: left;">MANUTENÇÃO / EQUIPAMENTOS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">BAR</td>
<td style="text-align: left;">ENCARGOS COM COLABORADORES</td>
</tr>
<tr class="even">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">SEG. AC. TRABALHO</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">IGAC / SPA</td>
</tr>
<tr class="even">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">DONATIVO DE PORTA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">BENGALEIRO</td>
</tr>
<tr class="even">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">APOIO</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">OUTROS</td>
</tr>
<tr class="even">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">BANDA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">ENCARGOS COM COLABORADORES</td>
</tr>
<tr class="even">
<td style="text-align: left;">ATIVIDADES CONTRATADAS</td>
<td style="text-align: left;">RECEITA ATIVIDADES CONTRATADAS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">SÓCIOS</td>
<td style="text-align: left;">HOMENAGENS</td>
</tr>
<tr class="even">
<td style="text-align: left;">SÓCIOS</td>
<td style="text-align: left;">QUOTAS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">SÓCIOS</td>
<td style="text-align: left;">DONATIVO</td>
</tr>
<tr class="even">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">CENÁRIO</td>
</tr>
<tr class="odd">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">GUARDA ROUPA</td>
</tr>
<tr class="even">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">PUBLICIDADE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">DONATIVO DE PORTA</td>
</tr>
<tr class="even">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">APOIO</td>
</tr>
<tr class="odd">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">ENCARGOS COM COLABORADORES</td>
</tr>
<tr class="even">
<td style="text-align: left;">ATIVIDADES DIVERSAS</td>
<td style="text-align: left;">COMPRAS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">ATIVIDADES DIVERSAS</td>
<td style="text-align: left;">RECEITA</td>
</tr>
<tr class="even">
<td style="text-align: left;">ATIVIDADES DIVERSAS</td>
<td style="text-align: left;">APOIO</td>
</tr>
<tr class="odd">
<td style="text-align: left;">ATIVIDADES DIVERSAS</td>
<td style="text-align: left;">ENCARGOS COM COLABORADORES</td>
</tr>
<tr class="even">
<td style="text-align: left;">ANIVERSÁRIO SUS</td>
<td style="text-align: left;">COMPRAS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">ANIVERSÁRIO SUS</td>
<td style="text-align: left;">RECEITA</td>
</tr>
<tr class="even">
<td style="text-align: left;">ANIVERSÁRIO SUS</td>
<td style="text-align: left;">APOIO</td>
</tr>
<tr class="odd">
<td style="text-align: left;">ANIVERSÁRIO SUS</td>
<td style="text-align: left;">ENCARGOS COM COLABORADORES</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">CONSUMO ÁGUA (SMAS)</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">CONSUMO ELECTRICIDADE</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">GÁS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">SECURITAS - ALARME</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">SEGUROS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">MATERIAL ESCRITÓRIO</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">PRODUTOS DE LIMPEZA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">COMUNICAÇÕES</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">MANUTENÇÃO / OBRAS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">IMPOSTOS</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">PUBLICIDADE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">OUTROS</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">ARTIGOS DECORATIVOS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">EQUIPAMENTOS</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">ACTIVIDADES VÁRIAS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">ALUGUER EXTINTORES</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">SERVIÇO DE LIMPEZA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">DESP. BANCÁRIAS</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">QUOTA - FEDERAÇÃO DAS COLECTIVIDADES</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">CERTIDÕES E DECLARAÇÕES</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">JARDIM</td>
</tr>
<tr class="odd">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">RENDA</td>
</tr>
<tr class="even">
<td style="text-align: left;">INSTALAÇÕES</td>
<td style="text-align: left;">ENCARGOS COM COLABORADORES</td>
</tr>
</tbody>
</table>
