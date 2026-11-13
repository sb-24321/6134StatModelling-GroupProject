#' Creates the diagnostic plots of a given model. 
#' These plots are: 
#' > Residuals vs Fitted
#' > QQ Plot
#' > Scale-Location
#' > Cook's Distance
#' > Residuals vs Leverage
#' > Cook's Distance vs Leverage*(h/1-h)
#'
#' NOTE: Sometimes it will not be able to create certain diagnostic plots, so there may 
#' be instances of a missing plot, but all the ones that could be plot, will be plot.
#'
#' @param model The model of which we will check using diagnostics.
#' @param path The file path of where to save the model. Default is './outputs/'
#' @param filename The filename of the plot. Leaving blank generates an informative name.
#' @return A .png file of (ideally) six diagnostic plots arranged in a grid stored in `path`.
DiagnosticPlots <- function(model, path='./outputs/', filename=''){

  
  # Extract the variables from the model
  all_vars <- all.vars(formula(model))
  response_var <- all_vars[1]
  explanatory_vars <- paste(all_vars[-1], collapse='+')
  
  # Create the path if it doesnt exist.
  dir.create(path, recursive=TRUE, showWarnings=FALSE)

  # Create the full path
  if (filename == '')
    {filename <- paste0('diag-',
                        family(model)$family, 
                        '~', response_var, '=', 
                        explanatory_vars)
    } 
  filepath <- paste0(path, filename)
  
  # Create an image with 6 sections. There are 6 diagnostic plots. You can see where this
  # is going.
  png(filepath, width = 1800, height = 1800, res = 200, type = 'cairo')
  par(mfrow = c(2, 3)) 

  for (i in 1:6){
    tryCatch(
    plot(model, which = i),
    error = function(e) NULL # try to draw as many plots as possible
    )
  }

 
  dev.off()
}


