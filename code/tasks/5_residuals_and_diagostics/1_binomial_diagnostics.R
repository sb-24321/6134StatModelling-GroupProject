# Load the binomial model ================================================================
# These models were created in `4_binomial_models/` and saved in `outputs/models/binomial/`

model <- readRDS('./outputs/models/binomial/numeric_saturated_injured.RData')

# Test to see whether the predictors are significant =====================================
summary(model)

# Convert the coefficents to an odds ratio, then calculate the confidence intervals.
exp(coef(model))
exp(confint(model))

