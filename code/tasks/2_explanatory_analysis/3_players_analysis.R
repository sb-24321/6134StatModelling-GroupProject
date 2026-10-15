library('tidyverse')

players <- read.csv("./data/league_players.csv")

# Select just the Ashford players
ashford_players <- dplyr::filter(players, team == 'Ashford United')

summary(ashford_players)

# Check for missing values in each column
colSums(is.na(players))

# Inspect the full player dataset
str(players)