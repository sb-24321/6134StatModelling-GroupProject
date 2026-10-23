
# ==========================================================
# MTH6134 - Statistical Modelling II
# Week 4 - Binomial Logistic Regression
# Analysis 1: All Players
# ==========================================================

# 1. Load data -----------------------------------------------

players <- read.csv("./data/league_players.csv")

# Original transformation: minutes played in thousands
players$minutes_played_ths <- players$minutes_played / 1000

# Check the data
str(players)
summary(players)
table(players$injured)
colSums(is.na(players))

# Use the same observations in both models
variables <- c(
  "injured", "age", "minutes_played_ths",
  "training_load", "prev_injuries", "bmi"
)

players <- players[complete.cases(players[, variables]), ]

# Check the binary response
stopifnot(all(players$injured %in% c(0, 1)))

cat("Number of players:", nrow(players), "\n")


# 2. Fit binomial logistic regression models -----------------

# Model 0: Intercept-only model
model0 <- glm(
  injured ~ 1,
  family = binomial(link = "logit"),
  data = players
)

# Model 1: Original full model
model1 <- glm(
  injured ~ age + minutes_played_ths +
    training_load + prev_injuries + bmi,
  family = binomial(link = "logit"),
  data = players
)

# View model results
summary(model0)
summary(model1)


# 3. Compare models ------------------------------------------

# AIC comparison
AIC(model0, model1)

# Likelihood ratio (drop-in-deviance) test
anova(model0, model1, test = "Chisq")


# 4. Odds ratios ---------------------------------------------

# Logistic coefficients are on the log-odds scale.
# Exponentiating gives odds ratios.

exp(coef(model1))


# 5. Confidence intervals ------------------------------------

# 95% Wald confidence intervals
confint.default(model1)

# Convert coefficient intervals into odds-ratio intervals
exp(confint.default(model1))

# 95% profile-likelihood intervals (may take longer)
exp(confint(model1))


# 6. Predicted probabilities ---------------------------------

# Predicted probability of injury for each player
predicted_probabilities <- predict(
  model1,
  type = "response"
)

head(predicted_probabilities)

# Compare observed outcomes and fitted probabilities
predictions <- data.frame(
  observed_injury = players$injured,
  predicted_probability = predicted_probabilities
)

head(predictions)


# 7. Diagnostic plots ----------------------------------------

output_dir <- "./outputs/Week 4/all_players"

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

# Deviance residuals against fitted probabilities
plot(
  fitted(model1),
  residuals(model1, type = "deviance"),
  main = "Deviance Residuals vs Fitted",
  xlab = "Predicted Injury Probability",
  ylab = "Deviance Residual",
  pch = 19
)
abline(h = 0, col = "red", lty = 2)

# Pearson residuals against fitted probabilities
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
abline(h = 4 / nrow(players), col = "red", lty = 2)

# Residuals against leverage
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

# Save fitted models
saveRDS(
  list(model0 = model0, model1 = model1),
  file.path(output_dir, "injured_models.rds")
)

# Save predictions
write.csv(
  predictions,
  file.path(output_dir, "predicted_probabilities.csv"),
  row.names = FALSE
)

# Save numerical results in a text file
results <- capture.output({
  
  cat("WEEK 4 - ALL PLAYERS\n\n")
  
  cat("NUMBER OF PLAYERS\n")
  print(nrow(players))
  
  cat("\nINJURY COUNTS\n")
  print(table(players$injured))
  
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

cat("\nAll players analysis completed.\n")
