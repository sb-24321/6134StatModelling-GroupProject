PlotRegression <- function(model, path='./outputs/', filename=''){
  #' Plots the regressions of a model.

  # Get the data from the given model: response variable and explanatory variables
  data <- model.frame(model)
  res_var <- names(data)[1] 
  ex_vars <- names(data)[-1]

  y <- data[[res_var]] # get the response values

  # Create the path if it doesnt exist.
  explanatory_vars <- paste(ex_vars, collapse='+')
  dir.create(path, recursive=TRUE, showWarnings=FALSE)

  if (filename==''){
    filename <- paste0('plot-', family(model)$family, '~', res_var, '=', paste0(explanatory_vars)
    )
  }

  
  filepath <- paste0(path, filename)
  pdf(filepath)

  # Extract the model from the data.
  coefs <- coef(model)
  terms <- paste0(ifelse(coefs>=0, " + ", " - "),
                  abs(round(coefs, 3)),
                  " x ",
                  names(coefs)
  )

  # Write the model to the file.
  txt <- paste0('Regression Type: ', family(model)$family, ' (', family(model)$link, ')\n\n',
                'response: ', res_var, '\n\n',
                round(coefs[1], 3),
                paste(terms[-1], collapse="\n")

  )

  plot.new()
  text(txt, x=0.5, y=0.5, adj=c(0.5, 0.5))

  for (ex_var in ex_vars){
    x <- data[[ex_var]]
    
    
    # Plot the model.
    plot(y=y, x=x, 
         main=paste0(res_var,' against ',ex_var),
         xlab=ex_var,
         ylab=res_var,
         col='blue',
    )
    
    # Draw the regression line for that model.
    line_model <- glm(y ~ x, family=family(model))
    abline(line_model, col='red')

  }


  dev.off()
  


}
