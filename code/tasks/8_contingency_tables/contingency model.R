
# ============================================================
# MTH6134 - Statistical Modelling II
# Weeks 8-9: Contingency Tables
# Group Project Analysis
# ============================================================

# AIM:
# Week 8: Investigate the association between home/away status
#         and match result for Ashford United.
#
# Week 9: Investigate the association between injury status,
#         previous injuries and training load among players.
#
# METHODS:
# - Two-way and three-way contingency tables
# - Chi-squared tests of independence
# - Poisson log-linear models
# - Likelihood-ratio tests and model simplification
# - Goodness-of-fit assessment
# - Interpretation of interaction terms and odds ratios


# ============================================================
# 1. LOAD AND CHECK THE DATA
# ============================================================

m <- read.csv("./data/ashford_matches.csv")
p <- read.csv("./data/league_players.csv")

# Examine the structure of both datasets
str(m)
str(p)

# Check the relevant variables for missing values
colSums(is.na(m[c(
  "goals_scored",
  "goals_conceded",
  "home_away"
)]))

colSums(is.na(p[c(
  "injured",
  "prev_injuries",
  "training_load"
)]))

# Count the number of observations before removing missing values
nrow(m)
nrow(p)

# Remove observations with missing values in the variables
# required for each analysis
m <- m[complete.cases(m[c(
  "goals_scored",
  "goals_conceded",
  "home_away"
)]), ]

p <- p[complete.cases(p[c(
  "injured",
  "prev_injuries",
  "training_load"
)]), ]

# Check the number of observations remaining
nrow(m)
nrow(p)


# ============================================================
# WEEK 8: TWO-WAY CONTINGENCY TABLE
# Home/away status and match result
# ============================================================


# ------------------------------------------------------------
# 2. CREATE THE MATCH RESULT VARIABLE
# ------------------------------------------------------------

# Classify each match as a win, draw or loss
m$result <- ifelse(
  m$goals_scored > m$goals_conceded, "Win",
  ifelse(
    m$goals_scored == m$goals_conceded, "Draw",
    "Loss"
  )
)

# Convert variables into factors
m$result <- factor(
  m$result,
  levels = c("Loss", "Draw", "Win")
)

m$home_away <- factor(m$home_away)

# Examine the categories
table(m$home_away)
table(m$result)


# ------------------------------------------------------------
# 3. CONSTRUCT THE TWO-WAY CONTINGENCY TABLE
# ------------------------------------------------------------

tab <- table(
  home_away = m$home_away,
  result = m$result
)

# Display observed frequencies
tab

# Calculate row proportions
# These show the distribution of results within each venue
round(prop.table(tab, 1), 2)

# Calculate column proportions
# These show the distribution of venues within each result
round(prop.table(tab, 2), 2)

# Examine marginal totals
margin.table(tab, 1)
margin.table(tab, 2)

# Calculate the grand total
sum(tab)


# ------------------------------------------------------------
# 4. CHI-SQUARED TEST OF INDEPENDENCE
# ------------------------------------------------------------

# Null hypothesis:
# Home/away status and match result are independent.

# Alternative hypothesis:
# There is an association between home/away status and result.

test <- chisq.test(tab)

# Display the test results
test

# Examine expected frequencies under independence
test$expected

# Examine the smallest expected frequency
min(test$expected)

# Examine standardised residuals
test$stdres


# ------------------------------------------------------------
# 5. LOG-LINEAR MODELS FOR THE TWO-WAY TABLE
# ------------------------------------------------------------

# Convert the contingency table into a data frame
d <- as.data.frame(tab)

names(d) <- c(
  "home_away",
  "result",
  "freq"
)

# Model 1: Independence model
# Assumes there is no association between the variables
indep <- glm(
  freq ~ home_away + result,
  family = poisson,
  data = d
)

# Model 2: Saturated model
# Includes the interaction between the variables
sat <- glm(
  freq ~ home_away * result,
  family = poisson,
  data = d
)

