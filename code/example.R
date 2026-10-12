source('./code/Modeller/Modeller.R')

matches <- read.csv('./data/ashford_matches.csv')

model <- CreateModel(data=matches,
                     response_var='goals_scored',
                     explanatory_vars=c('opponent_rank', 'home_away'),
                     model_type='normal')
print(model)

matches$num_home_away <- ifelse(matches$home_away=='home', 1, 0)
model <- CreateModel(data=matches,
                     response_var='num_home_away',
                     explanatory_vars=c('opponent_rank', 'goals_conceded'),
                     model_type='binomial')

print(model)
