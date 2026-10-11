# Get the various models.
source('./code/Models/Normal_Model.R') 
source('./code/Models/Binomial_Model.R')

CreateModel <- function(data, response_var, explanatory_vars, model_type='normal'){
  
  if (model_type=='normal'){
    model <- CreateNormalModel(data=data,
                      response_var=response_var,
                      explanatory_vars=explanatory_vars)
  } else if (model_type=='binomial'){ 
    model <- CreateBinomialModel(data=data,
                      response_var=response_var,
                      explanatory_vars=explanatory_vars)
  }


  return(model)
}


