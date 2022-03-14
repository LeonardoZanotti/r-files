################################################################################
### Load data
################################################################################
# load the ggplot2 library for plotting
library(ggplot2)
library(plyr)

# turn off factors
options(stringsAsFactors = FALSE)

data_df <- read.csv(file = "./vaccination-data.csv", sep=",", quote="\"",
                     header = T, stringsAsFactors = F)
colnames(data_df)
# [1] "COUNTRY"                              "ISO3"                                
# [3] "WHO_REGION"                           "DATA_SOURCE"                         
# [5] "DATE_UPDATED"                         "TOTAL_VACCINATIONS"                  
# [7] "PERSONS_VACCINATED_1PLUS_DOSE"        "TOTAL_VACCINATIONS_PER100"           
# [9] "PERSONS_VACCINATED_1PLUS_DOSE_PER100" "PERSONS_FULLY_VACCINATED"            
# [11] "PERSONS_FULLY_VACCINATED_PER100"      "VACCINES_USED"                       
# [13] "FIRST_VACCINE_DATE"                   "NUMBER_VACCINES_TYPES_USED" 

class(data_df)
"data.frame"

head(data_df)[1:3,1:6]
# COUNTRY ISO3 WHO_REGION DATA_SOURCE DATE_UPDATED TOTAL_VACCINATIONS
# 1 Afghanistan  AFG       EMRO   REPORTING   2022-03-06            5597130
# 2     Albania  ALB       EURO   REPORTING   2022-02-20            2707658
# 3     Algeria  DZA       AFRO   REPORTING   2022-03-09           13704895

# str(data_df)

data_df$COUNTRY

# Unuseful
qplot(x = data_df$COUNTRY,
      y = data_df$TOTAL_VACCINATIONS)

data_afro = data_df[data_df$WHO_REGION == "AFRO", ]
data_amro = data_df[data_df$WHO_REGION == 'AMRO', ]
data_emro = data_df[data_df$WHO_REGION == 'EMRO', ]
data_euro = data_df[data_df$WHO_REGION == 'EURO', ]
data_other = data_df[data_df$WHO_REGION == 'OTHER', ]
data_searo = data_df[data_df$WHO_REGION == 'SEARO', ]
data_wpro = data_df[data_df$WHO_REGION == 'WPRO', ]

by(data_df, seq_len(nrow(data_df)), function(row) row$COUNTRY <- substr(row$COUNTRY, 1, 3))
countries_df = ddply(data_df, .(COUNTRY, TOTAL_VACCINATIONS, WHO_REGION), function(row) row$COUNTRY = substr(row$COUNTRY, 1, 3))
head(countries_df)
qplot(x = countries_df$COUNTRY,
      y = countries_df$TOTAL_VACCINATIONS)

continents = c("AFRO", "AMRO", "EMRO", "EURO", "OTHER", "SEARO", "WPRO")
for (continent in continents) {
  new_df = countries_df[countries_df$WHO_REGION == continent, ]
  qplot(x = new_df$V1,
        y = new_df$TOTAL_VACCINATIONS,
        main = paste("Vaccinations per country of ", continent),
        xlab = "Countries",
        ylab = "Vaccines")
}
