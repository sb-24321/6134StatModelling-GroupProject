
# ============================================================
# MTH6134 GROUP PROJECT
# QUESTION 1: GOALS SCORED BY ASHFORD
#
# Research question:
# How do venue (home/away) and opponent rank affect
# the number of goals scored by Ashford?
#
# Method: Poisson regression
# Primary analysis: All 46 matches
# Sensitivity analysis: Investigating Match 8
# ============================================================


# ============================================================
# 1. SET UP AND LOAD DATA
# ============================================================

# Set the output folder
out_dir <- "FINAL/Analysis_1_Goals_Scored/Outputs"

# Create output folder if it does not already exist
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# Load dataset
matches <- read.csv("data/ashford_matches.csv")

# Inspect dataset
str(matches)
summary(matches)


# ============================================================
# 2. DATA CHECKS AND PREPARATION
# ============================================================

# Check required variables
required_vars <- c(
  "goals_scored",
  "home_away",
  "opponent_rank"
)

if (!all(required_vars %in% names(matches))) {
  stop("Required variables are missing from the dataset.")
}

# Check number of observations
if (nrow(matches) != 46) {
  warning("The dataset does not contain the expected 46 matches.")
}

# Check missing values
missing_values <- colSums(is.na(matches[required_vars]))
print(missing_values)

if (any(missing_values > 0)) {
  stop("Missing values detected in the required variables.")
}

# Check goals scored are non-negative integers
if (any(matches$goals_scored < 0) ||
    any(matches$goals_scored != floor(matches$goals_scored))) {
  stop("Goals scored must be non-negative whole numbers.")
}

# Check opponent rank is numeric
if (!is.numeric(matches$opponent_rank) ||
    any(!is.finite(matches$opponent_rank))) {
  stop("Opponent rank must contain valid numeric values.")
}

# Check venue categories
if (!all(unique(matches$home_away) %in% c("Away", "Home"))) {
  stop("Unexpected venue categories detected.")
}

# Set Away as the reference category
matches$home_away <- factor(
  matches$home_away,
  levels = c("Away", "Home")
)

# Check categories and variable summaries
table(matches$home_away)
summary(matches$opponent_rank)
summary(matches$goals_scored)


# ============================================================
# 3. EXPLORATORY DATA ANALYSIS
# ============================================================

# Overall mean and variance of goals scored
mean_goals <- mean(matches$goals_scored)
variance_goals <- var(matches$goals_scored)

cat("Mean goals scored:", mean_goals, "\n")
cat("Variance of goals scored:", variance_goals, "\n")

# Frequency distribution of goals scored
goal_frequency <- table(matches$goals_scored)
print(goal_frequency)

# Summary of goals by venue
venue_summary <- aggregate(
  goals_scored ~ home_away,
  data = matches,
  FUN = function(x) c(
    mean = mean(x),
    variance = var(x)
  )
)

print(venue_summary)

# Boxplot of goals scored by venue
png(
  filename = file.path(out_dir, "goals_by_venue.png"),
  width = 900,
  height = 650
)

boxplot(
  goals_scored ~ home_away,
  data = matches,
  xlab = "Venue",
  ylab = "Goals scored",
  main = "Goals scored by venue"
)

dev.off()

# Scatterplot of goals scored against opponent rank
png(
  filename = file.path(out_dir, "goals_vs_opponent_rank.png"),
  width = 900,
  height = 650
)

plot(
  matches$opponent_rank,
  matches$goals_scored,
  xlab = "Opponent rank",
  ylab = "Goals scored",
  main = "Goals scored against opponent rank",
  pch = 19
)

dev.off()


# ============================================================
# 4. FIT CANDIDATE POISSON REGRESSION MODELS
# ============================================================

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

# Model 2: Opponent rank and venue
model2 <- glm(
  goals_scored ~ opponent_rank + home_away,
  family = poisson(link = "log"),
  data = matches
)

# Model 3: Opponent rank, venue and their interaction
model3 <- glm(
  goals_scored ~ opponent_rank * home_away,
  family = poisson(link = "log"),
  data = matches
)


# ============================================================
# 5. MODEL SELECTION AND COMPARISON
# ============================================================

