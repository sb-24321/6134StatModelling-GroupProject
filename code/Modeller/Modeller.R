#' This file culminates all the various functions developed.
#'
#' As a result, user can import just this file, and have access to all the various function
#' that are developed for this project.
#'
#' The idea is to create an interface that does commonly required tasks in-line with the 
#' lectures, notes and labs. This is NOT an all encompassing package that does every single
#' little task, but its main objective is to create and manage general linear model 
#' objects simply.
#'
#' As a result the designed end goal is to be able to focus more on performing analysis
#' rather than implementations, as all the implementations included in this package are 
#' aimed to be general use.
#' 

# Modelling
source('./code/Modeller/Modelling/CreateRegressionModel.R') # Create specified models.

# Plotting
source('./code/Modeller/Plotting/DiagnosticPlots.R') 
source('./code/Modeller/Plotting/RegressionPlots.R') 

# Testing 
source('./code/Modeller/Testing/ConfidenceIntervals.R') 

# Misc
source('./code/Modeller/Misc/CreateAllCombinations.R') # All combinations of variables.




