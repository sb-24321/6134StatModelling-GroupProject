library('tidyverse')

# Load the players dataset ===============================================================
players <- read.csv("./data/league_players.csv")

# Analyse the Players dataset ============================================================

colSums(is.na(players)) # check for na values.
str(players)

# Analyise the Ashford United players ====================================================
# Since we are given the Ashford matches dataset, we could look to see patterns.

ashford_players <- dplyr::filter(players, team == 'Ashford United')
summary(ashford_players)
