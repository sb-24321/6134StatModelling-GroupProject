library("tidyverse")

#' We will look at whether having an injury is influenced by the age, total minutes played,
#' training load, previous injuries and bmi of a player.

# As `injured` is the current state of the player, where a player can currently be
# injured (1) or is not currently injured (0), we will aim to fit the model using a
# binomial regression.

# Load the Players dataset ===============================================================
# Will summarise and understand the datasets before plotting.

players <- read.csv('./data/league_players.csv')

summary_players <- players |>
  dplyr::group_by(team) |>
  dplyr::summarise(
                   mean_age=mean(age),
                   mean_minutes=mean(minutes_played),
                   mean_training_load=mean(training_load),
                   mean_prev_injured=mean(prev_injuries),
                   mean_bmi=mean(bmi))

# Create Regression Model ================================================================
# Fit a biomial regression model using just the numeric values (so not `team` or `position`)

# Minutes played is a large quantity, so transform to get suitable values
players$minutes_played_ths <- players$minutes_played / 1000

# Fit the staurated model.
model <- glm(
                  injured ~ age + minutes_played_ths + training_load + prev_injuries + bmi,
                  family = binomial(link = 'logit'),
                  data = players
)

# Save the model, at this point
# We will do the diagnostics in `5_residuals_and_diagnostics`

path <- './outputs/models/binomial'
filename <- 'numeric_saturated_injured.RData'

dir.create(path, recursive=TRUE, showWarnings=FALSE)
saveRDS(model, file=file.path(path, filename))



