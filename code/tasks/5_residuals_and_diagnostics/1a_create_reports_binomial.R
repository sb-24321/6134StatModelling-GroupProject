source('./code/tasks/5_residuals_and_diagnostics/1_create_diagnostic_report.R')

# A list of all model names to create reports for.
model_names <- c(
                 'numeric_satuarated_injured',
                 'ashford_players_injured'

)

# Creates a report for each. Saves them in the respective directory.
for (model_name in model_names){
  model <- readRDS(paste0('./outputs/models/binomial/', model_name, '.RData'))
  create_diagnostic_report(model, model_name)
}
