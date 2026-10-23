
# ==========================================================
# MTH6134 - Statistical Modelling II
# Week 4 - Binomial Logistic Regression
# Analysis 2: Ashford United Players
# ==========================================================

# 1. Load data -----------------------------------------------

ashford_players <- read.csv("./data/league_players.csv")

# Original GitHub filter
ashford_players <- subset(
  ashford_players,
  team == "Ashford United"
)

# Original transformation
ashford_players$minutes_played_ths <-
  ashford_players$minutes_played / 1000

# Check the data
str(ashford_players)
summary(ashford_players)
table(ashford_players$injured)
colSums(is.na(ashford_players))

# Keep complete observations
variables <- c(
  "injured", "age", "minutes_played_ths",
  "training_load", "prev_injuries", "bmi"
)

ashford_players <- ashford_players[
  complete.cases(ashford_players[, variables]),
]

stopifnot(all(ashford_players$injured %in% c(0, 1)))

cat(
  "Number of Ashford United players:",
  nrow(ashford_players), "\n"
)

# Check whether both injury outcomes occur
print(table(ashford_players$injured))


# 2. Fit binomial logistic regression models -----------------

# Model 0: Intercept-only model
model0 <- glm(
  injured ~ 1,
  family = binomial(link = "logit"),
  data = ashford_players
)

# Model 1: Original full model
model1 <- glm(
  injured ~ age + minutes_played_ths +
    training_load + prev_injuries + bmi,
  family = binomial(link = "logit"),
  data = ashford_players
)

summary(model0)
summary(model1)


# 3. Compare models ------------------------------------------

# AIC comparison
AIC(model0, model1)

# Likelihood ratio test
anova(model0, model1, test = "Chisq")


# 4. Odds ratios ---------------------------------------------

exp(coef(model1))


# 5. Confidence intervals ------------------------------------

# 95% Wald confidence intervals
confint.default(model1)

# Odds-ratio confidence intervals
exp(confint.default(model1))

# 95% profile-likelihood confidence intervals
exp(confint(model1))


# 6. Predicted probabilities ---------------------------------

predicted_probabilities <- predict(
  model1,
  type = "response"
)

head(predicted_probabilities)

predictions <- data.frame(
  observed_injury = ashford_players$injured,
  predicted_probability = predicted_probabilities
)

head(predictions)


# 7. Diagnostic plots ----------------------------------------

output_dir <- "./outputs/Week 4/ashford_players"

dir.create(
  output_dir,
  recursive = TRUE,
  showWarnings = FALSE
)

png(
  file.path(output_dir, "diagnostic_plots.png"),
  width = 1200,
  height = 1000
)

par(mfrow = c(2, 2))

# Deviance residuals vs fitted probabilities
plot(
  fitted(model1),
  residuals(model1, type = "deviance"),
  main = "Deviance Residuals vs Fitted",
  xlab = "Predicted Injury Probability",
  ylab = "Deviance Residual",
  pch = 19
)
abline(h = 0, col = "red", lty = 2)

# Pearson residuals vs fitted probabilities
plot(
  fitted(model1),
  residuals(model1, type = "pearson"),
  main = "Pearson Residuals vs Fitted",
  xlab = "Predicted Injury Probability",
  ylab = "Pearson Residual",
  pch = 19
)
abline(h = 0, col = "red", lty = 2)

# Cook's distance
plot(
  cooks.distance(model1),
  type = "h",
  main = "Cook's Distance",
  xlab = "Observation",
  ylab = "Cook's Distance"
)
abline(
  h = 4 / nrow(ashford_players),
  col = "red",
  lty = 2
)

# Residuals vs leverage
plot(
  hatvalues(model1),
  residuals(model1, type = "deviance"),
  main = "Residuals vs Leverage",
  xlab = "Leverage",
  ylab = "Deviance Residual",
  pch = 19
)
abline(h = 0, col = "red", lty = 2)

dev.off()


# 8. Save results --------------------------------------------

saveRDS(
  list(model0 = model0, model1 = model1),
  file.path(output_dir, "ashford_injured_models.rds")
)

write.csv(
  predictions,
  file.path(output_dir, "predicted_probabilities.csv"),
  row.names = FALSE
)

results <- capture.output({
  
  cat("WEEK 4 - ASHFORD UNITED\n\n")
  
  cat("NUMBER OF PLAYERS\n")
  print(nrow(ashford_players))
  
  cat("\nINJURY COUNTS\n")
  print(table(ashford_players$injured))
  
  cat("\nMODEL 0 - INTERCEPT ONLY\n")
  print(summary(model0))
  
  cat("\nMODEL 1 - FULL LOGISTIC MODEL\n")
  print(summary(model1))
  
  cat("\nAIC COMPARISON\n")
  print(AIC(model0, model1))
  
  cat("\nLIKELIHOOD RATIO TEST\n")
  print(anova(model0, model1, test = "Chisq"))
  
  cat("\nODDS RATIOS\n")
  print(exp(coef(model1)))
  
  cat("\n95% WALD CONFIDENCE INTERVALS FOR ODDS RATIOS\n")
  print(exp(confint.default(model1)))
  
  cat("\n95% PROFILE-LIKELIHOOD INTERVALS\n")
  print(exp(confint(model1)))
  
})

writeLines(
  results,
  file.path(output_dir, "model_results.txt")
)

cat("\nAshford United analysis completed.\n")
