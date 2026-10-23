
# ============================================================
# MTH6134 - Statistical Modelling II
# Week 6: Poisson Regression - Goals Scored
# ============================================================

# AIM:
# Investigate how opponent rank and home/away status
# are associated with the number of goals scored.

# ------------------------------------------------------------
# 1. Load and prepare data
# ------------------------------------------------------------

matches <- read.csv("data/ashford_matches.csv")

str(matches)
summary(matches)

matches$home_away <- factor(matches$home_away)

# Check count response
stopifnot(
  all(!is.na(matches$goals_scored)),
  all(matches$goals_scored >= 0),
  all(matches$goals_scored == floor(matches$goals_scored))
)

# Create output folder
out_dir <- "outputs/Week 6/goals_scored"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)


# ------------------------------------------------------------
# 2. Preliminary count summaries
# ------------------------------------------------------------

mean(matches$goals_scored)
var(matches$goals_scored)

table(matches$goals_scored)

# The Poisson distribution assumes:
# Variance(Y | X) = E(Y | X)
#
# Overall mean and variance provide a preliminary check,
# but overdispersion must be assessed after fitting.


# ------------------------------------------------------------
# 3. Fit Poisson regression models
# ------------------------------------------------------------

# Model 0: Intercept only
model0 <- glm(
  goals_scored ~ 1,
  family = poisson(link = "log"),
  data = matches
)

# Model 1: Opponent rank
model1 <- glm(
  goals_scored ~ opponent_rank,
  family = poisson(link = "log"),
  data = matches
)

# Model 2: Opponent rank + home/away
model2 <- glm(
  goals_scored ~ opponent_rank + home_away,
  family = poisson(link = "log"),
  data = matches
)

# Model 3: Interaction
model3 <- glm(
  goals_scored ~ opponent_rank * home_away,
  family = poisson(link = "log"),
  data = matches
)

summary(model1)
summary(model2)
summary(model3)


# ------------------------------------------------------------
# 4. Compare models
# ------------------------------------------------------------

# Lower AIC indicates better relative fit,
# while accounting for model complexity.

AIC(model0, model1, model2, model3)

# Analysis of deviance for nested models
anova(
  model0, model1, model2, model3,
  test = "Chisq"
)

# Test whether the interaction is needed
anova(model2, model3, test = "Chisq")


# ------------------------------------------------------------
# 5. Interpret coefficients
# ------------------------------------------------------------

# Exponentiating coefficients gives multiplicative effects
# on the expected number of goals scored.

exp(coef(model2))

# Approximate 95% confidence intervals
exp(confint.default(model2))

# Interpretation:
# exp(beta) > 1: expected goals increase
# exp(beta) < 1: expected goals decrease
#
# For opponent_rank, this is the effect of a one-unit
# increase, holding home_away constant.


# ------------------------------------------------------------
# 6. Goodness of fit and overdispersion
# ------------------------------------------------------------

# Residual deviance relative to residual degrees of freedom
deviance(model2)
df.residual(model2)

deviance(model2) / df.residual(model2)

# Pearson dispersion estimate
phi <- sum(
  residuals(model2, type = "pearson")^2
) / df.residual(model2)

phi

# Approximate goodness-of-fit test
pchisq(
  deviance(model2),
  df = df.residual(model2),
  lower.tail = FALSE
)

# Values of phi substantially greater than 1
# suggest overdispersion.


# ------------------------------------------------------------
# 7. Quasi-Poisson model
# ------------------------------------------------------------

quasi_model <- glm(
  goals_scored ~ opponent_rank + home_away,
  family = quasipoisson(link = "log"),
  data = matches
)

summary(quasi_model)

# Compare coefficient estimates and standard errors
coef(summary(model2))
coef(summary(quasi_model))

# Quasi-Poisson adjusts standard errors for dispersion.
# It does not automatically fix a poorly specified model.


# ------------------------------------------------------------
# 8. Predicted goals
# ------------------------------------------------------------

matches$predicted_goals <- predict(
  model2,
  type = "response"
)

head(
  matches[, c(
    "goals_scored",
    "opponent_rank",
    "home_away",
    "predicted_goals"
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

# Standardised deviance residuals
plot(
  fitted(model2),
  rstandard(model2, type = "deviance"),
  xlab = "Fitted values",
  ylab = "Standardised deviance residuals",
  main = "Residuals vs Fitted"
)
abline(h = 0, col = "red", lty = 2)

# Pearson residuals
plot(
  fitted(model2),
  residuals(model2, type = "pearson"),
  xlab = "Fitted values",
  ylab = "Pearson residuals",
  main = "Pearson Residuals"
)
abline(h = 0, col = "red", lty = 2)

# Cook's distances
plot(
  cooks.distance(model2),
  type = "h",
  main = "Cook's Distances",
  xlab = "Observation",
  ylab = "Cook's Distance"
)
abline(h = 4 / nobs(model2), col = "red", lty = 2)

# Leverage
plot(
  hatvalues(model2),
  rstandard(model2, type = "deviance"),
  xlab = "Leverage",
  ylab = "Standardised deviance residuals",
  main = "Residuals vs Leverage"
)
abline(h = 0, lty = 2)
abline(
  v = 2 * length(coef(model2)) / nobs(model2),
  col = "red",
  lty = 2
)

dev.off()


# ------------------------------------------------------------
# 10. Save outputs
# ------------------------------------------------------------

write.csv(
  matches,
  file.path(out_dir, "predictions.csv"),
  row.names = FALSE
)

write.csv(
  data.frame(
    coefficient = names(coef(model2)),
    estimate = coef(model2),
    multiplicative_effect = exp(coef(model2))
  ),
  file.path(out_dir, "coefficient_effects.csv"),
  row.names = FALSE
)

capture.output(
  summary(model2),
  AIC(model0, model1, model2, model3),
  anova(model0, model1, model2, model3, test = "Chisq"),
  paste("Pearson dispersion:", phi),
  summary(quasi_model),
  file = file.path(out_dir, "model_results.txt")
)

cat("Goals scored analysis complete.\n")
