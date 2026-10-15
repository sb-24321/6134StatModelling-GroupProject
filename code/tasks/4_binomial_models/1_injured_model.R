#' We will look at whether having an injury is influenced by the age, total minutes played,
#' training load, previous injuries and bmi of a player.

library("tidyverse")

# As `injured` is the current state of the player, where a player can currently be
# injured (1) or is not currently injured (0), we will aim to fit the model using a
# binomial regression.

# Understand the data surrounding the model we will fit.

players <- read.csv(file='./data/league_players.csv') %>% dplyr::group_by(team)

summary_players <- players %>%
  dplyr::summarise(
                   mean_age=mean(mean(age)),
                   mean_minutes=mean(minutes_played),
                   mean_training_load=mean(training_load),
                   mean_prev_injured=mean(prev_injuries),
                   mean_bmi=mean(bmi)
  )

# View(summary_players)

# As perform a linear transformation on `minutes_played` due to the scale in comparison
# to the other variables. We will now use `minutes_played_ths` to be in 1000s.
players$minutes_played_ths <- players$minutes_played / 1000


# Fit the staurated model.
model <- glm(
                  injured ~ age + minutes_played_ths + training_load + prev_injuries + bmi,
                  family = binomial(link = 'logit'),
                  data = players
)

# Save the model, at this point.
# We will do the diagnostics in `5_residuals_and_diagnostics`
path <- './outputs/models/binomial'
filename <- 'saturated_injured.RData'

dir.create(path, recursive=TRUE, showWarnings=FALSE)
saveRDS(model, file=file.path(path, filename))



