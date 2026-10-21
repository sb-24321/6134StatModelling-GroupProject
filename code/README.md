# code

This directory contains all the programming done for this project. The main coding scripts
are located in `code/tasks` and are organised into weekly topics based on what we do
during that week.

## File Structure

```text
code/tasks
├── 2_explanatory_models/               # Manipulating that data to find patterns.
├── 3_initial_model_building/           # Seeing which models will suit different explanatory variables.               
├── 4_binomial_models/                  # Creating a binomial model using the data.            
└── 5_residuals_and_diagnostics/        # Testing to see whether a model is suitable and looking to optimise.            
```

## File Descriptions

### tasks

#### 2_explanatory_models
Performs initial explanatory analysis on the data, creates plots for help better understand
patterns and hints at structure for future models.

| File | Author(s) | Code Description | Output(s) |
| :-- | :-- | :-- | :-- |
| 1_matches_analysis.R | Sami, Nahim | Performs initial numerical analysis on `ashford_matches.csv` | Summaries the dataset into various statistics. |
| 2_matches_plots.R | Sami| Creates plots on the data in `ashford_matches.csv` | Plots found in `./outputs/plots/week_2/matches/`. |
| 3_matches_analysis.R | Sami, Nahim | Performs initial numerical analysis on `league_players.csv` | Summaries the dataset into various statistics. |
| 4_players_plots.R | Sami | Creates plots on the data in `league_players.csv` | Plots found in `./outputs/plots/week_2/players/`. |
| 5_normal_regression.R | Nahim | Creates simple linear models and plots the diagnostics | Plots found in `./outputs/plots/week_2/normal_regression/`|

#### 3_initial_model_building
Aims to organise models into different types of regression depending on the type of the data

| File | Author(s) | Code Description | Output(s) |
| :-- | :-- | :-- | :-- |


#### 4_binomial_models
Using the analysis from `./code/tasks/3_initial_model_building` we will build binomial models
where there response variable can only be two values (modelled as 1 and 0).

| File | Author(s) | Code Description | Output(s) |
| :-- | :-- | :-- | :-- |
| 1_injured_model.R | Sami | Fits a binomial model where we relate injury to all other variables (apart from team and position) | A model saved in `./outputs/models/binomial/`|



#### 5_residuals_and_diagnostics
Checks to see whether a model is well-built and looks to optimise.

| File | Author(s) | Code Description | Output(s) |
| :-- | :-- | :-- | :-- |
| 1_binomial_diagnostics.R | Sami | A general implemention for diagnosing binomial regression models  | Report saved in `./outputs/plots/5_plots` |
