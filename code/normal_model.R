CreateNormalModel <- function(data, 
                        response_var, 
                        explanatory_vars){

  #' Creates a linear model under the normal assumptions.
  #' 
  #' @param data; the full dataset involving the response and explanatory variables.
  #' @param response_var; the column we are taking to be our response variable.
  #' @param explanatory_vars; a list of variables we consider to be our explanatory 
  #'                          variables.
  #' @return Our fitted linear model.
  
  # Formats the variables. Required to fit the models.
  explanatory_vars <- as.character(unlist(explanatory_vars))
  response_var <- as.character(unlist(response_var))

  # Build and fit the model using all the specified explanatory variables.
  formula <- reformulate(explanatory_vars, response=response_var) 
  model <- lm(formula, data=data) 

  return(model) 
}
