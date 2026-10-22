library("tidyverse")

#' We will look at whether having an injury is influenced by the age, total minutes played,
#' training load, previous injuries and bmi of ashford players.

# Get the Ashford United players =========================================================


ashford_players <- read.csv('./data/league_players.csv') |>
  dplyr::filter(team == 'Ashford United')

summary_players <- ashford_players |>
  dplyr::summarise(
                   mean_age=mean(age),
                   mean_minutes=mean(minutes_played),
                   mean_training_load=mean(training_load),
                   mean_prev_injured=mean(prev_injuries),
                   mean_bmi=mean(bmi))

# Create Regression Model ================================================================

# Minutes played is a large quantity, so transform to get suitable values
ashford_players$minutes_played_ths <- ashford_players$minutes_played / 1000

# Fit the staurated model.
model <- glm(
                  injured ~ age + minutes_played_ths + training_load + prev_injuries + bmi,
                  family = binomial(link = 'logit'),
                  data = ashford_players
)

# Save the model, at this point
path <- './outputs/models/binomial'
filename <- 'ashford_players_injured.RData'

dir.create(path, recursive=TRUE, showWarnings=FALSE)
saveRDS(model, file=file.path(path, filename))