# Examine the independence model
summary(indep)

# Compare the independence and saturated models
# The likelihood-ratio test assesses whether the interaction
# improves the model fit
anova(indep, sat, test = "Chisq")


# ------------------------------------------------------------
# 6. GOODNESS OF FIT OF THE INDEPENDENCE MODEL
# ------------------------------------------------------------

# Calculate residual deviance
deviance(indep)

# Calculate residual degrees of freedom
df.residual(indep)

# Calculate goodness-of-fit p-value
pchisq(
  deviance(indep),
  df = df.residual(indep),
  lower.tail = FALSE
)

# Examine fitted frequencies under independence
fitted(indep)


# ============================================================
# WEEK 9: THREE-WAY CONTINGENCY TABLE
# Injury status, previous injuries and training load
# ============================================================


# ------------------------------------------------------------
# 7. CREATE THE THREE CATEGORICAL VARIABLES
# ------------------------------------------------------------

# Injury status
p$inj <- factor(
  ifelse(p$injured == 1, "Yes", "No"),
  levels = c("No", "Yes")
)

# Previous injuries
p$prev <- factor(
  ifelse(p$prev_injuries > 0, "Yes", "No"),
  levels = c("No", "Yes")
)

# Training load
# The cut-off of 4 is a grouping decision that should be
# justified using the training-load scale and its distribution.
p$load <- factor(
  ifelse(p$training_load >= 4, "High", "Low"),
  levels = c("Low", "High")
)

# Examine the distribution of each variable
table(p$inj)
table(p$prev)
table(p$load)

# Examine the original training-load distribution
table(p$training_load)


# ------------------------------------------------------------
# 8. CONSTRUCT THE THREE-WAY CONTINGENCY TABLE
# ------------------------------------------------------------

d3 <- as.data.frame(
  table(
    inj = p$inj,
    prev = p$prev,
    load = p$load
  )
)

names(d3)[4] <- "freq"

# Display the three-way table
d3

# Display the table in array form
xtabs(freq ~ inj + prev + load, data = d3)

# Examine marginal totals for each variable
margin.table(
  xtabs(freq ~ inj + prev + load, data = d3),
  1
)

margin.table(
  xtabs(freq ~ inj + prev + load, data = d3),
  2
)

margin.table(
  xtabs(freq ~ inj + prev + load, data = d3),
  3
)

# Examine injury proportions within each training-load group
prop.table(
  xtabs(freq ~ inj + prev + load, data = d3),
  margin = 3
)


# ------------------------------------------------------------
# 9. FIT THE SATURATED THREE-WAY LOG-LINEAR MODEL
# ------------------------------------------------------------

# The saturated model includes:
# - All three main effects
# - All three two-way interactions
# - The three-way interaction

fit1 <- glm(
  freq ~ inj * prev * load,
  family = poisson,
  data = d3
)

# Examine the saturated model
summary(fit1)

# Check whether the three-way interaction can be removed
drop1(fit1, test = "Chisq")


# ------------------------------------------------------------
# 10. TEST THE THREE-WAY INTERACTION
# ------------------------------------------------------------

# Extract the p-value for the three-way interaction
three_way_test <- drop1(fit1, test = "Chisq")

three_way_p <- three_way_test[
  "inj:prev:load",
  "Pr(>Chi)"
]

three_way_p

# Remove the three-way interaction only if its removal
# does not significantly worsen model fit at the 5% level.

if (three_way_p >= 0.05) {
  
  fit2 <- update(
    fit1,
    . ~ . - inj:prev:load
  )
  
  cat(
    "\nThe three-way interaction is not significant.",
    "\nThe reduced model without the three-way interaction is retained.\n"
  )
  
} else {
  
  fit2 <- fit1
  
  cat(
    "\nThe three-way interaction is significant.",
    "\nThe saturated model is retained.\n"
  )
}

