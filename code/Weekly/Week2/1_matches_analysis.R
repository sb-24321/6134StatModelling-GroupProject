source('./code/Modeller/Modeller.R')

matches <- read.csv('./data/ashford_matches.csv')

# View(matches)
print(str(matches))
summary(matches)

goals_diff <- matches$goals_scored - matches$goals_conceded 
sum(matches$goals_scored)  
sum(matches$goals_conceded)
sum(goals_diff) 
sort(matches$opponent_rank)








