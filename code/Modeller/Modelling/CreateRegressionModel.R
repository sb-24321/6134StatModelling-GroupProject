
CreateRegressionModel <- function(data, 
                                  response_var, 
                                  explanatory_vars, 
                                  model_type='normal'){
  
  # Formats the variables. Required to fit the models.
  explanatory_vars <- as.character(unlist(explanatory_vars))
  response_var <- as.character(unlist(response_var))
  
  # Create the formula to fit into the model.
  formula <- reformulate(explanatory_vars, response=response_var) 
  
  # Switch case to convert the users chosen model into a model type.
  # NOTE: Add link to argument if needs be.
  model_family <- switch(model_type,
  'normal'=gaussian(),
  'binomial'=binomial(link='logit'),
  'poisson'=poisson(link='log')
  )
  
  # Create and return the model. 
  model <- glm(formula, data=data, family=model_family)
  return(model)
}