# Examine the selected model
summary(fit2)


# ------------------------------------------------------------
# 11. EXAMINE THE TWO-WAY INTERACTIONS
# ------------------------------------------------------------

# Test whether individual two-way interactions can be removed
drop1(fit2, test = "Chisq")

# In particular, examine the previous-injuries by training-load
# interaction if the three-way interaction has been removed.

if (!is.null(fit2$terms) &&
    "inj:prev:load" %in% attr(terms(fit2), "term.labels")) {
  
  fit_final <- fit2
  
  cat(
    "\nThe three-way interaction was retained.",
    "\nTwo-way interactions are interpreted within this model.\n"
  )
  
} else {
  
  pairwise_tests <- drop1(fit2, test = "Chisq")
  
  prev_load_p <- pairwise_tests[
    "prev:load",
    "Pr(>Chi)"
  ]
  
  prev_load_p
  
  # Remove prev:load only if its removal is not significant
  if (prev_load_p >= 0.05) {
    
    fit_final <- update(
      fit2,
      . ~ . - prev:load
    )
    
    cat(
      "\nThe prev:load interaction is not significant.",
      "\nThe reduced model without this interaction is retained.\n"
    )
    
  } else {
    
    fit_final <- fit2
    
    cat(
      "\nThe prev:load interaction is significant.",
      "\nIt is retained in the model.\n"
    )
  }
}

# Examine the remaining interactions in the selected model
drop1(fit_final, test = "Chisq")


# ------------------------------------------------------------
# 12. COMPARE THE SELECTED MODELS
# ------------------------------------------------------------

# Compare the saturated model with the model without
# the three-way interaction, where applicable.
if (three_way_p >= 0.05) {
  anova(fit1, fit2, test = "Chisq")
}

# Compare the model before and after removing prev:load,
# where applicable.
if (exists("prev_load_p") && prev_load_p >= 0.05) {
  anova(fit2, fit_final, test = "Chisq")
}


# ------------------------------------------------------------
# 13. GOODNESS OF FIT OF THE FINAL MODEL
# ------------------------------------------------------------

# Examine the final model
summary(fit_final)

# Calculate residual deviance
deviance(fit_final)

# Calculate residual degrees of freedom
df.residual(fit_final)

# Calculate goodness-of-fit p-value
pchisq(
  deviance(fit_final),
  df = df.residual(fit_final),
  lower.tail = FALSE
)


# ------------------------------------------------------------
# 14. INTERPRET THE FINAL MODEL COEFFICIENTS
# ------------------------------------------------------------

# Display estimated coefficients
coef(fit_final)

# Exponentiate the coefficients
# Exponentiated interaction coefficients can be interpreted
# as conditional odds ratios where the model structure
# and reference categories allow this interpretation.
exp(coef(fit_final))

# Extract and exponentiate interaction coefficients only
interaction_terms <- grep(
  ":",
  names(coef(fit_final)),
  value = TRUE
)

exp(
  coef(fit_final)[interaction_terms]
)


# ============================================================
# END OF WEEKS 8-9 ANALYSIS
# ============================================================
# ============================================================
# 13. Save important outputs
# ============================================================

# Week 8: contingency table
write.csv(tab,
          "./outputs/week8_contingency_table.csv")

# Week 8: row proportions
write.csv(round(prop.table(tab, 1), 3),
          "./outputs/week8_row_proportions.csv")

# Week 8: expected frequencies
write.csv(test$expected,
          "./outputs/week8_expected_frequencies.csv")

# Week 8: standardised residuals
write.csv(test$stdres,
          "./outputs/week8_standardised_residuals.csv")

# Week 9: three-way contingency table
write.csv(d3,
          "./outputs/week9_three_way_table.csv")

# Save the main model and test results
capture.output(
  summary(fit_final),
  file = "./outputs/week9_final_model_summary.txt"
)

# ============================================================
# End of Weeks 8-9 script
# ============================================================