
# Week 6 – Poisson Regression Analysis

## 1. Objectives

The aim of this week's analysis was to apply Poisson regression to count variables in the football datasets and investigate how different explanatory variables influence the expected counts.

The analysis focused on three response variables:

1. `prev_injuries` – Number of previous injuries experienced by a player.
2. `goals_conceded` – Number of goals conceded by Ashford in a match.
3. `goals_scored` – Number of goals scored by Ashford in a match.

The main objectives were to:

- Fit Poisson generalised linear models (GLMs) using a log link.
- Investigate the relationships between the response variables and relevant predictors.
- Compare alternative models using AIC and analysis of deviance.
- Interpret regression coefficients and their statistical significance.
- Assess model fit using residual and influence diagnostics.
- Check for overdispersion and compare results with quasi-Poisson models.

## 2. Datasets and Methodology

Two datasets were used:

| Dataset | Observations | Response Variables |
|---|---:|---|
| `league_players.csv` | 620 players | `prev_injuries` |
| `ashford_matches.csv` | 46 matches | `goals_conceded`, `goals_scored` |

Poisson regression was used because the response variables represent non-negative integer counts.

All models were fitted in R using `glm()` with `family = poisson(link = "log")`.

The log link models the logarithm of the expected count as a linear combination of explanatory variables.

Exponentiating a regression coefficient gives a multiplicative change in the expected count, holding the other predictors constant.

For each response variable, increasingly complex models were fitted and compared using:

- Akaike Information Criterion (AIC), where lower values indicate a preferred balance between model fit and complexity.
- Analysis of deviance, to assess whether adding predictors significantly improves model fit.
- Pearson dispersion statistics, to assess whether the variance is consistent with the Poisson assumption.
- Residual plots, Cook's distances and leverage diagnostics, to identify potential model-fitting problems.

Quasi-Poisson models were also fitted to account for departures from the Poisson variance assumption.

---

## 3. Previous Injuries – `prev_injuries`

### 3.1 Models Fitted

The following models were fitted using the players dataset:

| Model | Formula |
|---|---|
| Model 0 | `prev_injuries ~ 1` |
| Model 1 | `prev_injuries ~ age` |
| Model 2 | `prev_injuries ~ age + position` |
| Model 3 | `prev_injuries ~ age + position + training_load` |

The most complex model included age, playing position and training load as explanatory variables.

### 3.2 Model Comparison

| Model | AIC | Residual Deviance |
|---|---:|---:|
| Model 0 | 1639.54 | 864.59 |
| Model 1 | 1641.43 | 864.48 |
| Model 2 | 1645.66 | 862.71 |
| Model 3 | 1646.68 | 855.73 |

The intercept-only model (Model 0) achieved the lowest AIC.

Although residual deviance decreased as additional predictors were introduced, the improvements were not sufficient to justify the increased model complexity according to AIC.

The sequential analysis of deviance showed:

- Adding age did not significantly improve fit (p = 0.7358).
- Adding position did not significantly improve fit (p = 0.6217).
- Adding training load did not significantly improve fit (p = 0.1369).

Therefore, there was insufficient evidence that these predictors improved the model overall.

### 3.3 Coefficient Interpretation

In the full Poisson model:

- Age was not statistically significant (p = 0.8064).
- Playing position was not statistically significant.
- Training load levels 3, 4 and 5 were individually significant at the 5% level in the initial Poisson model, relative to training load level 1.
- Training load level 2 was not significant at the 5% level (p = 0.0691).

The positive coefficients for higher training load levels suggested higher expected previous injury counts compared with the reference level.

However, these individual coefficient results should be interpreted cautiously because the overall addition of training load did not significantly improve model fit.

### 3.4 Dispersion and Quasi-Poisson Results

The Pearson dispersion statistic was:

**1.304**

Since this exceeds 1, it suggests some overdispersion relative to the Poisson assumption.

A quasi-Poisson model was fitted to account for this.

The quasi-Poisson model produced larger standard errors and higher p-values.

In particular:

- Training load level 3: p = 0.0594.
- Training load level 4: p = 0.0555.
- Training load level 5: p = 0.0652.

None of these predictors remained statistically significant at the 5% level after adjusting for dispersion.

This indicates that the apparent significance of training load in the original Poisson model was sensitive to the assumed variance.

### 3.5 Model Diagnostics

Residual and influence diagnostic plots were examined.

The residual plots showed:

- Residuals distributed on both sides of zero.
- No obvious systematic curved pattern.
- Some observations with relatively large residuals.

