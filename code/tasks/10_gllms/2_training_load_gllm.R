library(lme4)
library(lmerTest)   # adds p-values to lmer output
library(performance) # for ICC and diagnostics

players <- read.csv("./data/league_players.csv")
players$position <- factor(players$position)

m1 <- lmer(minutes_played ~ training_load + age + position + (1 | team),
           data = players)

print(summary(m1))
print(confint(m1, method = "Wald"))   # 95% confidence intervals for fixed effects
print(icc(m1))                        # share of variance lying between teams
print(check_model(m1))                # residual and random-effect diagnostics

# Question: Is a higher training load associated with more minutes played over the season
#   after accounting for age, position and team.
#
# Conclusions:
# > Training load is positively associated with more minutes played.
#   > Each one point increase in training load is associated with 141 more minutes, while
#     other variables remain constant.
# > Age has no significant association.
# > Position matters a greater deal. 
#   > When compared with defenders goalkeepers play more minutes, and midfielders and 
#     attackers play less.
# > Team membership doesnt matter, with an ICC of 0.02
