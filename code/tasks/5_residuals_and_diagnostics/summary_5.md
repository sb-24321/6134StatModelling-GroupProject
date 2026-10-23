# Week 5 - Residuals and Diagnostics 

## 1. Week Objective
The aim for this week was model diagnostics, which is used to see how well the model explained the pattern in the data.

## 2. Process
We began by creating `1_create_diagnostic_report.R` which was able to create and save a .pdf report that: summarised a model, created confidence intervals for each of the response variables,
performed a chi-squared test on the model and created diagnostic plots. From this, we were able to create `1a_create_reports_binomial.R` which was able to iterate through all
the models and then create a report for each. Later, we also created `2_diagnostic_plots.R` which was able to provide us with further analysis points for diagnosing models as well as 
`3_ashford_exploration_code.R` which looked ahead and created Poisson regression models using dummy variables and compared their statistics and outputs.

## 3. Findings
To begin, we will recall that the `league_players.csv` dataset has the following columns: team, players, age, minutes_played, training_load, previous_injuries, bmi and injured. 

### 3.1 Saturated model of injuries of all players
This was a binomial regression model that created a model where injured was the explanatory variable, and our response variables were: age, minutes_played, training_load, previous_injuries and bmi. The aim was to see 
whether these variable had any effect on whether a player could be injured at the current time. We chose to model this using a binomial regression since injured was a binary variable; either in the state of 1 (to 
denote that a player was injured) or 0 (to denote that a player was not injured). Our initial hypothesis was that all these variable would have some level of effect. Most in particular was minutes_played and training_load as
we assumed that the harder a player was worked, the likelihood of injury would increase in addition to previous_injuries as a player with a track record of being injured would also be at risk of being injured again.

### 3.2 Ashford players injuries
As we were given the match data for Ashford United, we also saw it fit to create a binomial model that modelled just the Ashford player injuries. Our initial hypothesis was the same as before where all the variables would 
have an effect with the same reasons as stated before. 

## 4. Week 6 Overview
For week 6, we will use our findings from week 3 to create Poisson regression models. We will then similarly diagnose the models