The Cook's distance and leverage plots suggested that one observation may have a particularly strong influence on the fitted model.

This observation should be investigated further to determine whether the model estimates are sensitive to it.

### 3.6 Conclusion

The intercept-only model was preferred according to AIC.

Age, position and training load did not provide statistically significant overall improvements in model fit.

The Pearson dispersion statistic suggested some overdispersion, and the quasi-Poisson analysis showed that the apparent significance of higher training load levels was not robust to adjusting the standard errors.

Further investigation of the potentially influential observation would be useful.

---

## 4. Goals Conceded – `goals_conceded`

### 4.1 Models Fitted

Four models were fitted using the matches dataset:

| Model | Formula |
|---|---|
| Model 0 | `goals_conceded ~ 1` |
| Model 1 | `goals_conceded ~ opponent_rank` |
| Model 2 | `goals_conceded ~ opponent_rank + home_away` |
| Model 3 | `goals_conceded ~ opponent_rank * home_away` |

The interaction model investigated whether the relationship between opponent ranking and goals conceded differed between home and away matches.

### 4.2 Model Comparison

| Model | AIC | Residual Deviance |
|---|---:|---:|
| Model 0 | 106.62 | 41.57 |
| Model 1 | 103.70 | 36.65 |
| Model 2 | 101.85 | 32.80 |
| Model 3 | 103.72 | 32.66 |

Model 2 achieved the lowest AIC and was selected as the preferred model.

The sequential analysis of deviance showed:

- Adding opponent ranking significantly improved fit (p = 0.0266).
- Adding home/away status significantly improved fit (p = 0.0496).
- Adding the interaction term did not significantly improve fit (p = 0.7155).

Therefore, the additive model was preferred over the more complex interaction model.

### 4.3 Coefficient Interpretation

The selected model produced the following results:

| Predictor | Estimate | p-value |
|---|---:|---:|
| Intercept | 0.67312 | 0.0316 |
| Opponent rank | -0.05183 | 0.0293 |
| Home (relative to Away) | -0.65393 | 0.0558 |

**Opponent ranking**

The coefficient for opponent ranking was negative.

Exponentiating the coefficient gives approximately 0.949.

Therefore, each one-place increase in opponent ranking was associated with approximately a **5.1% decrease in expected goals conceded**, holding match location constant.

**Home advantage**

The home coefficient was -0.65393.

Exponentiating this coefficient gives approximately 0.520.

This suggests that Ashford was expected to concede approximately **48% fewer goals at home than away**, controlling for opponent ranking.

However, the individual Wald test for the home coefficient gave p = 0.0558, slightly above the 5% significance level.

The sequential analysis of deviance gave p = 0.0496 for adding home/away status, so the evidence for a home effect was borderline and depended on the test used.

### 4.4 Dispersion and Quasi-Poisson Results

The Pearson dispersion statistic was:

**0.575**

This is below 1, suggesting underdispersion rather than overdispersion.

The quasi-Poisson model estimated a dispersion parameter of approximately 0.575.

Under this variance adjustment, both predictors were statistically significant:

- Opponent ranking: p = 0.0063.
- Home advantage: p = 0.0155.

The quasi-Poisson adjustment reduced the standard errors because the estimated dispersion was below 1.

These results support associations between goals conceded, opponent ranking and match location, although the evidence for home advantage under the original Poisson model was borderline.

### 4.5 Model Diagnostics

The diagnostic plots showed:

- Residuals generally distributed around zero.
- Discrete residual patterns consistent with count outcomes.
- No obvious systematic curved trend.
- Relatively moderate residual magnitudes.

Cook's distance plots suggested several observations with somewhat greater influence than others, but no single observation appeared to dominate the model.

Leverage diagnostics showed a small number of relatively high-leverage observations without exceptionally large corresponding residuals.

Overall, the plots did not suggest major model-fitting problems.

### 4.6 Conclusion

Model 2, containing opponent ranking and home/away status, was preferred according to AIC.

Higher numerical opponent rankings were associated with fewer goals conceded.

The results also suggested that Ashford conceded fewer goals at home, although the strength of statistical evidence depended on the test used.

The dispersion statistic indicated underdispersion, and no major diagnostic problems were apparent.

---

## 5. Goals Scored – `goals_scored`

### 5.1 Models Fitted

Four models were fitted:

