
#' Este script acompanha o "Projeto Final" e pode ser usado como suporte para
#' execução da tarefa proposta!

################################################################################
### Carregar dados pré-processados nas tarefas EaD1 e EaD2 ("merge_data12_df.RData")
################################################################################
load(file = "./merge_data12_df_20220418.RData")

#-------------------------------------------------------------------------------
#--- Conferir variáveis disponíveis
names(merge_data12_df)
# [1] "COUNTRY"                                                     
# [2] "ISO3"                                                        
# [3] "WHO_REGION"                                                  
# [4] "DATA_SOURCE"                                                 
# [5] "DATE_UPDATED"                                                
# [6] "TOTAL_VACCINATIONS"                                          
# [7] "PERSONS_VACCINATED_1PLUS_DOSE"                               
# [8] "TOTAL_VACCINATIONS_PER100"                                   
# [9] "PERSONS_VACCINATED_1PLUS_DOSE_PER100"                        
# [10] "PERSONS_FULLY_VACCINATED"                                    
# [11] "PERSONS_FULLY_VACCINATED_PER100"                             
# [12] "VACCINES_USED"                                               
# [13] "FIRST_VACCINE_DATE"                                          
# [14] "NUMBER_VACCINES_TYPES_USED"                                  
# [15] "Name"                                                        
# [16] "WHO.Region"                                                  
# [17] "Cases...cumulative.total"                                    
# [18] "Cases...cumulative.total.per.100000.population"              
# [19] "Cases...newly.reported.in.last.7.days"                       
# [20] "Cases...newly.reported.in.last.7.days.per.100000.population" 
# [21] "Cases...newly.reported.in.last.24.hours"                     
# [22] "Deaths...cumulative.total"                                   
# [23] "Deaths...cumulative.total.per.100000.population"             
# [24] "Deaths...newly.reported.in.last.7.days"                      
# [25] "Deaths...newly.reported.in.last.7.days.per.100000.population"
# [26] "Deaths...newly.reported.in.last.24.hours" 

#-------------------------------------------------------------------------------
#--- Filtrar registros, executar análise com países OECD
OECD_extended <- c("AUS","AUT","BEL","CAN","CHE","DEU","DNK","ESP","FIN","FRA",
                   "GBR","GRC","ISL","ITA","JPN","KOR","LUX","MEX","NLD",
                   "NOR","NZL","PRT","SWE","TUR","USA","BRA","CHL","ARG","COL",
                   "CRI","BGR","RUS","PER","ROU","CZE","EST","IRL","ISR","LVA",
                   "LTU","POL","SVK","SVN")
merge_data12_df <- merge_data12_df[merge_data12_df$ISO3%in%OECD_extended,]

#-------------------------------------------------------------------------------
# Observar a data do registro: esta informação é importante para interpretação!
merge_data12_df[,c("COUNTRY","DATE_UPDATED")]
#                         COUNTRY DATE_UPDATED
# Argentina               Argentina   2021-07-23
# Australia               Australia   2021-07-24
# Austria                 Austria     2021-07-18
# Belgium                 Belgium     2021-07-18
# Etc.

#-------------------------------------------------------------------------------
#--- Aqui apenas executa uma verificação de consistência entre
#--- duas variáveis de interesse!
plot(x=merge_data12_df$PERSONS_VACCINATED_1PLUS_DOSE_PER100,
     y=merge_data12_df$Deaths...cumulative.total.per.100000.population, 
     xlab = "Vaccinated.per.100", 
     ylab = "Deaths.per.100k")

################################################################################
### Preparar dados para vizualizar em grafo de associação, conforme exemplo
### trabalhado na tarefa EaD3!
################################################################################
library(RedeR)
library(igraph)

#--- Separar duas variáveis de interesse
x_df <- merge_data12_df[,c("PERSONS_VACCINATED_1PLUS_DOSE_PER100",
                         "Deaths...cumulative.total.per.100000.population")]

#--- Simplificar nomes de colunas
colnames(x_df) <- c("Vaccinated.per.100","Deaths.per.100k")

#--- Clusterizar registros (agrupar países)
hc <- hclust(dist(x_df), "ward.D2")
plot(hc, cex=0.3)

#--- Initialize the R-to-Java interface
calld(rdp)

#--- Add a graph
g1 <- graph.lattice(x_df)
addGraph(rdp, g=g1, layout=layout_with_kk(g1))

x_df
for(i in 1:nrow(x_df)) {       # for-loop over rows
  grafo <- list(c(x_df[i], x_df[i]["Vaccinated.per.100"], x_df[i]["Deaths.per.100k"]))
}
grafo
plot(graph_from_adj_list(grafo, mode = "all"))
