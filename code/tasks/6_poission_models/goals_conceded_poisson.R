
# ============================================================
# MTH6134 - Statistical Modelling II
# Week 6: Poisson Regression - Goals Conceded
# ============================================================

# AIM:
# Investigate how opponent rank and home/away status
# are associated with goals conceded.

# ------------------------------------------------------------
# 1. Load and prepare data
# ------------------------------------------------------------

matches <- read.csv("data/ashford_matches.csv")

str(matches)
summary(matches)

matches$home_away <- factor(matches$home_away)

stopifnot(
  all(!is.na(matches$goals_conceded)),
  all(matches$goals_conceded >= 0),
  all(matches$goals_conceded == floor(matches$goals_conceded))
)

out_dir <- "outputs/Week 6/goals_conceded"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)


# ------------------------------------------------------------
# 2. Preliminary count summaries
# ------------------------------------------------------------

mean(matches$goals_conceded)
var(matches$goals_conceded)

table(matches$goals_conceded)


# ------------------------------------------------------------
# 3. Fit Poisson regression models
# ------------------------------------------------------------

model0 <- glm(
  goals_conceded ~ 1,
  family = poisson(link = "log"),
  data = matches
)

model1 <- glm(
  goals_conceded ~ opponent_rank,
  family = poisson(link = "log"),
  data = matches
)

model2 <- glm(
  goals_conceded ~ opponent_rank + home_away,
  family = poisson(link = "log"),
  data = matches
)

model3 <- glm(
  goals_conceded ~ opponent_rank * home_away,
  family = poisson(link = "log"),
  data = matches
)

summary(model1)
summary(model2)
summary(model3)


# ------------------------------------------------------------
# 4. Model comparisons
# ------------------------------------------------------------

AIC(model0, model1, model2, model3)

anova(
  model0, model1, model2, model3,
  test = "Chisq"
)

anova(model2, model3, test = "Chisq")


# ------------------------------------------------------------
# 5. Interpret coefficients
# ------------------------------------------------------------

exp(coef(model2))

exp(confint.default(model2))

# Exponentiated coefficients give multiplicative effects
# on expected goals conceded.
#
# Values above 1 indicate more expected goals conceded.
# Values below 1 indicate fewer expected goals conceded.


# ------------------------------------------------------------
# 6. Goodness of fit and overdispersion
# ------------------------------------------------------------

deviance(model2)
df.residual(model2)

deviance(model2) / df.residual(model2)

phi <- sum(
  residuals(model2, type = "pearson")^2
) / df.residual(model2)

phi

pchisq(
  deviance(model2),
  df = df.residual(model2),
  lower.tail = FALSE
)


# ------------------------------------------------------------
# 7. Quasi-Poisson model
# ------------------------------------------------------------

quasi_model <- glm(
  goals_conceded ~ opponent_rank + home_away,
  family = quasipoisson(link = "log"),
  data = matches
)

summary(quasi_model)

coef(summary(model2))
coef(summary(quasi_model))


# ------------------------------------------------------------
# 8. Predicted goals conceded
# ------------------------------------------------------------

matches$predicted_conceded <- predict(
  model2,
  type = "response"
)

head(
  matches[, c(
    "goals_conceded",
    "opponent_rank",
    "home_away",
    "predicted_conceded"
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
  fitted(model2),
  rstandard(model2, type = "deviance"),
  xlab = "Fitted values",
  ylab = "Standardised deviance residuals",
  main = "Residuals vs Fitted"
)
abline(h = 0, col = "red", lty = 2)

plot(
  fitted(model2),
  residuals(model2, type = "pearson"),
  xlab = "Fitted values",
  ylab = "Pearson residuals",
  main = "Pearson Residuals"
)
abline(h = 0, col = "red", lty = 2)

plot(
  cooks.distance(model2),
  type = "h",
  main = "Cook's Distances",
  xlab = "Observation",
  ylab = "Cook's Distance"
)
abline(h = 4 / nobs(model2), col = "red", lty = 2)

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

cat("Goals conceded analysis complete.\n")
