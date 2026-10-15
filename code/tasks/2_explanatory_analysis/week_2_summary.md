# Week 2 – Exploratory Data Analysis and Normal Linear Regression

## 1. Objectives

The aim of Week 2 was to explore the two datasets provided for the MTH6134 group project and investigate potential relationships using descriptive statistics, visualisations and normal linear regression.

The analysis focused on:

- Examining dataset structures and identifying variable types.
- Checking for missing values.
- Calculating descriptive statistics for Ashford United's matches and players.
- Producing exploratory plots to investigate distributions and relationships.
- Fitting and comparing normal linear regression models.
- Examining regression assumptions using diagnostic plots.
- Identifying possible directions for further modelling.

The analysis uses simulated data from the 2023/24 Midland Premier League season.

------------------------------------------------------------------------

## 2. Match Dataset – Exploratory Analysis

### 2.1 Dataset structure

The `ashford_matches.csv` dataset contains **46 observations and 4 variables**, representing Ashford United's matches during the season.

| Variable | Description | Statistical type |
|------------------------|------------------------|------------------------|
| `home_away` | Whether the match was played at home or away | Binary categorical |
| `goals_scored` | Goals scored by Ashford United | Discrete count |
| `goals_conceded` | Goals conceded by Ashford United | Discrete count |
| `opponent_rank` | Opponent's league ranking | Ordinal |

Missing-value checks confirmed that **none of the four variables contained missing observations**.

### 2.2 Descriptive statistics

| Statistic                     | Value |
|-------------------------------|------:|
| Total matches                 |    46 |
| Total goals scored            |    60 |
| Total goals conceded          |    38 |
| Overall goal difference       |   +22 |
| Mean goals scored per match   |  1.30 |
| Mean goals conceded per match |  0.83 |
| Median goals scored           |     1 |
| Median goals conceded         |     1 |
| Maximum goals scored          |     8 |
| Maximum goals conceded        |     3 |
| Median opponent rank          |    13 |

Ashford United scored more goals than they conceded overall, producing a positive goal difference of 22.

The team scored approximately 1.30 goals per match and conceded approximately 0.83 goals per match.

The maximum of eight goals scored in one match is considerably higher than the average, suggesting an unusually high-scoring observation worth investigating.

### 2.3 Exploratory visualisations

Three exploratory plots were examined to investigate goals scored, goals conceded and opponent ranking.

**Goals scored and opponent ranking**

- Opponent rankings ranged approximately from 1 to 24.
- Most matches involved scoring between 0 and 3 goals.
- One match involved scoring 8 goals.
- Similar goal totals occurred against opponents from different ranking positions.
- Home and away matches were displayed separately.

The plot showed substantial variation in goals scored, without a clearly separated pattern across opponent rankings.

**Goals conceded distribution**

- Goals conceded ranged from 0 to 3.
- Most matches involved conceding either 0 or 1 goal.
- Conceding 2 goals was less common, while conceding 3 was relatively rare.
- Both home and away matches were represented across the plotted categories.

**Goals conceded and opponent ranking**

- Most observations involved conceding 0 or 1 goal.
- Matches with 2 or 3 goals conceded occurred less frequently.
- Similar concession totals were observed against opponents at different rankings.
- Home and away observations overlapped across opponent rankings.

Overall, the exploratory plots showed that Ashford United's goals scored and conceded varied across opponents, with no visually clear separation by opponent ranking alone.

The unusually high observation of 8 goals scored may be important when assessing the suitability of later regression models.

------------------------------------------------------------------------

## 3. Player Dataset – Exploratory Analysis

### 3.1 Dataset structure

The `league_players.csv` dataset contains **620 observations and 8 variables**, representing players from across the league.

| Variable | Description | Statistical type |
|------------------------|------------------------|------------------------|
| `team` | Player's team | Nominal categorical |
| `position` | Playing position: GK, DEF, MID or FWD | Nominal categorical |
| `age` | Player's age in years | Numerical, recorded in whole years |
| `minutes_played` | Total minutes played | Numerical, recorded in whole minutes |
| `training_load` | Training load rating from 1 to 5 | Ordinal |
| `prev_injuries` | Number of previous injuries | Discrete count |
| `bmi` | Body mass index | Continuous numerical |
| `injured` | Whether the player was injured (0 or 1) | Binary |