# Compare Akaike Information Criterion (AIC)
aic_results <- AIC(model0, model1, model2, model3)
print(aic_results)

# Likelihood ratio tests for nested models
lrt_01 <- anova(model0, model1, test = "Chisq")
lrt_12 <- anova(model1, model2, test = "Chisq")
lrt_23 <- anova(model2, model3, test = "Chisq")

print(lrt_01)
print(lrt_12)
print(lrt_23)

# Save model comparison results
capture.output(
  aic_results,
  lrt_01,
  lrt_12,
  lrt_23,
  file = file.path(out_dir, "model_comparisons.txt")
)


# ============================================================
# 6. INTERPRETATION OF THE SELECTED MODEL
# ============================================================

# Model 2 is selected as the main-effects model.
selected_model <- model2

# Model summary
selected_summary <- summary(selected_model)
print(selected_summary)

# Exponentiated coefficients (rate ratios)
rate_ratios <- exp(coef(selected_model))
print(rate_ratios)

# 95% Wald confidence intervals for rate ratios
rate_ratio_ci <- exp(confint.default(selected_model))
print(rate_ratio_ci)

# Combine estimates and confidence intervals
effects_table <- data.frame(
  Term = names(rate_ratios),
  Rate_Ratio = as.numeric(rate_ratios),
  Lower_95_CI = rate_ratio_ci[, 1],
  Upper_95_CI = rate_ratio_ci[, 2]
)

print(effects_table)

write.csv(
  effects_table,
  file = file.path(out_dir, "coefficient_effects.csv"),
  row.names = FALSE
)


# ============================================================
# 7. GOODNESS OF FIT AND DISPERSION
# ============================================================

# Residual deviance and degrees of freedom
residual_deviance <- deviance(selected_model)
residual_df <- df.residual(selected_model)

# Deviance-based dispersion estimate
deviance_dispersion <- residual_deviance / residual_df

# Approximate goodness-of-fit p-value
gof_p_value <- pchisq(
  residual_deviance,
  df = residual_df,
  lower.tail = FALSE
)

# Pearson dispersion estimate
pearson_dispersion <- sum(
  residuals(selected_model, type = "pearson")^2
) / residual_df

cat("Residual deviance:", residual_deviance, "\n")
cat("Residual degrees of freedom:", residual_df, "\n")
cat("Deviance dispersion:", deviance_dispersion, "\n")
cat("Pearson dispersion:", pearson_dispersion, "\n")
cat("Approximate GOF p-value:", gof_p_value, "\n")


# ============================================================
# 8. QUASI-POISSON SUPPLEMENTARY CHECK
# ============================================================

# Fit a quasi-Poisson model to allow for overdispersion
quasi_model <- glm(
  goals_scored ~ opponent_rank + home_away,
  family = quasipoisson(link = "log"),
  data = matches
)

quasi_summary <- summary(quasi_model)
print(quasi_summary)

# Compare coefficient standard errors
poisson_comparison <- selected_summary$coefficients
quasi_comparison <- quasi_summary$coefficients

standard_error_comparison <- data.frame(
  Term = rownames(poisson_comparison),
  Poisson_SE = poisson_comparison[, "Std. Error"],
  Quasi_Poisson_SE = quasi_comparison[, "Std. Error"]
)

print(standard_error_comparison)

write.csv(
  standard_error_comparison,
  file = file.path(out_dir, "standard_error_comparison.csv"),
  row.names = FALSE
)


# ============================================================
# 9. PREDICTED GOALS
# ============================================================

# Predicted expected number of goals for each match
matches$predicted_goals <- predict(
  selected_model,
  type = "response"
)

# Save actual and predicted goals
predictions <- data.frame(
  Actual_Goals = matches$goals_scored,
  Predicted_Goals = matches$predicted_goals,
  Venue = matches$home_away,
  Opponent_Rank = matches$opponent_rank
)

write.csv(
  predictions,
  file = file.path(out_dir, "predicted_goals.csv"),
  row.names = FALSE
)


# ============================================================
# 10. MODEL DIAGNOSTICS
# ============================================================

# Four-panel diagnostic plot
png(
  filename = file.path(out_dir, "model_diagnostics.png"),
  width = 1200,
  height = 1000
)

