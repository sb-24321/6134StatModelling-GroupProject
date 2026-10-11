##' @title Normal Linear Regression Fitter
##' 
##' @description This file fits all the possible models for invididual dataset, following 
##' the normal assumption.
##'
##' @function DiagnosticPlots; Creates linear model between a response variable and a list
##'   of given elected explanatory variables from a given dataset. The output is a .pdf 
##'   file with summary statistics, plots relating each explanatory variable to the 
##'   response variable and diagnostic plots to help evaluate the effect of the model.
##' 
##' @function RelateAllCombinations: Given a dataset, it automates the process of matching
##'   every possible combination of response and explanatory pairs.
##' 
##' @todo
##' > Relating variables between the two tables.
##'   In context we can relate the ashford matches to the ashford player statistics to
##'   investiage a possible link.
##' > Allow for other models.
##'
##' @author Sami 
##' @date 11/10/26

library("dplyr")

DiagnosticPlots <- function(data, response_var, explanatory_vars, path){
  #' Creates a plot and the diagnostic plot using the data given.
  #'
  #' DiagnosticPlot is a function which creates a linear model between multiple  
  #' explanatory variables and a response variable. 
  #'
  #' @param data; the complete dataset.
  #' @param response_var; the column name of the variable we are taking to be the response.
  #' @param reponse_var; list of column name that will make our linear model.
  #' @param path; The path where we want to save the diagnostic plots.
  
  # Need to formats as character to make the model.
  model_type <- 'N' # what is a our model: N - normal, (to implement other models)
  explanatory_vars <- as.character(unlist(explanatory_vars))
  response_var <- as.character(unlist(response_var))

  # Build and fit the model using all the specified explanatory variables.
  formula <- reformulate(explanatory_vars, response=response_var) # creates model formula.
  model <- lm(formula, data=data) # builds the model using the formula.

  # Create the text for the important model summaries.
  # Will also use the values found to organise the models into good and bad.
  #
  ## F-statistic: 
  # > Want a bigger value (its means it is better than nothing)
  # > ~1 means that the model is the same as the mean.
  # > 3-5 means it can be decent in n is large.
  # > >10 is good
  #
  ## F p-value:
  # > Want a value < 0.05
  #
  ## R squared:
  # > Want a high value (but goes up if we add junk variables)
  #
  ## Adjusted R squared:
  # > Similar to R-squared, but penalises additional variables
  # > Want a value as high as possible
  #
  ## Information Criteria (AIC)
  # > Lower is better, but only used to compare models (cannot be used independently).
  
  model_summary <- summary(model)
  
  f_val <- model_summary$fstatistic[1]
  f_p <- pf(f_val, model_summary$fstatistic[2], model_summary$fstatistic[3], lower.tail = FALSE)

  # The fitted model with: coefficient, variable names and intercept written.
  eq <- paste0(round(coef(model)[1],3), " + ",
               paste("(", paste0(round(coef(model)[-1],3),")", "*",
                       names(coef(model)[-1])), collapse=" + "))

  text <- paste(
                paste(response_var, ' ~ ', paste(explanatory_vars, collapse='+'), '\n', eq, '\n\n\n'),   
                paste('A good model will have: big F-stat (at least >3 depending on n, 10+ is nice), small p-value < 0.05,\n High R and Adj R,\nLow AIC\n'),
                paste("F-statistic:", round(f_val, 5), "on", model_summary$fstatistic[2], "and", model_summary$fstatistic[3], "Degrees of Freedom"),
                paste("F p-value:", round(f_p,5)),
                paste("R-Squared:", round(model_summary$r.squared,5)),
                paste("Adjusted R-Squared:", model_summary$adj.r.squared),
                paste("Root MSE:", sqrt(mean(model_summary$residuals^2))),
                paste("AIC:", AIC(model)),
                sep='\n'
  )

  # We will measure how good using an Adjusted R^2.
  # Blueprint to catagorise models into different folders. Folders must exist beforehand.
  #adj_r <- model_summary$adj.r.squared 
  #if (adj_r >= 0.9){
    #path <- paste0(path, '/excellent_models')
  #} else if (adj_r >= 0.7){
    #path <- paste0(path, '/good_models')
  #} else if (adj_r >= 0.5){
    #path <- paste0(path, '/moderate_models')
  #} else if (adj_r >= 0.3){
    #path <- paste0(path, '/weak_models')
  #} else {
    #path <- paste0(path, '/useless_models')
  #}
    
  filename = paste0(
                    model_type,'-', response_var, '~', 
                    paste(explanatory_vars, collapse='+'), '.pdf')

  path <- paste0(path,'/', filename) 


  
  # We will create a pdf, each page in the pdf will store its own plot for the model.
  # Every page in the pdf will relate to a single model.
  pdf(file=path, width=10, height=8)
  
  # Add the summary data.
  plot.new()
  text(x=0.5, y=0.5, text, cex=1.2)


  # Create a plot for each of the explanatory variables, with their own regression line.
  for (var in explanatory_vars) {
    
    # Plot for a single explanatory variable.
    plot(data[[var]], data[[response_var]],
         main = paste(response_var, "against", var),
         xlab = var,
         ylab = response_var,
         pch = 19,
         col='blue'
    )

    # Draw the regression line. 
    abline(lm(data[[response_var]] ~ data[[var]]),
           col = "red", lwd = 2)
  }

  ## Draws the diagnostic plots, to check for certain assumptions.
  ## Below is a recap of what each plot is, and what we are looking for.
  
  ## which = 1: Residuals vs Fitted          
  # > Checks for linearity, and whether the variance is constant.
  # + Random scatter about 0.
  # - Curve suggest non-linearity, funnel shape suggest non-constant variance.

  ## which = 2: Normal QQ  
  # > Checks whether the residuals are normally distributed.
  # + Points follow the diagonal.
  # - Strong curvature or large deviation near the tails.

  ## which = 3: Scale Location 
  # > Checks for homoscedasticity, (constant residual varience across the fitted values).
  # + Looking for a equally vertical spread.
  # - Funnel pattern, or a trend suggesting a change in varience.

  ## which = 4: Cooks Distance.             
  # > Measures how each point influenced the fitted model.
  # + Point will have a small Cook's Distance.
  # - Large values indicate an influential value.

  ## which = 5: Residuals vs Leverage        
  # > Identifies potentially influential observations, that have a strong effect.
  # + No points with a high leverage and large residuals.
  # - Points beyond Cook's distance.

  ## which = 6: Cook's Distance vs Leverage
  # > Shows how an observations leverage related to its influence.
  # + Point will have a low influence if no points standing out.
  # - Points with have large residuals.

  for (i in 1:6){plot(model, which = i)}
  
  dev.off()
}

