library(tidyverse)

# load data:

social_media <- read_csv(file = 'data/eurostat_internet_use.csv')

hesitancy <- read_csv(file = "data/wellcome_safe_effective_vaccines.csv", 
                      locale = locale(encoding = "latin1"), col_names = FALSE)

religion <- read_csv(file = "data/wellcome_religion.csv", 
                      locale = locale(encoding = "latin1"), col_names = FALSE)

science <- read_csv(file = 'data/wellcome_trust_science.csv',
                      locale = locale(encoding = "latin1"), col_names = FALSE)

gdp <- read_csv(file = 'data/imo_gdp_capita.csv')

# clean data:

# social media:
social_media <- social_media %>%
  filter(INDIC_IS == 'Internet use: participating in social networks (creating user profile, posting messages or other contributions to facebook, twitter, etc.)') %>%
  filter(TIME == '2018') %>%
  filter(UNIT == 'Percentage of individuals') %>%
  filter(Value != ":") %>%
  mutate(Value = as.integer(Value)/100) %>%
  rename('Country' = 'GEO')

social_media$Country[40] <- 'Kosovo'
social_media$Country[9] <- 'Germany'
social_media$Country[7] <- 'Czech Republic'

# hesitancy:
hesitancy <- hesitancy %>%
  rename('Country' = 'X2') %>%
  rename('Proportion' = 'X8') %>%
  mutate(Proportion = str_remove( Proportion, '%')) %>%
  mutate(Proportion = as.integer(Proportion) / 100) 
  
hesitancy$Country[77] <- 'North Macedonia'
hesitancy$Country[136] <- 'United Kingdom'

# religion:
religion <- religion %>%
  rename('Country' = 'X2') %>%
  rename('Proportion' = 'X8') %>%
  mutate(Proportion = str_remove( Proportion, '%')) %>%
  mutate(Proportion = as.integer(Proportion) / 100)  

religion$Country[71] <- 'North Macedonia'
religion$Country[125] <- 'United Kingdom'

# science:
science <- science %>%
  rename('Country' = 'X2') %>%
  rename('TSI' = 'X8') 

science$Country[77] <- 'North Macedonia'
science$Country[135] <- 'United Kingdom'

gdp <- gdp %>%
  rename('GDP' = '2018') %>%
  mutate(GDP = str_remove(GDP, '\\...')) %>%
  mutate(GDP = str_remove(GDP, ',')) %>%
  mutate(GDP = as.double(GDP))


# process data for correlation analysis:
# we use only countries that are in the social_media dataset:

EU_data <- inner_join(social_media, hesitancy, by = 'Country')  %>%
  select(Country, Value, Proportion) %>%
  rename('Social_media' = 'Value') %>%
  rename('Hesitancy' = 'Proportion') %>%
  inner_join(religion, by = 'Country') %>%
  select( Country, Social_media, Hesitancy, Proportion) %>%
  rename('Religion' = 'Proportion') %>%
  inner_join(science, by = 'Country') %>%
  select( Country, Social_media, Hesitancy, Religion, TSI) %>%
  inner_join(gdp, by = 'Country') %>%
  select( Country, Social_media, Hesitancy, Religion, TSI, GDP) 

# plot

basic_plot <- ggplot(data = EU_data, aes(x = Hesitancy, label = Country)) +
  theme_bw() +
  labs(x = 'Vaccine hesitancy') 

# social media:
basic_plot + 
  geom_smooth(aes(y = Social_media), method = lm) +
  geom_point(aes(y = Social_media), col = "red") +
  geom_text_repel(aes(y = Social_media)) +
  labs(y = 'Social media penetration') +
  ggsave('plots/Social_media.pdf',width = 8, height = 6)

# religion:
basic_plot + 
  geom_smooth(aes(y = Religion), method = lm) +
  geom_point(aes(y = Religion), col = "red") +
  geom_text_repel(aes(y = Religion)) +
  labs(y = 'Importance of religion') +
  ggsave('plots/Religion.pdf',width = 8, height = 6)

# science:
basic_plot + 
  geom_smooth(aes(y = TSI), method = lm) +
  geom_point(aes(y = TSI), col = "red") +
  geom_text_repel(aes(y = TSI)) +
  labs(y = 'Trust in science') +
  ggsave('plots/Science.pdf',width = 8, height = 6)

# GDP:
basic_plot + 
  geom_smooth(aes(y = GDP), method = lm) +
  geom_point(aes(y = GDP), col = "red") +
  geom_text_repel(aes(y = GDP)) +
  labs(y = 'GPD pro capita') +
  ggsave('plots/GDP.pdf',width = 8, height = 6)
