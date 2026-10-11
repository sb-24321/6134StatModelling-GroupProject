CreateModel <- function(data, response_var, explanatory_vars, model_type='normal'){
  
  # Formats the variables. Required to fit the models.
  explanatory_vars <- as.character(unlist(explanatory_vars))
  response_var <- as.character(unlist(response_var))

  # Build and fit the model using all the specified explanatory variables.
  formula <- reformulate(explanatory_vars, response=response_var) 

  if (model_type=='normal'){
    model <- lm(formula, data=data) 
  } else if (model_type=='binomial'){ 
    model <- glm(formula, data=data, family=binomial(link='logit')) 
  } else if (model_type=='poisson'){
    model <- glm(formula, data=data, family=poisson(link='log')) 
  }

  return(model)
}


