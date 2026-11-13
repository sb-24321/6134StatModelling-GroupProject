source('./code/modeller/modeller.R')

library(dplyr)

matches <- read.csv("./data/ashford_matches.csv")
matches$num_home_away <- ifelse(matches$home_away=='home', 1, 0)

# Remove the `home_away` column
matches <- matches |>
  dplyr::select(!c('home_away'))

players <- read.csv("./data/league_players.csv")
players <- players |>
  dplyr::select(!c('team', 'position'))


# To use the column `home_away` in some instances, we will convert it to 1's and 0's and 
# store it in another column.
# Select a response variable, then we can form every other combination of variables.
# Returns a list of lists. Each embedded list is a unique combination. We can make models
# for each.
for (model_type in c('poisson', 'normal')){
  for (response_var in colnames(matches)){

    # Taking one response variable, we will find all the other combinations of variables.
    # For example if we have 'A', 'B', 'C' as our columns, and we take 'A' to be our response
    # variable, and thus 'B' and 'C' will be our remaining variables, our explanatory 
    # variables. So with the remaining variables, we will create all possible combinations.
    # So we will get a list with the elements: [('B'), ('C'), ('B', 'C')]
    
    explanatory_vars <- CreateAllCombinations(matches, response_var)

    # For each combination of explanatory variable, we will create a model with each response
    # variable and each combination of explanatory variable...
    for (var in explanatory_vars){
      model <- CreateRegressionModel(data=matches, response_var=response_var, 
                                     explanatory_vars=var, model_type=model_type)

      # ...we will then create a diagnostic plot for each.
      # filepath <- paste0('./outputs/Matches/',response_var,'/')
      filepath <- paste0('./outputs/example/diagnostic_plots/matches/',response_var,'/')
      DiagnosticPlots(model, path=filepath)
    }
  }
}

#' Exact same, but for the `players` table.
for (model_type in c('poisson', 'normal')){
  for (response_var in colnames(players)){

    explanatory_vars <- CreateAllCombinations(players, response_var)
    for (var in explanatory_vars){
      model <- CreateRegressionModel(data=players, response_var=response_var, 
                                     explanatory_vars=var, model_type=model_type)

      filepath <- paste0('./outputs/example/diagnostic_plots/players/',response_var,'/')
      DiagnosticPlots(model, path=filepath)
    }
  }
}


