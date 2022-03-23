################################################################################
### Load data
################################################################################
# load the ggplot2 library for plotting
library(ggplot2)
library(plyr)

# turn off factors
options(stringsAsFactors = FALSE)

data_df1 <- read.csv(file = "./vaccination-data.csv", sep=",", quote="\"", header = T, stringsAsFactors = F)
data_df2 <- read.csv(file = "./WHO-COVID-19-global-table-data.csv", sep=",", quote="\"", header = T, stringsAsFactors = F)

merged_df = merge(data_df1,data_df2,by=c('COUNTRY'),all.x=T)

colnames(data_df1)
# [1] "COUNTRY"                              "ISO3"                                
# [3] "WHO_REGION"                           "DATA_SOURCE"                         
# [5] "DATE_UPDATED"                         "TOTAL_VACCINATIONS"                  
# [7] "PERSONS_VACCINATED_1PLUS_DOSE"        "TOTAL_VACCINATIONS_PER100"           
# [9] "PERSONS_VACCINATED_1PLUS_DOSE_PER100" "PERSONS_FULLY_VACCINATED"            
# [11] "PERSONS_FULLY_VACCINATED_PER100"      "VACCINES_USED"                       
# [13] "FIRST_VACCINE_DATE"                   "NUMBER_VACCINES_TYPES_USED" 

class(data_df1)
"data.frame"

head(data_df1)[1:3,1:6]
# COUNTRY ISO3 WHO_REGION DATA_SOURCE DATE_UPDATED TOTAL_VACCINATIONS
# 1 Afghanistan  AFG       EMRO   REPORTING   2022-03-06            5597130
# 2     Albania  ALB       EURO   REPORTING   2022-02-20            2707658
# 3     Algeria  DZA       AFRO   REPORTING   2022-03-09           13704895

# str(data_df1)

data_df1$COUNTRY

# Unuseful
qplot(x = data_df1$COUNTRY,
      y = data_df1$TOTAL_VACCINATIONS)

# data_afro = data_df1[data_df1$WHO_REGION == "AFRO", ]
# data_amro = data_df1[data_df1$WHO_REGION == 'AMRO', ]
# data_emro = data_df1[data_df1$WHO_REGION == 'EMRO', ]
# data_euro = data_df1[data_df1$WHO_REGION == 'EURO', ]
# data_other = data_df1[data_df1$WHO_REGION == 'OTHER', ]
# data_searo = data_df1[data_df1$WHO_REGION == 'SEARO', ]
# data_wpro = data_df1[data_df1$WHO_REGION == 'WPRO', ]

data_afro = merged_df[merged_df$WHO.Region == "Africa", ]
data_amro = merged_df[merged_df$WHO.Region == 'Americas', ]
data_emro = merged_df[merged_df$WHO.Region == 'Eastern Mediterranean', ]
data_euro = merged_df[merged_df$WHO.Region == 'Europe', ]
data_other = merged_df[merged_df$WHO.Region == 'Other', ]
data_searo = merged_df[merged_df$WHO.Region == 'South-East Asia', ]
data_wpro = merged_df[merged_df$WHO.Region == 'Western Pacific', ]

# by(data_df1, seq_len(nrow(data_df1)), function(row) row$COUNTRY <- substr(row$COUNTRY, 1, 3))
countries_df = ddply(data_df1, .(COUNTRY, TOTAL_VACCINATIONS, WHO_REGION), function(row) row$COUNTRY = substr(row$COUNTRY, 1, 3))
head(countries_df)
qplot(x = countries_df$COUNTRY,
      y = countries_df$TOTAL_VACCINATIONS)

# Vacinas por país por cada continente
continents = c("AFRO", "AMRO", "EMRO", "EURO", "OTHER", "SEARO", "WPRO")
for (continent in continents) {
  new_df = countries_df[countries_df$WHO_REGION == continent, ]
  qplot(x = new_df$V1,
        y = new_df$TOTAL_VACCINATIONS,
        main = paste("Vaccinations per country of", continent),
        xlab = "Countries",
        ylab = "Vaccines")
}

# Vacinas por país por cada continente
newContinents = c("Africa", "Americas", "Eastern Mediterranean", "Europe", "Other", "South-East Asia", "Western Pacific")
new_df = na.omit(merged_df[merged_df$WHO.Region == newContinents[4], ])
qplot(x = new_df$TOTAL_VACCINATIONS,
      y = new_df$ISO3,
      main = paste("Vaccinations per country of", newContinents[4]),
      xlab = "Vaccines",
      ylab = "Countries")

