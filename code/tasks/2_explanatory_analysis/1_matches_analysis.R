matches <- read.csv('./data/ashford_matches.csv')

# Look to see the data ===================================================================
str(matches)
summary(matches)
# View(matches)

# Calculate the goal difference ==========================================================
goals_diff <- matches$goals_scored - matches$goals_conceded 
sum(matches$goals_scored)  
sum(matches$goals_conceded)
sum(goals_diff)

# compare the performance against differntly ranked teams. ===============================
sort(matches$opponent_rank) 

# Check for missing values ===============================================================
colSums(is.na(matches))





