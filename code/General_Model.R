# Get the various models.
source('./code/Models/Normal_Model.R') # model_type='normal'

CreateModel <- function(data, response_var, explanatory_vars, model_type='normal'){
  
  if (model_type=='normal'){
    model <- CreateNormalModel(data=data,
                      response_var=response_var,
                      explanatory_vars=explanatory_vars)
  }

  return(model)
}


