library('tidyverse')

matches <- read.csv('./data/ashford_matches.csv')

# Color the plots by home and away. Now we can try and compare the home pefomance against
# the away performance.

plot <- ggplot2::ggplot(data=matches) +
  ggplot2::geom_point(mapping = aes(x=opponent_rank, y=goals_scored, color=home_away)) +
  ggplot2::facet_wrap(~ home_away, nrow=2)
ggplot2::ggsave(plot=plot, filename='rank_against_scored.png', path='./outputs/plots/week_2/matches')

plot <- ggplot2::ggplot(data=matches) +
  ggplot2::geom_point(mapping = aes(x=opponent_rank, y=goals_conceded, color=home_away)) +
  ggplot2::facet_wrap(~ home_away, nrow=2)
ggplot2::ggsave(plot=plot, filename='rank_against_conceded.png', path='./outputs/plots/week_2/matches')

# See how position number
plot <- ggplot2::ggplot(data = matches) +
  ggplot2::geom_bar(mapping = aes(goals_conceded, fill=home_away))
ggplot2::ggsave(plot, filename = 'bar_conceded.png', path = './outputs/plots/week_2/matches')





