#' For a given response variable, it will formulate all possible combinations of the other
#' variables.
#'
#' @param data The dataframe containing the response variable and all the other variables.
#' @param reponse_var The variable that will not be used to make a combination.
#' @return A list with all the unqiue combination of variables excluding the response. 
CreateAllCombinations<- function(data, response_var){
  col_names <- as.list(colnames(data))

  # Remove the response variable
  explanatory_vars <- col_names[col_names != response_var]

  # Create all possible combinations of the remaining variables.
  all_combs <- list()

  for (n in seq_along(explanatory_vars)){
    combs <- combn(explanatory_vars, n, simplify = FALSE) 
    for (comb in combs){ # Append
      all_combs[[length(all_combs)+1]] <- comb
    } 
  }
return (all_combs)
}