Missing-value checks confirmed that **none of the eight variables contained missing observations**.

An Ashford United subset was also created for team-specific descriptive analysis.

### 3.2 Ashford United player statistics

The Ashford United subset contains **25 players**.

| Statistic                      |       Value |
|--------------------------------|------------:|
| Number of players              |          25 |
| Mean age                       | 25.36 years |
| Mean minutes played            |       2,708 |
| Mean training load             |        3.00 |
| Mean previous injuries         |        0.84 |
| Mean BMI                       |       23.19 |
| Number recorded as injured     |           4 |
| Proportion recorded as injured |         16% |

The average Ashford United player was approximately 25 years old and recorded 2,708 minutes played.

Four of the 25 players were recorded as injured, corresponding to 16% of the squad.

These statistics provide an initial description of Ashford United's players. The regression analyses below use the full league player dataset rather than only the Ashford subset.

### 3.3 Exploratory visualisations

Eight exploratory plots were examined, covering training load, minutes played, team differences and playing positions.

**Training load distribution by team**

- Training load values ranged from 1 to 5.
- Level 3 was the most frequent value.
- Level 4 was the second most frequent, followed by level 2.
- Levels 1 and 5 occurred least frequently.
- Broadly similar patterns appeared across teams.

The distribution was concentrated around moderate training load levels.

**Minutes played distributions**

The overall minutes played plots showed:

- Most observations concentrated approximately between 2,000 and 3,200 minutes.
- Fewer observations below 1,500 minutes.
- Fewer observations above 3,500 minutes.
- A concentration around the middle of the plotted range, with thinner tails.

The league-wide histogram similarly showed the greatest concentration between approximately 2,000 and 3,000 minutes.

When examined by team:

- Most teams had observations between approximately 1,500 and 3,500 minutes.
- Several teams included players approaching 4,000 minutes.
- Some teams included players with relatively low playing time.
- Team distributions overlapped substantially.

The approximate ranges are based on the plot descriptions and should not be treated as exact observed minimum and maximum values.

**Training load and minutes played**

The overall scatterplot and plots grouped by team and position showed:

- Considerable variation in minutes played within individual training load levels.
- Both relatively high and low playing times occurring at multiple training load levels.
- Substantial overlap between teams.
- Substantial overlap between playing positions.
- No clearly separated team or position clusters.

These plots indicate that training load alone does not visually explain all the variation in playing time.

The regression analysis below investigates whether training load contributes explanatory information after accounting for other player characteristics.

**Playing position distribution**

Four playing positions were represented: DEF, MID, FWD and GK.

- Defenders and midfielders formed the largest groups.
- Forwards were less numerous.
- Goalkeepers formed the smallest group.
- Players from all teams were represented within the position categories.

Overall, the exploratory player analysis identified playing position and training load as potentially useful explanatory variables for further modelling of minutes played.

------------------------------------------------------------------------

## 4. Normal Linear Regression Analysis

### 4.1 Models fitted

Five normal linear regression models were fitted using `lm()` in R.

| Model   | Response         | Explanatory variables                  |
|---------|------------------|----------------------------------------|
| Model 1 | `minutes_played` | `age`                                  |
| Model 2 | `minutes_played` | `age + bmi + position`                 |
| Model 3 | `minutes_played` | `age + bmi + position + training_load` |
| Model 4 | `bmi`            | `age + position`                       |
| Model 5 | `goals_scored`   | `opponent_rank + home_away`            |

Models 1–4 used the full league player dataset of 620 observations. Model 5 used the Ashford United match dataset of 46 observations.

Categorical explanatory variables were converted into factors where appropriate. Training load was treated as a categorical factor in Model 3.

### 4.2 Models 1–3: Explaining minutes played

**Model 1 – Age only**

The fitted equation was:

`Predicted minutes played = 2616.05 - 3.02 × Age`

The estimated age coefficient was approximately -3.02 minutes per additional year of age.

However, age was not statistically significant (p = 0.682), and the model had an R² of approximately 0.0003.

The scatterplot showed considerable variation in playing time and a nearly horizontal fitted regression line.

**Finding:** Age alone explained virtually none of the observed variation in minutes played.

