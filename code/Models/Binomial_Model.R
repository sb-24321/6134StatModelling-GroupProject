CreateBinomialModel <- function(data, 
                        response_var, 
                        explanatory_vars
                        link='logit'){
  
  # Formats the variables. Required to fit the models.
  explanatory_vars <- as.character(unlist(explanatory_vars))
  response_var <- as.character(unlist(response_var))

  # Build and fit the model using all the specified explanatory variables.
  formula <- reformulate(explanatory_vars, response=response_var) 
  model <- glm(formula, data=data, family=binomial(link=link)) 

  return(model) 
}
