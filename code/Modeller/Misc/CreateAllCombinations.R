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


