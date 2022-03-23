
#' Este script acompanha o "Exercício 2", carregando no RStudio os dados 
#' indicados na tarefa EaD2.

################################################################################
### Carrega a tabela de dados "vaccination-data.csv" (data1_df)
################################################################################
data1_df <- read.table(file = "./vaccination-data.csv", sep=",", quote="\"",
                     header = T, stringsAsFactors = F)

#--- Verifica nomes das variáveis nas colunas
colnames(data1_df)
# [1] "COUNTRY"                              "ISO3"                                
# [3] "WHO_REGION"                           "DATA_SOURCE"                         
# [5] "DATE_UPDATED"                         "TOTAL_VACCINATIONS"                  
# [7] "PERSONS_VACCINATED_1PLUS_DOSE"        "TOTAL_VACCINATIONS_PER100"           
# [9] "PERSONS_VACCINATED_1PLUS_DOSE_PER100" "VACCINES_USED"                       
# [11] "FIRST_VACCINE_DATE"                   "NUMBER_VACCINES_TYPES_USED" 

#--- Verifica classe do object
class(data1_df)
# "data.frame"

#--- Verifica dimensão do 'data.frame'
dim(data1_df)
# [1] 224  14

#--- Aqui uma simples, e inicial, verificação de conteúdo
data1_df[1:3,1:6]
# COUNTRY ISO3 WHO_REGION DATA_SOURCE DATE_UPDATED TOTAL_VACCINATIONS
# 1    Afghanistan  AFG       EMRO   REPORTING   2021-06-02             626290
# 2        Albania  ALB       EURO   REPORTING   2021-05-23             710482
# 3        Algeria  DZA       AFRO   REPORTING   2021-05-31                 NA


################################################################################
### Carrega a tabela de dados "WHO-COVID-19-global-table-data.csv" (data2_df)
################################################################################
#Note que esta tabela tem um erro de formatação e precisa ser corrigida!
data2_df <- read.table(file = "./WHO-COVID-19-global-table-data.csv", 
                       sep=",", quote="\"",
                       header = T, stringsAsFactors = F)

#--- Verifica nomes das variáveis nas colunas
colnames(data2_df)
# [1] "Name"                                                        
# [2] "WHO.Region"                                                  
# [3] "Cases...cumulative.total"                                    
# [4] "Cases...cumulative.total.per.100000.population"              
# [5] "Cases...newly.reported.in.last.7.days"                       
# [6] "Cases...newly.reported.in.last.7.days.per.100000.population" 
# [7] "Cases...newly.reported.in.last.24.hours"                     
# [8] "Deaths...cumulative.total"                                   
# [9] "Deaths...cumulative.total.per.100000.population"             
# [10] "Deaths...newly.reported.in.last.7.days"                      
# [11] "Deaths...newly.reported.in.last.7.days.per.100000.population"
# [12] "Deaths...newly.reported.in.last.24.hours" 

#--- Verifica classe do object
class(data2_df)
#[1] "data.frame"

#--- Verifica dimensão do 'data.frame'
dim(data2_df)
# [1] 238  13

#--- Aqui uma simples, e inicial, verificação de conteúdo
data2_df[1:3,1:3]
#       Name      WHO.Region Cases...cumulative.total
# 1                   Global            <NA>                464809377
# 2 United States of America        Americas                 78932322
# 3                    India South-East Asia                 43004005

################################################################################
### Combina os datasets
################################################################################

#--- Verifica compatibilidade entre possiveis "chaves" para alinhamento
sum(data1_df$COUNTRY %in% data2_df$Name)
# [1] 225
sum(data1_df$WHO_REGION%in%data2_df$WHO.Region)
# [1] 0

#-------------------------------------------------------------------------------
#--- Executa alinhamento com a melhor 'chave' disponível

#--- Verifica se há nomes duplicados
any(duplicated(data1_df$COUNTRY))
# [1] FALSE
any(duplicated(data2_df$Name))
# [1] FALSE

#--- Nomei linhas com as chaves de identificação de cada dataset
rownames(data1_df) <- data1_df$COUNTRY
rownames(data2_df) <- data2_df$Name

#--- Gere um vetor de nomes comuns entre os dois datasets
country_names <- intersect(rownames(data1_df), rownames(data2_df))

#--- Alinha os dois datasets usando o vetor "country_names"
data1_df <- data1_df[country_names,]
data2_df <- data2_df[country_names,]
all(rownames(data1_df)==rownames(data2_df))
# [1] TRUE

#--- Verifica se há alguma duplicidade entre nomes de colunas
sum(colnames(data1_df) %in% colnames(data2_df))
# [1] 0

#-------------------------------------------------------------------------------
#--- Combina datasets alinhados, e salva no formato '.RData' 
#--- para análises subsequentes
merge_data12_df <- cbind(data1_df, data2_df)
save(merge_data12_df, file = "merge_data12_df.RData")





