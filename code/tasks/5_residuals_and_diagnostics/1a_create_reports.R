source('./code/tasks/5_residuals_and_diagnostics/1_create_diagnostic_report.R')


model_name <- 'ashford_players_injured'
model <- readRDS(paste0('./outputs/models/binomial/', model_name, '.RData'))
create_diagnostic_report(model, model_name)
