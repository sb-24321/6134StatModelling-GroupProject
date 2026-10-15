library('tidyverse')

players <- read.csv("./data/league_players.csv")

# Select just the Ashford players
ashford_players <- dplyr::filter(players, team == 'Ashford United')

summary(ashford_players)

