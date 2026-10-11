#' This file serves as an example of each function that can be performed, so far.
#' This is a good reference for when testing to see the functionality.
source('./code/General_Model.R')

matches <- read.csv("./data/ashford_matches.csv")

## Creating a normal linear model.
model <- CreateModel(data=matches,
                           response_var='goals_scored',
                           explanatory_vars='opponent_rank',
                           model_type='normal')

## Creating a binomial model.
## Our response variable represents a binary outcome.
## Essentially there are two outcomes: Yes/No, True/False, Home/Away?????
model <- CreateModel(data=matches,
                   response_var='num_home_away',
                   explanatory_vars=c('home_away', 'goals_conceded'),
                   model_type='binomial')

## Creating a poisson model.
## Our response variable represents a count.
model <- CreateModel(data=matches,
                   response_var='goals_scored',
                   explanatory_vars=c('home_away', 'opponent_rank'),
                   model_type='poisson')
