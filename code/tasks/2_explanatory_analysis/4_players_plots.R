library('tidyverse')

players <- read.csv('./data/league_players.csv')

path <- "./outputs/plots/week_2/players"

# Plot various quantities against each other =============================================

# Get a sense of the average league playtime.
plot <- ggplot2::ggplot(data = players) +
  ggplot2::geom_histogram(mapping = aes(minutes_played), binwidth = 100)
ggplot2::ggsave(plot, 
                filename = 'league_minutes_played.png', 
                path = path)

# See how teams utilise their players.
plot <- ggplot2::ggplot(data = players) +
  ggplot2::geom_histogram(mapping = aes(minutes_played), binwidth = 450) +
  ggplot2::facet_wrap(~ team, nrow=6)
ggplot2::ggsave(plot, 
                filename = 'team_minutes_played.png', 
                path = path)

# See how each team utilise their players.
plot <- ggplot2::ggplot(data = players) +
  ggplot2::geom_histogram(mapping = aes(minutes_played), binwidth = 450) +
  ggplot2::facet_wrap(~ team, nrow=6)
ggplot2::ggsave(plot, 
                filename = 'team_minutes_played.png', 
                path = path)

# See how teams utilise their players.
plot <- ggplot2::ggplot(data = players) +
  ggplot2::geom_jitter(mapping = aes(y = minutes_played, x = training_load, colour=team))
ggplot2::ggsave(plot, 
                filename = 'load_against_minutes_gb_team.png', 
                path = path)

# See how teams exert their players.
plot <- ggplot2::ggplot(data = players) +
  ggplot2::geom_jitter(mapping = aes(y = minutes_played, x = training_load, colour=position))
ggplot2::ggsave(plot, 
                filename = 'load_against_minutes_gb_position.png', 
                path = path)

# See how position number
plot <- ggplot2::ggplot(data = players) +
  ggplot2::geom_bar(mapping = aes(position,fill=team))
ggplot2::ggsave(plot, 
                filename = 'bar_position.png', 
                path = path)

# See how teams workload number
plot <- ggplot2::ggplot(data = players) +
  ggplot2::geom_bar(mapping = aes(training_load, fill=team))
ggplot2::ggsave(plot, 
                filename = 'training_load.png', 
                path = path)






