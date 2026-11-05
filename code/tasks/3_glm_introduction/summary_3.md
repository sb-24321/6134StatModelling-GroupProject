# Week 3 summary: setting up GLMs

Script: `week3_glm.R`. Outputs (CSVs, plots, model summaries) are written to `outputs/Week 3/` when it is run.

**Note:** R was not available when this was prepared, so the script has not been run. The numbers below were cross-checked independently in Python and should match what R prints. No binomial or Poisson models are fitted here, as requested.

## 1. Responses and explanatory variables

| Dataset | Candidate response | Candidate explanatory variables |
|---|---|---|
| league_players (620 players, 24 teams) | `injured` | position, age, minutes_played, training_load, prev_injuries, bmi (team as a grouping factor) |
| ashford_matches (46 matches) | `goals_scored`, `goals_conceded` | home_away, opponent_rank |

`prev_injuries` could be a response, but it makes more sense as a predictor of `injured`. `training_load` takes only the values 1 to 5, so it could be treated as numeric or as an ordered factor. This is worth deciding before the full models.

## 2. Type of response

| Response | Type | Why |
|---|---|---|
| injured | binary | 0/1 outcome per player |
| goals_scored, goals_conceded | count | non-negative integers, no fixed upper limit |
| prev_injuries | count | non-negative integers (0 to 4) |
| minutes_played, bmi | continuous | measured on a continuous scale |

## 3. Families and link functions

- **Binary (injured):** binomial family with a logit link. The logit gives odds ratios that are easy to interpret. Probit and cloglog are alternatives.
- **Counts (goals):** Poisson family with a log link. The log link keeps the mean positive and makes effects multiplicative. If the data are overdispersed, use quasi-Poisson or negative binomial.
- **Continuous (bmi, minutes_played):** Gaussian family with an identity link. `minutes_played` is bounded, so Gamma with a log link is a possible alternative.

## 4. Exploration

**Injury proportions**
- Overall, 115 of 620 players were injured (18.5%).
- By position: goalkeepers 27% (17/62), midfielders 19%, forwards 18%, defenders 16%. The goalkeeper group is small, so that gap is not firm.
- By previous injuries (0, 1, 2, 3, 4): 11%, 19%, 28%, 38%, 43%. This is the strongest pattern in the data, and `prev_injuries` is clearly worth including in the binomial model.
- Ashford United had 4 of 25 players injured (16%), close to the league average. The script runs a Fisher exact test of Ashford against the rest of the league.
- Team proportions range from 8% to 44%. With about 25 players per team, random variation alone would give a standard deviation of roughly 0.08, and the observed spread is also about 0.08. So there is little sign of real differences between teams, though this is a rough check.

**Count means and variances**

| Variable | Mean | Variance | Variance / mean |
|---|---|---|---|
| goals_scored | 1.30 | 1.99 | 1.53 |
| goals_conceded | 0.83 | 0.64 | 0.77 |
| prev_injuries | 0.90 | 1.18 | 1.30 |

A Poisson model assumes the variance equals the mean. Goals scored is somewhat overdispersed, with most of that coming from home matches (mean 1.74, variance 2.93). Away matches are close to Poisson (mean 0.87, variance 0.75). Goals conceded is slightly underdispersed. These ratios are raw, before any covariates are included, and with 23 matches per group they are noisy. The key check is the residual dispersion once the Poisson model is fitted.

## 5. Gaussian glm() vs lm()

I didn't have the Week 2 model, so I assumed `goals_scored ~ home_away + opponent_rank`. Change `frm` in the script if yours differed.

| | Estimate | Std. error |
|---|---|---|
| Intercept | 0.008 | 0.432 |
| Home (vs Away) | 0.870 | 0.378 |
| opponent_rank | 0.068 | 0.027 |

Residual variance is 1.64 (sigma 1.28) on 43 degrees of freedom, and the residual sum of squares is 70.5.

**What to expect from the comparison**
- Estimates, standard errors and t values are identical in `lm()` and `glm(family = gaussian)`. With an identity link and Gaussian errors, maximum likelihood and least squares give the same fit.
- The glm's reported dispersion equals the lm's sigma squared, and the glm's deviance equals the lm's residual sum of squares.
- The log-likelihood and AIC are the same too, since both use the Gaussian likelihood.
- In other words, `lm()` is a special case of `glm()`. The glm framework only adds something once the family or link changes.

**Reading the results**
- Home matches average about 0.87 more goals than away matches, holding opponent rank fixed.
- `opponent_rank` has a positive coefficient. If rank 1 is the strongest side, Ashford score more against lower-ranked opponents (about 0.07 more goals per rank place). Check that this matches how the rank was coded.

**Why this motivates Poisson:** a Gaussian model can predict negative goals and ignores that goals are discrete and that their variance grows with the mean. That is the reason for moving to a Poisson GLM with a log link next.

## Files in `outputs/Week 3/`

- `week3_glm.R`: the full analysis script
- `variable_plan.csv`: responses, types, families, links
- `injury_proportions.csv`: overall, by position, by previous injuries, by team
- `count_mean_variance_overall.csv`, `count_mean_variance_by_venue.csv`
- `lm_vs_gaussian_glm_coefficients.csv`, `lm_vs_gaussian_glm_fit.csv`
- `model_summaries.txt`, `sessionInfo.txt`
- `injury_by_position.png`, `goals_scored_vs_poisson.png`
