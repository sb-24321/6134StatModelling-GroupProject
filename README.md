# MTH6134 - Statistical Modelling Group Project

This is the repository for the group project in MTH6134 - Statistical Modelling II. The 
repo itself will host the source code and the graphical outputs of the code. 

## Structure
This repository is largely structued into three folders:

6134StatModelling-GroupProject
|-> code/
|-> data/
|-> outputs/

### Code
This folder will hold all the programming done for this project.

##### Modelling
This aim for this is to create an inclusive package, that automates various tasks that we 
see in the lecture and notes. The implementations are generalised to be able to work with 
various combinations of data and based on lectures, notes and labwork. The end result is 
to create a streamlined experience where we are able to focus more on analysis than 
recalling code. 

##### EXAMPLES
This is to create referable snippets of code that utilise `Modelling` in various common
ways, in order to showcase what the Modelling package can do. The plots and outputs are 
in `outputs/diagnostic_plots/` and `outputs/EXAMPLE/`.

### Data
This folder holds all the data to be used in this project.

###### ashford_matches.csv
This dataset contains information about the various matches that Ashford played in a season, 
grouped by Home and Away. The columns are: `home_away` (entries either "Home" or "Away"),
`goals_scored`, `goals_conceded` and `opponent_rank`.

###### league_players.csv
This dataset contains various datapoints about players in the league. The columns are:
`team` (catagorical string), `position` (GK/DEF/MID/FWD), `age`, `minutes_played`,
`training_load`, `prev_injuries`, `bmi` and `injured` (either 1 or 0).

### Outputs
This folder holds all the various graphs and outputs from the various programs in `code/`.

##### EXAMPLE
This directory holds all the plots from the `./code/Examples/` directory. Currently
includes `diagnostic_plots/` which is a grid of plots of various diagnostic plots that 
can help assess the quality of a model. These are organised by dataset, and then by
each variable (acting as the response variable). There is also the `regression_plots` 
which is organised by model family and is a visual representation of the model and the 
effect of the variables.




