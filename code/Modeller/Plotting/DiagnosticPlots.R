DiagnosticPlots <- function(model, path='./outputs/'){

  
  # Extract the variables from the model
  all_vars <- all.vars(formula(model))
  response_var <- all_vars[1]
  explanatory_vars <- paste(all_vars[-1], collapse='+')
  
  # Create the path if it doesnt exist.
  dir.create(path, recursive=TRUE, showWarnings=FALSE)

  # Create the full path
  filename <- paste0(family(model)$family, '~', response_var, '=', explanatory_vars)
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