RelateAllCombinations <- function(data, path='.'){
  #' For a given dataset, find all possible linear combinations and make a model for it.
  #' The created models will then be saved as individual .pdf's in the `path`.
  #'
  #' @param data; the dataset
  #' @param path; where to save the outputs, .pdf files. (Defaults to the parent directory).
  
  # Can access based on column names.
  col_names <- as.list(colnames(data))
  
  for (i in seq_along(col_names)){
    # Take one variable to be the response variable, other variables will be combined to
    # make the model
    response_var <- col_names[i]
    explanatory_vars <- col_names[-i]
    
    # Creates and store each model, iterate through it later.
    all_combs <- list()
    for (n in seq_along(explanatory_vars)){
      # Creates a unique combination of explanatory variables
      combs <- combn(explanatory_vars, n, simplify = FALSE) 
      for (comb in combs){ # Append
        all_combs[[length(all_combs)+1]] <- comb
      } 
    }

    # Now have all combinations, iterate through, feed each into `DiagnosticPlots`. Same
    # response variable throughout.
    for (j in seq_along(all_combs)) {
      DiagnosticPlots(data=data,
                      response_var=response_var, 
                      explanatory_vars=all_combs[j], 
                      path=path)
    } 
  }
}

Main <- function(){
  # Just get the columns with the numeric entries, its all it can handle right now.

  numeric_matches <- read.csv('./data/ashford_matches.csv') |>
    dplyr::select(!c(home_away))

  numeric_players <- read.csv('./data/league_players.csv') |>
    dplyr::select(!c(team, position))


  RelateAllCombinations(numeric_matches, path='./outputs/Week2/normal_diag_plots')
  RelateAllCombinations(numeric_players, path='./outputs/Week2/normal_diag_plots')
  
  # Clear the environment, prevents previous meddling when running multiple times.
  # Comment out if you wish to use the same environment and variables after execution.
  rm(list=ls())
}

# Uncomment to run.
Main() 