par(mfrow = c(2, 2))

# Residuals against fitted values
plot(
  fitted(selected_model),
  residuals(selected_model, type = "deviance"),
  xlab = "Fitted values",
  ylab = "Deviance residuals",
  main = "Residuals vs fitted"
)
abline(h = 0, lty = 2)

# Pearson residuals
plot(
  fitted(selected_model),
  residuals(selected_model, type = "pearson"),
  xlab = "Fitted values",
  ylab = "Pearson residuals",
  main = "Pearson residuals"
)
abline(h = 0, lty = 2)

# Cook's distance
plot(
  cooks.distance(selected_model),
  type = "h",
  xlab = "Observation",
  ylab = "Cook's distance",
  main = "Influential observations"
)

# Residuals against leverage
plot(
  selected_model,
  which = 5
)

dev.off()

par(mfrow = c(1, 1))

# Residuals against opponent rank
png(
  filename = file.path(
    out_dir,
    "residuals_against_opponent_rank.png"
  ),
  width = 1000,
  height = 650
)

plot(
  matches$opponent_rank,
  residuals(selected_model, type = "pearson"),
  xlab = "Opponent rank",
  ylab = "Pearson residuals",
  main = "Residuals against opponent rank",
  pch = 19
)

abline(h = 0, lty = 2)

lines(
  lowess(
    matches$opponent_rank,
    residuals(selected_model, type = "pearson")
  ),
  lwd = 2
)

dev.off()


# ============================================================
# 11. INFLUENTIAL OBSERVATIONS
# ============================================================

# Calculate diagnostic measures for every match
diagnostics <- data.frame(
  Match = seq_len(nrow(matches)),
  Goals_Scored = matches$goals_scored,
  Opponent_Rank = matches$opponent_rank,
  Venue = matches$home_away,
  Cooks_Distance = cooks.distance(selected_model),
  Leverage = hatvalues(selected_model),
  Standardised_Residual = rstandard(selected_model)
)

# Identify the five most influential observations
top_influential <- diagnostics[
  order(diagnostics$Cooks_Distance, decreasing = TRUE),
][1:5, ]

print(top_influential)

write.csv(
  top_influential,
  file = file.path(out_dir, "influential_observations.csv"),
  row.names = FALSE
)


# ============================================================
# 12. SENSITIVITY ANALYSIS: INVESTIGATE MATCH 8
# ============================================================

# Identify the eighth observation
match_8 <- matches[8, ]
print(match_8)

# Fit the original model using all 46 matches
model_full <- glm(
  goals_scored ~ opponent_rank + home_away,
  family = poisson(link = "log"),
  data = matches
)

# Temporarily exclude Match 8
matches_without_8 <- matches[-8, ]

# Refit the same model using the remaining 45 matches
model_without_8 <- glm(
  goals_scored ~ opponent_rank + home_away,
  family = poisson(link = "log"),
  data = matches_without_8
)

# Compare coefficient estimates
sensitivity_coefficients <- data.frame(
  Term = names(coef(model_full)),
  Full_Model = coef(model_full),
  Without_Match_8 = coef(model_without_8)
)

sensitivity_coefficients$Difference <-
  sensitivity_coefficients$Without_Match_8 -
  sensitivity_coefficients$Full_Model

print(sensitivity_coefficients)

write.csv(
  sensitivity_coefficients,
  file = file.path(out_dir, "sensitivity_coefficients.csv"),
  row.names = FALSE
)

# Compare exponentiated coefficients
full_rate_ratios <- exp(coef(model_full))
reduced_rate_ratios <- exp(coef(model_without_8))

# Compare confidence intervals
full_ci <- exp(confint.default(model_full))
reduced_ci <- exp(confint.default(model_without_8))

sensitivity_intervals <- data.frame(
  Term = names(full_rate_ratios),
  Full_Rate_Ratio = as.numeric(full_rate_ratios),
  Full_Lower_95_CI = full_ci[, 1],
  Full_Upper_95_CI = full_ci[, 2],
  Without_Match_8_Rate_Ratio = as.numeric(reduced_rate_ratios),
  Reduced_Lower_95_CI = reduced_ci[, 1],
  Reduced_Upper_95_CI = reduced_ci[, 2]
)

