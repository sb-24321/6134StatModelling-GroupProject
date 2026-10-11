#' This file serves as an example of each function that can be performed, so far.

source('./code/General_Model.R')

matches <- read.csv("./data/ashford_matches.csv")

# Creating a normal linear model
model <- CreateModel(data=matches,
                           response_var='goals_scored',
                           explanatory_vars='opponent_rank',
                           model_type='normal')


