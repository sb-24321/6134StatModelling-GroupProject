source('./code/General_Model.R')

matches <- read.csv("./data/ashford_matches.csv")

model <- CreateModel(data=matches,
                           response_var='goals_scored',
                           explanatory_vars='opponent_rank',
                           model_type='normal')

print(model)