**Model 2 – Adding BMI and playing position**

Model 2 included age, BMI and playing position.

The model's R² increased to approximately 0.2391.

Age (p = 0.897) and BMI (p = 0.935) were not individually statistically significant.

Playing position showed statistically significant associations with minutes played.

Using defenders (DEF) as the reference category:

| Position   | Estimated difference in minutes |
|------------|--------------------------------:|
| Forward    |                         -604.08 |
| Goalkeeper |                         +624.58 |
| Midfielder |                         -304.20 |

All three position coefficients were statistically significant at the 5% level.

Holding age and BMI constant, goalkeepers were estimated to play more minutes than defenders, while forwards and midfielders were estimated to play fewer.

**Finding:** Playing position contributed substantially more explanatory information than age alone.

**Model 3 – Adding training load**

Model 3 extended Model 2 by including training load as a categorical explanatory variable.

The model achieved an R² of approximately 0.2817.

Playing position remained statistically significant, while age and BMI remained individually non-significant.

Using training load level 1 as the reference category:

| Training load | Estimated difference in minutes |  p-value |
|---------------|--------------------------------:|---------:|
| Level 2       |                         +148.73 |    0.310 |
| Level 3       |                         +348.38 |    0.014 |
| Level 4       |                         +431.45 |   0.0029 |
| Level 5       |                         +607.35 | \< 0.001 |

Training load levels 3, 4 and 5 had statistically significant positive coefficients relative to level 1, after accounting for age, BMI and position.

The estimated differences generally increased across the training load categories.

**Finding:** Training load provided additional explanatory information about playing time, although the relationship should not be interpreted as causal.

### 4.3 Comparison of Models 1–3

Because Models 1–3 used the same response variable and observations, their fit statistics could be compared.

| Measure                 | Model 1 | Model 2 | Model 3 |
|-------------------------|--------:|--------:|--------:|
| R²                      |  0.0003 |  0.2391 |  0.2817 |
| Adjusted R²             | -0.0013 |  0.2329 |  0.2711 |
| Residual standard error |   710.5 |   621.9 |   606.2 |

Model 3 had the highest adjusted R² and lowest residual standard error.

Nested-model ANOVA comparisons showed:

- **Model 1 vs Model 2:** Adding BMI and position significantly improved model fit (F = 50.71, p \< 0.001).
- **Model 2 vs Model 3:** Adding training load significantly improved model fit (F = 9.04, p \< 0.001).

Model 3 therefore provided the strongest in-sample fit among the three playing-time models investigated.

However, its R² of 0.2817 means approximately 72% of the observed variation in minutes played remained unexplained.

The comparison does not establish which model would perform best when predicting new observations.

### 4.4 Model 4 – Explaining BMI

Model 4 investigated whether BMI was associated with age and playing position.

The model had:

- R² = 0.0055.
- Adjusted R² = -0.0009.
- Residual standard error = 1.509.
- Overall F-test p-value = 0.490.

Neither age nor the individual position coefficients were statistically significant at the 5% level.

**Finding:** Age and playing position explained very little of the observed variation in BMI.

### 4.5 Model 5 – Explaining goals scored

Model 5 investigated goals scored using opponent ranking and home/away status.

The model had:

- R² = 0.2144.
- Adjusted R² = 0.1779.
- Residual standard error = 1.28.
- Overall F-test p-value = 0.0056.

The estimated coefficients were:

| Variable             | Coefficient | p-value |
|----------------------|------------:|--------:|
| Opponent rank        |     +0.0681 |  0.0149 |
| Home match (vs away) |     +0.8696 |  0.0262 |

Holding match location constant, a one-place increase in opponent rank was associated with approximately 0.068 additional goals scored.

Holding opponent rank constant, home matches were associated with approximately 0.87 additional goals compared with away matches.

Both coefficients were statistically significant at the 5% level.

This result provides evidence of associations within the fitted model, even though the exploratory scatterplot showed considerable variation and overlap.

**Important limitation:** Goals scored is a non-negative count variable. Normal linear regression was used for initial exploration, but a count-data model such as Poisson regression may be more appropriate.

------------------------------------------------------------------------

## 5. Regression Diagnostics

