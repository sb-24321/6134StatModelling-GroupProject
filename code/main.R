source('./code/General_Model.R')

Main <- function(){
  matches <- read.csv("./data/ashford_matches.csv")
  
  model <- CreateNormalModel(data=matches,
                             response_var='goals_scored',
                             explanatory_vars='opponent_rank'
                             )

  print(model)
}

Main()
