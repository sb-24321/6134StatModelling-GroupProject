#' Executes all scripts from the './code' directory.

# Gets all files to run. =================================================================
scripts <- list.files(
  path = "./code/tasks", # just get the code from the `tasks` directory
  pattern = "\\.R$",
  full.names = TRUE,
  recursive = TRUE
)

# Run each file seperatly, print a warning if it could not be run ========================
for (script in scripts){
  cat(paste0("Running: ", script, "\n"))
  tryCatch(
    source(script), 
    error = function(e) cat(paste0("WEE WOO WEE WOO COULD NOT RUN: ", script, "\n"))
  ) 
}


