#' This file serves as an example of each function that can be performed, so far.
#' This is a good reference for when testing to see the functionality.

source('./code/General_Model.R')

matches <- read.csv("./data/ashford_matches.csv")

## Creating a normal linear model.

model <- CreateModel(data=matches,
                           response_var='goals_scored',
                           explanatory_vars='opponent_rank',
                           model_type='normal')

## Creating a binomial linear model.
## Our response variable represents a binary outcome.
## Essentially there are two outcomes: Yes/No, True/False, Home/Away?????

# The binary model gives us 0.44284 + 0.06809x, a normal model gives us 0 + 0x.
matches$num_home_away <- (ifelse(matches$home_away == 1, "1", "0")) # binify our data.
model<-CreateModel(data=matches,
                   response_var='num_home_away',
                   explanatory_vars='goals_scored',
                   model_type='binary')

