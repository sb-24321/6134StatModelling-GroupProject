#' This file culminates all the various functions developed.
#'
#' As a result, user can import just this file, and have access to all the various function
#' that are developed for this project.

# Modelling
source('./code/Modeller/Modelling/CreateRegressionModel.R') # Create specified models.

# Plotting
source('./code/Modeller/Plotting/DiagnosticPlots.R') # Plot diagnostics for a model.
source('./code/Modeller/Plotting/RegressionPlots.R') 

# Testing 
source('./code/Modeller/Testing/ConfidenceIntervals.R') 

# Misc
source('./code/Modeller/Misc/CreateAllCombinations.R') # All combinations of variables.




