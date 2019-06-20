# vaccines-wellcome

The original data are from:

* Wellcome trust (vaccine hesitancy, trust in science, importance of religion - the link directly downaloads an Excel file): https://wellcome.ac.uk/sites/default/files/wgm2018-dataset-crosstabs-all-countries.xlsx

* International Monetary Found (GDP pro capita): https://www.imf.org/external/pubs/ft/weo/2019/01/weodata/

* Eurostat (social media penetration): https://ec.europa.eu/eurostat/web/digital-economy-and-society/data/main-tables

The data used for the analysis are extracted in the folder with the same name. 

Notice that I used the following data:

* **Vaccine heistancy**: Percentage of people who answered 'Strongly or somewhat disagree that vaccines are safe' to the question 'Do you agree, disagree, or neither agree nor disagree with the following statements? Vaccines are effective. Vaccines are safe' (Wellcome Global Monitor 2018)

* **Trust in science**: Wellcome Global Monitor Trust in Scientists Index, Country Average Index Score (Wellcome Global Monitor 2018)

* **Importance of religion**: 'Percentage of people who have a religion & say it is important in their daily lives' (Wellcome Global Monitor 2018)

* **GDP pro capita**: estimates in International Dollars from the International Monetary Found

* **Social media penetration**: category 'Internet use: participating in social networks (creating user profile, posting messages or other contributions to facebook, twitter, etc.)', percentage on total individuals in 2018 (Eurostat - Digital economy and society) 

The R script [correlations.R](correlations.R) reproduce the plots (that are also in the folder with the same name) 
