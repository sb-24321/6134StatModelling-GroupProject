PlotRegression <- function(model){
  #' Plots the regressions of a model.
  
  # Get the data from the model
  data <- model.frame(model)

  x <- data[[2]]
  y <- data[[1]]

  print(data)
  print(data[[2]])
  print(data[[1]])

}
