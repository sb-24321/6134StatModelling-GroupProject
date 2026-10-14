source('./code/Modeller/Modeller.R')

library('dplyr')
library('ggplot2')

matches <- read.csv('./data/ashford_matches.csv')

# View(matches)

str(matches)
# 'data.frame':   46 obs. of  4 variables:
# $ home_away     : chr  "Home" "Home" "Home" "Home" ...
# $ goals_scored  : int  2 0 1 2 3 0 0 8 1 2 ...
# $ goals_conceded: int  1 1 0 0 1 2 0 0 1 0 ...
# $ opponent_rank : int  1 3 4 6 20 2 18 24 7 23 ...

summary(matches)
#     home_away   goals_scored   goals_conceded   opponent_rank  
# Length   :46   Min.   :0.000   Min.   :0.0000   Min.   : 1.00  
# N.unique : 2   1st Qu.:0.000   1st Qu.:0.0000   1st Qu.: 6.25  
# N.blank  : 0   Median :1.000   Median :1.0000   Median :13.00  
# Min.nchar: 4   Mean   :1.304   Mean   :0.8261   Mean   :12.65  
# Max.nchar: 4   3rd Qu.:2.000   3rd Qu.:1.0000   3rd Qu.:18.75  
#                Max.   :8.000   Max.   :3.0000   Max.   :24.00  

goals_diff <- matches$goals_scored - matches$goals_conceded 
sum(matches$goals_scored)  
sum(matches$goals_conceded)
sum(goals_diff) 
sort(matches$opponent_rank)








