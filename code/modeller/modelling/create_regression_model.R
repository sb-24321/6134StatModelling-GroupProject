#' A flexible method of creating a Regression Model.
#'
#' @param data The dataframe containing all the data relating to the variables.
#' @param response_var The column name of the variable to be the response variable.
#' @param explanatory_vars The column names of the variable to be the explanatory variable(s)
#' @param model_type What type of model to fit for the response: 'Normal' (default), 'Binomial or 'Poisson'
#' @param link What type of link to fit the model with. Leave for default option.
#' @return A regression model, same functionality as glm().
CreateRegressionModel <- function(data, 
                                  response_var, 
                                  explanatory_vars, 
                                  model_type='normal',
                                  link=''
                                  ){
  
  # Formats the variables. Required to fit the models.
  ex_vars <- as.character(unlist(explanatory_vars))
  res_var <- as.character(unlist(response_var))
  
  # Create the formula to fit into the model.
  formula <- reformulate(ex_vars, response=res_var) 
  
  # Switch case to convert the users chosen model into a model type.
  # Use the default link for the family if none is given by the user.
  model_family <- switch(model_type,
  'normal'=gaussian(),
  'binomial'=binomial(link=ifelse(link=='', 'logit', link)),
  'poisson'=poisson(link=ifelse(link=='', 'log', link))
  )
  
  # Create and return the model. 
  model <- glm(formula, data=data, family=model_family)
  return(model)
}