| Model | Formula |
|---|---|
| Model 0 | `goals_scored ~ 1` |
| Model 1 | `goals_scored ~ opponent_rank` |
| Model 2 | `goals_scored ~ opponent_rank + home_away` |
| Model 3 | `goals_scored ~ opponent_rank * home_away` |

The interaction model tested whether the relationship between opponent ranking and goals scored differed between home and away matches.

### 5.2 Model Comparison

| Model | AIC | Residual Deviance |
|---|---:|---:|
| Model 0 | 144.49 | 64.84 |
| Model 1 | 138.23 | 56.58 |
| Model 2 | 133.43 | 49.79 |
| Model 3 | 135.07 | 49.42 |

Model 2 achieved the lowest AIC and was selected as the preferred model.

The sequential analysis of deviance showed:

- Adding opponent ranking significantly improved fit (p = 0.0040).
- Adding home/away status significantly improved fit (p = 0.0091).
- Adding the interaction term did not significantly improve fit (p = 0.5479).

Therefore, the additive model was preferred over the interaction model.

### 5.3 Coefficient Interpretation

The selected model produced the following results:

| Predictor | Estimate | p-value |
|---|---:|---:|
| Intercept | -0.89880 | 0.0153 |
| Opponent rank | 0.05435 | 0.0051 |
| Home (relative to Away) | 0.69315 | 0.0114 |

**Opponent ranking**

The coefficient for opponent ranking was positive.

Exponentiating the coefficient gives approximately 1.056.

Therefore, each one-place increase in opponent ranking was associated with approximately a **5.6% increase in expected goals scored**, holding match location constant.

This suggests Ashford tended to score more goals against opponents with higher numerical rankings.

**Home advantage**

The home coefficient was 0.69315.

Exponentiating this coefficient gives approximately 2.00.

Therefore, Ashford was expected to score approximately **twice as many goals at home as away**, controlling for opponent ranking.

Both predictors were statistically significant at the 5% level.

### 5.4 Dispersion and Quasi-Poisson Results

The Pearson dispersion statistic was:

**0.990**

This is very close to 1, suggesting that the observed dispersion was consistent with the Poisson variance assumption.

The quasi-Poisson model produced very similar coefficient estimates, standard errors and significance results.

Both predictors remained statistically significant:

- Opponent ranking: p = 0.0073.
- Home advantage: p = 0.0147.

This suggests that the findings were relatively robust to the dispersion adjustment.

### 5.5 Model Diagnostics

The diagnostic plots showed:

- Residuals forming distinct bands, consistent with the discrete nature of count data.
- Several relatively large positive residuals.
- No obvious systematic curved pattern.
- Some observations with larger Cook's distances than others.

The larger positive residuals suggest that the model underpredicted goals scored in certain matches.

The leverage diagnostics indicated some higher-leverage observations, although no single observation appeared to combine exceptionally high leverage with the most extreme residual.

These observations could be investigated further, but the diagnostic plots did not provide clear evidence of a major systematic model-fitting problem.

### 5.6 Conclusion

Model 2, containing opponent ranking and home/away status, was preferred according to AIC.

Both predictors were statistically significant.

Ashford tended to score more goals against weaker opponents and was expected to score approximately twice as many goals at home as away.

The dispersion statistic was close to 1, providing support for the Poisson variance assumption.

---

## 6. Overall Findings

The three analyses produced different conclusions.

| Response Variable | Preferred Model | Pearson Dispersion | Main Finding |
|---|---|---:|---|
| `prev_injuries` | Intercept-only | 1.304 (full model) | Additional predictors did not significantly improve overall fit |
| `goals_conceded` | Opponent rank + home/away | 0.575 | Opponent rank and match location were associated with goals conceded |
| `goals_scored` | Opponent rank + home/away | 0.990 | Opponent rank and home advantage were significant predictors |

### Key Findings

- Poisson regression was applied to three different count responses.
- The intercept-only model was preferred for previous injuries according to AIC.
- Opponent ranking was an important predictor of both goals scored and goals conceded.
- Ashford was expected to score more goals and concede fewer goals at home.
- Interaction terms did not significantly improve the football match models.
- The previous injuries model showed some overdispersion.
- The goals conceded model showed underdispersion.
- The goals scored model had a dispersion statistic close to 1.
- Residual and influence diagnostics identified observations that may warrant further investigation.

Overall, the analysis demonstrated how Poisson GLMs can be used to investigate count outcomes, compare alternative model specifications and assess whether the assumptions of a fitted model are reasonable.

The findings also highlighted the importance of checking dispersion and model diagnostics rather than relying solely on individual coefficient p-values.

---

