# Weeks 8-9: contingency tables

m <- read.csv("./data/ashford_matches.csv")
p <- read.csv("./data/league_players.csv")

# ---- WEEK 8: two-way table ----
m$result <- factor(ifelse(m$goals_scored > m$goals_conceded, "Win",
                          ifelse(m$goals_scored == m$goals_conceded, "Draw", "Loss")))
m$home_away <- factor(m$home_away)

tab <- table(home_away = m$home_away, result = m$result)
tab
round(prop.table(tab, 1), 2)

test <- chisq.test(tab)
test
test$expected
test$stdres

# same thing as a log-linear model
d <- as.data.frame(tab)
names(d) <- c("home_away", "result", "freq")
indep <- glm(freq ~ home_away + result, family = poisson, data = d)
sat   <- glm(freq ~ home_away * result, family = poisson, data = d)
anova(indep, sat, test = "Chisq")

# ---- WEEK 9: three-way table ----
p$inj  <- ifelse(p$injured == 1, "Yes", "No")
p$prev <- ifelse(p$prev_injuries > 0, "Yes", "No")
p$load <- ifelse(p$training_load >= 4, "High", "Low")

d3 <- as.data.frame(table(inj = p$inj, prev = p$prev, load = p$load))
names(d3)[4] <- "freq"

fit1 <- glm(freq ~ inj * prev * load, family = poisson, data = d3)
drop1(fit1, test = "Chisq")               # can the 3-way term go?

fit2 <- update(fit1, . ~ . - inj:prev:load)
drop1(fit2, test = "Chisq")               # which 2-way terms can go?

fit3 <- update(fit2, . ~ . - prev:load)
drop1(fit3, test = "Chisq")
summary(fit3)
exp(coef(fit3))                           # odds ratios