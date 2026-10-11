##' @title Simply creates any type of model.
##' @description Being able to create a simple framework that easily creates whatever type
##'   of model that the user wants. Built on top of the `normal_diag_plots.R`.
##' @todo 
##' > Actually build it, have you seen the file.

source('./code/Normal_Model.R')

CreateModel <- function(data, response_var, explanatory_vars, model_type='normal'){
  
  if (model_type=='normal'){
    model <- CreateNormalModel(data=data,
                      response_var=response_var,
                      explanatory_vars=explanatory_vars)
  }

  return(model)
}


