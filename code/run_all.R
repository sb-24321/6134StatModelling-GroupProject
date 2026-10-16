#' Executes all scripts from the './code' directory.

# Gets the paths for all the scripts.
scripts <- list.files(
  path = "./code/tasks", # just get the code from the `tasks` directory.
  pattern = "\\.R$",
  full.names = TRUE,
  recursive = TRUE
)

for (script in scripts){
  cat(paste0("Running: ", script, "\n"))
  tryCatch(
    source(script), 
    error = function(e) cat(paste0("WEE WOO WEE WOO COULD NOT RUN: ", script, "\n"))
  ) 
}


