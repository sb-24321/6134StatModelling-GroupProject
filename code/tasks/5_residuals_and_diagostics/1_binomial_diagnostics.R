# Load the binomial model ================================================================
# These models were created in `4_binomial_models/` and saved in `outputs/models/binomial/`

model <- readRDS('./outputs/models/binomial/numeric_saturated_injured.RData')

# Test to see whether the predictors are significant =====================================

# summary also contains: null deviance, residual deviance and AIC
summary(model)

# Convert the coefficents to an odds ratio, then calculate a 95% confidence interval for
# each coefficent.
exp(coef(model))
exp(confint(model))

# Perform a chi squared test =============================================================
anova(model, test = 'Chisq')
