#' This is based upon the `MTH6134 Practical Week 4`.

source('./code/Modeller/Modeller.R')

# ---------- Cold - No Cold ----- Total #
# Placebo    335      76           411  #
# Vitamin C  302     105           407  # 
#                                       #
# Totals     637     181           818  #
# ------------------------------------- #

# Creates the table as seen above.
vitc1_data <- data.frame("cold" = c(rep(1,335), rep(0,(411-335)),
rep(1,302), rep(0,407-302)), "treat" = c(rep(0,411), rep(1,407)))


# We will fit the data using a bionomial regression model.
vitc1_model <- CreateRegressionModel(data=vitc_data,
                     response_var='cold',
                     explanatory_vars='treat',
                     model_type='binomial')

# Find the confidence interval of each variable in the model at a confidence level defined
# in `level`. In this example it is at a 95% confidence interval.
print(ConfidenceInterval(vitc_model, level=0.95)) 