print(sensitivity_intervals)

write.csv(
  sensitivity_intervals,
  file = file.path(out_dir, "sensitivity_confidence_intervals.csv"),
  row.names = FALSE
)


# ============================================================
# 13. MODEL SELECTION SENSITIVITY: WITHOUT MATCH 8
# ============================================================

# Model 0: Intercept only
model0_no8 <- glm(
  goals_scored ~ 1,
  family = poisson(link = "log"),
  data = matches_without_8
)

# Model 1: Opponent rank
model1_no8 <- glm(
  goals_scored ~ opponent_rank,
  family = poisson(link = "log"),
  data = matches_without_8
)

# Model 2: Opponent rank and venue
model2_no8 <- glm(
  goals_scored ~ opponent_rank + home_away,
  family = poisson(link = "log"),
  data = matches_without_8
)

# Model 3: Interaction
model3_no8 <- glm(
  goals_scored ~ opponent_rank * home_away,
  family = poisson(link = "log"),
  data = matches_without_8
)

# Compare AIC using the same 45 observations
aic_no8 <- AIC(
  model0_no8,
  model1_no8,
  model2_no8,
  model3_no8
)

print(aic_no8)

# Likelihood ratio tests
lrt_01_no8 <- anova(model0_no8, model1_no8, test = "Chisq")
lrt_12_no8 <- anova(model1_no8, model2_no8, test = "Chisq")
lrt_23_no8 <- anova(model2_no8, model3_no8, test = "Chisq")

print(lrt_01_no8)
print(lrt_12_no8)
print(lrt_23_no8)

# Goodness of fit for the reduced Model 2
deviance_no8 <- deviance(model2_no8)
df_no8 <- df.residual(model2_no8)

gof_no8 <- pchisq(
  deviance_no8,
  df = df_no8,
  lower.tail = FALSE
)

cat("Reduced model residual deviance:", deviance_no8, "\n")
cat("Reduced model residual degrees of freedom:", df_no8, "\n")
cat("Reduced model GOF p-value:", gof_no8, "\n")

# Save sensitivity model comparisons
capture.output(
  aic_no8,
  lrt_01_no8,
  lrt_12_no8,
  lrt_23_no8,
  summary(model2_no8),
  list(
    Residual_Deviance = deviance_no8,
    Residual_DF = df_no8,
    GOF_P_Value = gof_no8
  ),
  file = file.path(out_dir, "sensitivity_model_comparisons.txt")
)

# Centre opponent rank
matches$opponent_rank_c <- matches$opponent_rank - mean(matches$opponent_rank)

 # Linear model
model_linear <- glm(goals_scored ~ opponent_rank_c + home_away,
                    family = poisson(link = "log"),
                    data = matches)

# Quadratic model
model_quadratic <- glm(
  goals_scored ~ opponent_rank_c +
    I(opponent_rank_c^2) + home_away,
  family = poisson(link = "log"),
  data = matches)

 # Compare models
AIC(model_linear, model_quadratic)

anova(model_linear, model_quadratic, test = "Chisq")
summary(model_quadratic)
# ============================================================
# 14. SAVE FINAL MODEL RESULTS
# ============================================================

capture.output(
  selected_summary,
  file = file.path(out_dir, "selected_model_summary.txt")
)

capture.output(
  quasi_summary,
  file = file.path(out_dir, "quasi_poisson_summary.txt")
)

capture.output(
  list(
    Residual_Deviance = residual_deviance,
    Residual_DF = residual_df,
    Deviance_Dispersion = deviance_dispersion,
    Pearson_Dispersion = pearson_dispersion,
    GOF_P_Value = gof_p_value
  ),
  file = file.path(out_dir, "goodness_of_fit.txt")
)


# ============================================================
# END OF QUESTION 1 ANALYSIS
# ============================================================

cat("\nQuestion 1 analysis completed successfully.\n")
cat("Primary model: Poisson regression, Model 2.\n")
cat("Primary dataset: All 46 matches.\n")
cat("Outputs saved in:", out_dir, "\n")
