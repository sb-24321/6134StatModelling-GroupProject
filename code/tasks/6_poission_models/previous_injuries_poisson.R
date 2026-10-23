
# ============================================================
# MTH6134 - Statistical Modelling II
# Week 6: Poisson Regression - Previous Injuries
# ============================================================

# AIM:
# Investigate associations between previous injury counts
# and player characteristics.

# ------------------------------------------------------------
# 1. Load and prepare data
# ------------------------------------------------------------

players <- read.csv("data/league_players.csv")

str(players)
summary(players)

players$position <- factor(players$position)
players$training_load <- factor(players$training_load)

stopifnot(
  all(!is.na(players$prev_injuries)),
  all(players$prev_injuries >= 0),
  all(players$prev_injuries == floor(players$prev_injuries))
)

out_dir <- "outputs/Week 6/previous_injuries"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)


# ------------------------------------------------------------
# 2. Preliminary count summaries
# ------------------------------------------------------------

mean(players$prev_injuries)
var(players$prev_injuries)

table(players$prev_injuries)


# ------------------------------------------------------------
# 3. Fit Poisson regression models
# ------------------------------------------------------------

# Model 0: Intercept only
model0 <- glm(
  prev_injuries ~ 1,
  family = poisson(link = "log"),
  data = players
)

# Model 1: Age
model1 <- glm(
  prev_injuries ~ age,
  family = poisson(link = "log"),
  data = players
)

# Model 2: Age and position
model2 <- glm(
  prev_injuries ~ age + position,
  family = poisson(link = "log"),
  data = players
)

# Model 3: Age, position and training load
model3 <- glm(
  prev_injuries ~ age + position + training_load,
  family = poisson(link = "log"),
  data = players
)

summary(model1)
summary(model2)
summary(model3)


# ------------------------------------------------------------
# 4. Compare models
# ------------------------------------------------------------

AIC(model0, model1, model2, model3)

anova(
  model0, model1, model2, model3,
  test = "Chisq"
)

# Check whether training load adds explanatory value
anova(model2, model3, test = "Chisq")


# ------------------------------------------------------------
# 5. Interpret coefficients
# ------------------------------------------------------------

exp(coef(model3))

exp(confint.default(model3))

# exp(beta) gives a multiplicative effect on
# expected previous injury counts.
#
# Age: effect of an additional year.
# Position: compared with reference position.
# Training load: compared with reference load category.
#
# These are associations, not necessarily causal effects.


# ------------------------------------------------------------
# 6. Goodness of fit and overdispersion
# ------------------------------------------------------------

deviance(model3)
df.residual(model3)

deviance(model3) / df.residual(model3)

phi <- sum(
  residuals(model3, type = "pearson")^2
) / df.residual(model3)

phi

pchisq(
  deviance(model3),
  df = df.residual(model3),
  lower.tail = FALSE
)


# ------------------------------------------------------------
# 7. Quasi-Poisson model
# ------------------------------------------------------------

quasi_model <- glm(
  prev_injuries ~ age + position + training_load,
  family = quasipoisson(link = "log"),
  data = players
)

summary(quasi_model)

# Compare coefficients and standard errors
coef(summary(model3))
coef(summary(quasi_model))


# ------------------------------------------------------------
# 8. Predicted injury counts
# ------------------------------------------------------------

players$predicted_injuries <- predict(
  model3,
  type = "response"
)

head(
  players[, c(
    "prev_injuries",
    "age",
    "position",
    "training_load",
    "predicted_injuries"
  )]
)


# ------------------------------------------------------------
# 9. Diagnostic plots
# ------------------------------------------------------------

png(
  file.path(out_dir, "diagnostics.png"),
  width = 1200,
  height = 900
)

par(mfrow = c(2, 2))

plot(
  fitted(model3),
  rstandard(model3, type = "deviance"),
  xlab = "Fitted values",
  ylab = "Standardised deviance residuals",
  main = "Residuals vs Fitted"
)
abline(h = 0, col = "red", lty = 2)

plot(
  fitted(model3),
  residuals(model3, type = "pearson"),
  xlab = "Fitted values",
  ylab = "Pearson residuals",
  main = "Pearson Residuals"
)
abline(h = 0, col = "red", lty = 2)

plot(
  cooks.distance(model3),
  type = "h",
  main = "Cook's Distances",
  xlab = "Observation",
  ylab = "Cook's Distance"
)
abline(h = 4 / nobs(model3), col = "red", lty = 2)

plot(
  hatvalues(model3),
  rstandard(model3, type = "deviance"),
  xlab = "Leverage",
  ylab = "Standardised deviance residuals",
  main = "Residuals vs Leverage"
)
abline(h = 0, lty = 2)
abline(
  v = 2 * length(coef(model3)) / nobs(model3),
  col = "red",
  lty = 2
)

dev.off()


# ------------------------------------------------------------
# 10. Save outputs
# ------------------------------------------------------------

write.csv(
  players,
  file.path(out_dir, "predictions.csv"),
  row.names = FALSE
)

write.csv(
  data.frame(
    coefficient = names(coef(model3)),
    estimate = coef(model3),
    multiplicative_effect = exp(coef(model3))
  ),
  file.path(out_dir, "coefficient_effects.csv"),
  row.names = FALSE
)

capture.output(
  summary(model3),
  AIC(model0, model1, model2, model3),
  anova(model0, model1, model2, model3, test = "Chisq"),
  paste("Pearson dispersion:", phi),
  summary(quasi_model),
  file = file.path(out_dir, "model_results.txt")
)

cat("Previous injuries analysis complete.\n")
