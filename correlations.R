library( tidyverse)

europeanUnion <- c("Austria","Belgium","Bulgaria","Croatia","Cyprus",
                   "Czech Rep.","Denmark","Estonia","Finland","France",
                   "Germany","Greece","Hungary","Ireland","Italy","Latvia",
                   "Lithuania","Luxembourg","Malta","Netherlands","Poland",
                   "Portugal","Romania","Slovakia","Slovenia","Spain",
                   "Sweden","United Kingdom")

social_media <- c(51,72,50,47,63,48,75,60,66,43,51,50,65,59,43,60,54,68,70,67,48,56,
                  52,59,45,57,71,71)

measles_trend <- rep(0,28)

# now for vaccinations:
measles <- read_csv("API_SH.IMM.MEAS_DS2_en_csv_v2_10034419.csv") %>%
  select( `Country Name`, `1960`:`2016`) %>%
  rename( Country = `Country Name` ) %>%
  gather( Year, Percentage, -Country) %>%
  arrange( Country )
measles$Percentage <- as.double(measles$Percentage)
measles$Year <- as.integer(measles$Year)

europeanUnion[6]="Czech Republic"
europeanUnion[24]="Slovak Republic"
counter = 1
for( i in europeanUnion ){
  measles_trend[counter] <- measles$Percentage[measles$Country==i & measles$Year==2016] -
    measles$Percentage[measles$Country==i & measles$Year==2010]
  counter = counter + 1 
}


out = data_frame( social_media, measles_trend)
ggplot(data=out, aes(x=measles_trend, y =social_media)) +
  geom_point()+
  geom_smooth(method = lm)+
  scale_y_continuous(name='Social media usage (%)')+
  scale_x_continuous(name='2010/2016 trend for measles vaccination (%)')+
  theme_bw()+
  ggsave('correlation.pdf',width = 4, height = 4)
