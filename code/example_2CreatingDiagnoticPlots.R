source('./code/Modeller/Modeller.R')
library(dplyr)

matches <- read.csv("./data/ashford_matches.csv")
matches$num_home_away <- ifelse(matches$home_away=='home', 1, 0)

matches <- matches |>
  dplyr::select(!c('home_away'))

# Select a response variable, then we can form every other combination of variables.
# Returns a list of lists. Each embedded list is a unique combination. We can make models
# for each.

for (response_var in colnames(matches)){
  explanatory_vars <- (CreateAllCombinations(matches, response_var))
  
  for (var in explanatory_vars){
    model <- CreateRegressionModel(data=matches, response_var=response_var, 
                                   explanatory_vars=var, model_type=)
    
    filepath <- paste0('./outputs/Matches/',response_var,'/')
    DiagnosticPlots(model, path=filepath)
  }
}


