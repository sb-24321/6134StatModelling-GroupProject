#' This file serves as an example of each function that can be performed, so far.
#' This is a good reference for when testing to see the functionality.

source('./GeneralModel/GeneralModel.R')

# We will show this in the matches dataset, as it is much smaller and simpler.
matches <- read.csv("./data/ashford_matches.csv")

## Creating a normal linear model.
## Output can be a continous value.
model <- CreateModel(data=matches,
                           response_var='goals_scored',
                           explanatory_vars='home_away',
                           model_type='normal')


## Creating a binomial model.
## Our response variable represents a binary outcome.
## Essentially there are two outcomes: Yes/No, True/False, Home/Away?????
matches$num_home_away <- (ifelse(matches$home_away == 1, 1, 0)) # binify our data.
model <- CreateModel(data=matches,
                   response_var='num_home_away',
                   explanatory_vars=c('goals_scored', 'goals_conceded'),
                   model_type='binomial')


## Creating a poisson model.
## Our response variable represents a count, discrete number.
model <- CreateModel(data=matches,
                   response_var='goals_scored',
                   explanatory_vars=c('home_away', 'opponent_rank'),
                   model_type='poisson')