Residuals vs fitted plots and normal Q-Q plots were produced for all five models to assess potential departures from regression assumptions.

| Model | Main diagnostic observations |
|------------------------------------|------------------------------------|
| Model 1 | Large residual variation, narrow fitted-value range and noticeable Q-Q tail deviations |
| Model 2 | Clusters of fitted values, no obvious strong curved pattern and some Q-Q tail deviations |
| Model 3 | Some differences in residual spread and mild Q-Q tail deviations |
| Model 4 | No obvious strong curved pattern; Q-Q plot approximately linear, but very weak model fit |
| Model 5 | Large positive residual for observation 8 and pronounced upper-tail departure in the Q-Q plot |

### Key diagnostic findings

**Models 1–3**

Model 1 showed very weak explanatory power and substantial residual variation.

Models 2 and 3 improved the fit, although their residual plots still showed variability that the models did not explain.

The Q-Q plots for Models 2 and 3 were reasonably close to the reference line through much of the distribution, with deviations in the tails.

**Model 4**

The residual plots did not show an obvious strong curved pattern, and the Q-Q plot was approximately linear.

However, reasonably plausible residual behaviour does not compensate for the model explaining almost none of the variation in BMI.

**Model 5**

Observation 8 had an unusually large positive residual of approximately +5.49 goals.

The Q-Q plot showed a pronounced departure from the reference line at the upper tail.

These diagnostics raise concerns about the normality assumption and the suitability of a normal linear regression for goals scored.

The high-scoring match identified during exploratory analysis may be relevant to this diagnostic issue.

Overall, the diagnostic plots highlighted the importance of assessing model assumptions rather than relying only on R² values and p-values.

------------------------------------------------------------------------

## 6. Overall Findings

The main findings from Week 2 were:

1.  **Data completeness:** Both datasets contained no missing values.

2.  **Match performance:** Ashford United scored 60 goals and conceded 38 across 46 matches, producing a goal difference of +22.

3.  **Player characteristics:** The Ashford subset contained 25 players, with four recorded as injured.

4.  **Exploratory player patterns:** Training load was concentrated around level 3, while most players recorded moderate-to-high playing time. Team and position groups overlapped substantially in the exploratory plots.

5.  **Playing-time regression:** Age alone explained virtually none of the variation in minutes played. Adding position and training load substantially improved the fit.

6.  **Model comparison:** Model 3 was the strongest of the three playing-time models based on in-sample fit, but considerable unexplained variation remained.

7.  **BMI regression:** Age and position provided little explanatory information about BMI.

8.  **Goals-scored regression:** Opponent rank and home/away status were statistically significant in the exploratory normal regression, but diagnostic concerns limit confidence in the normal modelling assumptions.

The results represent exploratory associations rather than established causal relationships.

------------------------------------------------------------------------

## 7. Implications for Future Analysis

The Week 2 work identified several potential directions for later modelling.

**Binomial regression**

The binary `injured` variable could be investigated using a binomial model, with potential explanatory variables including age, position, training load, BMI and previous injuries.

**Poisson regression**

Goals scored, goals conceded and previous injuries are count variables and may be candidates for Poisson regression, subject to checking the relevant assumptions.

The diagnostic concerns in Model 5 provide a particular reason to revisit goals scored using a count-data model.

**Further model assessment**

Future work may involve additional diagnostics, investigating unusual observations and comparing alternative models.

The final selection of analyses will depend on the group project brief and the questions the group is required to address.

------------------------------------------------------------------------

## 8. Supporting Files

### R scripts

The Week 2 work is recorded in:

- `matches analysis.R`
- `matches plots.R`
- `players analysis.R`
- `players plots.R`
- `normal linear regression.R`

### Saved outputs

The plots and regression diagnostics are stored in:

- `outputs/Week 2/matches/`
- `outputs/Week 2/players/`
- `outputs/Week 2/normal regression/`

The R scripts contain the full calculations, fitted models and reproducible analysis. This summary records the methods, principal results and interpretations without duplicating every Console output.

------------------------------------------------------------------------

## 9. Week 2 Status

Week 2 exploratory analysis and normal linear regression work has been documented.

The findings are provisional and can be revisited as further modelling methods are introduced and the full group project brief becomes available.
