#' This file gives an example of how to plot any regression model.

source('./code/modeller/modeller.R')
library('dplyr')

matches <- read.csv('./data/ashford_matches.csv')

# since we will model a binomial regression model, we will switch the variable
# to represent 1 if the team is at home, and 0 if the team are away.
matches$home_away <- ifelse(matches$home_away=='Home', 1, 0)

home_matches <- matches |>
  dplyr::filter(home_away==1)

# Create a Binomial Regression Model
model <- CreateRegressionModel(data=matches,
                     response_var='home_away',
                     explanatory_vars=c('goals_scored','goals_conceded', 'opponent_rank'),
                     model_type='binomial')

# Plot the graph. Each variable will be plotted against the response variable.
# In context, we wil plot `home_away` against `goals_scored` and then against 
# `goals_conceded` and then finally against `opponent_rank`. 
#
# We will the store this in the designated path.
PlotRegression(model, path='./outputs/example/regression_plots/binomial/', )


