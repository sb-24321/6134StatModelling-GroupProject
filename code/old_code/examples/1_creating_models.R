source('./code/modeller/modeller.R')

matches <- read.csv('./data/ashford_matches.csv')

# Create a Normal Regression Model
model <- CreateRegressionModel(data=matches,
                     response_var='goals_scored',
                     explanatory_vars=c('opponent_rank', 'home_away'),
                     model_type='normal')
# print(summary(model))

# Create a Binomial regression model.
matches$num_home_away <- ifelse(matches$home_away=='home', 1, 0)
model <- CreateRegressionModel(data=matches,
                     response_var='num_home_away',
                     explanatory_vars=c('opponent_rank', 'goals_conceded'),
                     model_type='binomial')
# print(summary(model))

# Create a Poisson regression model.
model <- CreateRegressionModel(data=matches,
                     response_var='goals_conceded',
                     explanatory_vars=c('home_away', 'opponent_rank'),
                     model_type='poisson')
# print(summary(model))
