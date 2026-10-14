#' We will look at whether having an injury is influenced by the age, total minutes played,
#' training load, previous injuries and bmi of a player.

library("tidyverse")
source("./code/Modeller/Modeller.R")

# As `injured` is the current state of the player, where a player can currently be
# injured (1) or is not currently injured (0), we will aim to fit the model using a
# binomial regression.

# We will not introduce dummy variables yet.
players <- read.csv(file='./data/league_players.csv') |>
  dplyr::select(!c(team, position))

# Now we will find all combinations of linear variables.
all_combos <- CreateAllCombinations(players, 'injured')
models <- list()

for (i in seq_along(all_combos)){
  model <- CreateRegressionModel(data=players,
                              response_var = 'injured', 
                              explanatory_vars = all_combos[i],
                              model_type='binomial')
  
  suppressWarnings(models[paste0('m', i)] <- model)

  #PlotRegression(m1, path='./outputs/Week4/injured_model/plots/')
  #DiagnosticPlots(m1, path='./outputs/Week4/injured_model/diagnostics/')
}

# Important to that minutes played is not zero, but its very small.

