#' Constructs a confidence interval for each explanatory variable in a given model.
#' 
#' @param model The regression model we will use to create the confidence intervals.
#' @param isNormal The assumption for our interval, setting to `TRUE` means using the 
#'                 normal distribution for the CI, `FALSE` adapts to the model. Default
#'                 is FALSE.
#' @param level The confidence level for the intervals. Default value is 0.95.
#' @return The lower and upper bounds of the confidence intervals for each variable.
ConfidenceInterval <- function(model, isNormal=FALSE, level=0.95){
  
  # If isNormal is FALSE, then we will just send `confint`.
  return(
         ifelse(isNormal, confint.default(model, level=level), confint(model, level=level)
         )


}
