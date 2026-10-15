
# ============================================================
# MTH6134 GROUP PROJECT - WEEK 2
# Normal Linear Regression Exploration
# ============================================================

# Run from the main GitHub repository directory.


# ------------------------------------------------------------
# 1. Load the datasets
# ------------------------------------------------------------

players <- read.csv("./data/league_players.csv")
matches <- read.csv("./data/ashford_matches.csv")

# Identify categorical variables
players$position <- factor(players$position)
players$training_load <- factor(players$training_load)

matches$home_away <- factor(matches$home_away)


# ------------------------------------------------------------
# 2. MODEL 1: Simple linear regression
# Response: minutes_played
# Explanatory variable: age
# ------------------------------------------------------------

model1 <- lm(minutes_played ~ age, data = players)

cat("\n===== MODEL 1: MINUTES PLAYED ~ AGE =====\n")
print(summary(model1))

# Scatterplot with fitted regression line
plot(players$age, players$minutes_played,
     xlab = "Player age",
     ylab = "Minutes played",
     main = "Model 1: Age and minutes played")

abline(model1, col = "red", lwd = 2)


# ------------------------------------------------------------
# 3. MODEL 2: Multiple linear regression
# Response: minutes_played
# Explanatory variables: age, bmi, position
# ------------------------------------------------------------

model2 <- lm(
  minutes_played ~ age + bmi + position,
  data = players
)

cat("\n===== MODEL 2: AGE + BMI + POSITION =====\n")
print(summary(model2))


# ------------------------------------------------------------
# 4. MODEL 3: Multiple linear regression with training load
# Response: minutes_played
# Explanatory variables: age, bmi, position, training_load
# ------------------------------------------------------------

model3 <- lm(
  minutes_played ~ age + bmi + position + training_load,
  data = players
)

cat("\n===== MODEL 3: ADD TRAINING LOAD =====\n")
print(summary(model3))


# ------------------------------------------------------------
# 5. MODEL 4: BMI as a continuous response
# Response: bmi
# Explanatory variables: age, position
# ------------------------------------------------------------

model4 <- lm(
  bmi ~ age + position,
  data = players
)

cat("\n===== MODEL 4: BMI ~ AGE + POSITION =====\n")
print(summary(model4))


# ------------------------------------------------------------
# 6. MODEL 5: Exploratory match regression
# Response: goals_scored
# Explanatory variables: opponent_rank, home_away
#
# Note: goals_scored is count data. A Poisson model may
# be more suitable. This normal model is for comparison.
# ------------------------------------------------------------

model5 <- lm(
  goals_scored ~ opponent_rank + home_away,
  data = matches
)

cat("\n===== MODEL 5: GOALS SCORED =====\n")
print(summary(model5))


# ------------------------------------------------------------
# 7. Compare Models 1, 2 and 3
#
# These models use the same response and observations.
# ------------------------------------------------------------

cat("\n===== PLAYER MODEL COMPARISON =====\n")

comparison <- data.frame(
  Model = c("Model 1", "Model 2", "Model 3"),
  Adjusted_R2 = c(
    summary(model1)$adj.r.squared,
    summary(model2)$adj.r.squared,
    summary(model3)$adj.r.squared
  ),
  Residual_SE = c(
    sigma(model1),
    sigma(model2),
    sigma(model3)
  )
)

print(comparison)

# Nested model comparisons
cat("\n===== NESTED MODEL ANOVA =====\n")

print(anova(model1, model2, model3))


# ------------------------------------------------------------
# 8. Basic diagnostic plots
#
# Residuals vs Fitted:
# Check for patterns and changing spread.
#
# Normal Q-Q:
# Check whether residuals are approximately normal.
# ------------------------------------------------------------

models <- list(
  "Model 1" = model1,
  "Model 2" = model2,
  "Model 3" = model3,
  "Model 4" = model4,
  "Model 5" = model5
)

for (model_name in names(models)) {
  
  current_model <- models[[model_name]]
  
  par(mfrow = c(1, 2))
  
  plot(current_model, which = 1,
       main = paste(model_name, "- Residuals vs Fitted"))
  
  plot(current_model, which = 2,
       main = paste(model_name, "- Normal Q-Q"))
  
}

# Reset plotting layout
par(mfrow = c(1, 1))


# ------------------------------------------------------------
# 9. Save diagnostic plots to the outputs folder
# ------------------------------------------------------------

output_dir <- "./outputs/Week 2/normal regression"

dir.create(output_dir, recursive = TRUE,
           showWarnings = FALSE)

for (i in seq_along(models)) {
  
  png(
    filename = file.path(
      output_dir,
      paste0("model", i, "_diagnostics.png")
    ),
    width = 1200,
    height = 600
  )
  
  par(mfrow = c(1, 2))
  
  plot(models[[i]], which = 1)
  plot(models[[i]], which = 2)
  
  dev.off()
}

cat("\nWeek 2 normal regression analysis complete.\n")
