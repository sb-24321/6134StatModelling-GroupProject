# MTH6134 Statistical Modelling II

# Question 1: Factors Associated with Goals Scored by Ashford United

## 1. Research Objective

This analysis investigates whether the number of goals scored by Ashford United is associated with match venue (home or away) and the final league rank of the opponent.

The response variable is the number of goals scored by Ashford United in each match. The explanatory variables are venue and opponent rank. All 46 matches are included in the primary analysis.

The aim is to quantify the associations between these explanatory variables and Ashford's expected number of goals, while assessing whether the selected model provides an adequate description of the observed data.

## 2. Choice of Statistical Model

The response variable, goals scored, is a count that takes non-negative integer values. A Poisson generalised linear model (GLM) is therefore an appropriate starting point. The Poisson model represents the expected count as a function of explanatory variables and, with a log link, ensures that fitted expected counts are positive.

The Poisson regression model used is:

$$
Y_i \sim \operatorname{Poisson}(\mu_i)
$$

$$
\log(\mu_i) = \beta_0 + \beta_1(\text{opponent rank}_i) + \beta_2(\text{home}_i)
$$

where $Y_i$ is the number of goals scored by Ashford in match $i$, and $\mu_i$ is the expected number of goals in that match.

Away matches are the reference category for venue. Consequently, the venue coefficient compares home matches with away matches while holding opponent rank constant.

The Poisson model assumes that the conditional mean and variance are equal. This assumption, alongside the adequacy of the fitted model more generally, is considered through goodness-of-fit and dispersion checks.

## 3. Exploratory Findings Relevant to the Model

The analysis included 46 matches, comprising 23 home matches and 23 away matches. There were no missing values in the variables used in the model. The goals-scored variable contained non-negative whole-number observations, as required for a count response.

Across all 46 matches:

- Mean goals scored: 1.304.
- Variance of goals scored: 1.994.
- 0 goals: 14 matches.
- 1 goal: 15 matches.
- 2 goals: 11 matches.
- 3 goals: 5 matches.
- 8 goals: 1 match.

The sample variance is greater than the sample mean. This provides a reason to check for possible overdispersion after fitting the Poisson model, although it is not sufficient by itself to establish that the Poisson model is unsuitable.

The mean number of goals scored was 1.739 at home and 0.870 away. This descriptive difference suggests that venue may be relevant, although the comparison does not adjust for differences in opponent rank. The regression analysis considers venue and opponent rank together.

The match with eight goals is unusual relative to the other observed scores and is investigated further in the influence and sensitivity analyses.

## 4. Candidate Models and Model Selection

Four Poisson regression models were fitted to the 46 matches:

| Model | Formula | Purpose |
|------------------------|------------------------|------------------------|
| M0 | `goals_scored ~ 1` | Intercept-only baseline |
| M1 | `goals_scored ~ opponent_rank` | Adds opponent rank |
| M2 | `goals_scored ~ opponent_rank + home_away` | Adds venue as an additive effect |
| M3 | `goals_scored ~ opponent_rank * home_away` | Allows the opponent-rank association to differ by venue |

The models were compared using the Akaike Information Criterion (AIC), with lower AIC indicating a preferable balance between model fit and complexity. Likelihood ratio tests (LRTs) were also used for comparisons between nested models.

### 4.1 AIC Comparison

| Model                       |         AIC |
|-----------------------------|------------:|
| M0: Intercept only          |     144.492 |
| M1: Opponent rank           |     138.229 |
| M2: Opponent rank and venue | **133.433** |
| M3: Interaction             |     135.072 |

M2 had the lowest AIC. Adding opponent rank to the intercept-only model reduced AIC, and adding venue reduced it further. Adding an interaction between opponent rank and venue increased AIC relative to M2, so the more complex interaction model was not preferred by this criterion.

### 4.2 Likelihood Ratio Tests

| Comparison | Deviance reduction | p-value | Conclusion |
|-----------------|------------------:|------------------:|-----------------|
| M0 vs M1 | 8.263 | 0.0040 | Opponent rank improves the model compared with the intercept-only model. |
| M1 vs M2 | 6.796 | 0.0091 | Adding venue improves the model after accounting for opponent rank. |
| M2 vs M3 | 0.361 | 0.5479 | There is no evidence that the interaction improves the additive model. |

The LRTs support adding opponent rank and then venue. The interaction term is not supported: the test comparing M2 and M3 gives $p=0.548$.

Together with the AIC comparison, this supports retaining the simpler additive model, M2.

The selected primary model is therefore:

``` r
goals_scored ~ opponent_rank + home_away
```

fitted using a Poisson distribution with a log link.

## 5. Results from the Selected Model

The estimated coefficients and exponentiated coefficients (rate ratios) are shown below. The confidence intervals are 95% Wald confidence intervals.

| Term | Estimate | Standard error | p-value | Rate ratio | 95% CI for rate ratio |
|------------|-----------:|-----------:|-----------:|-----------:|-----------:|
| Intercept | -0.8988 | 0.3705 | 0.0153 | 0.407 | Not interpreted |
| Opponent rank | 0.05435 | 0.01939 | 0.0051 | 1.0559 | 1.0165 to 1.0968 |
| Home (reference: away) | 0.69315 | 0.27386 | 0.0114 | 2.000 | 1.1693 to 3.4209 |

### 5.1 Opponent Rank

The estimated opponent-rank coefficient is positive (0.05435). Exponentiating this coefficient gives a rate ratio of 1.0559, with a 95% confidence interval from 1.0165 to 1.0968.

Holding venue constant, a one-place increase in the opponent's numerical league rank is associated with an estimated 5.6% increase in Ashford's expected number of goals.

In this league, rank 1 represents the strongest team and rank 24 the weakest team. Therefore, a one-place increase in numerical rank represents facing a lower-ranked opponent. The result indicates that Ashford tended to score more goals against weaker opponents, after accounting for venue.

The confidence interval is entirely above 1, and the coefficient test gives $p=0.0051$, providing evidence of a positive association in this dataset.

### 5.2 Venue

The estimated home-venue coefficient is 0.69315. Its exponentiated value is 2.000, with a 95% confidence interval from 1.1693 to 3.4209.

Holding opponent rank constant, the model estimates that Ashford's expected number of goals at home was twice its expected number of goals away. The confidence interval is above 1, and the coefficient test gives $p=0.0114$, providing evidence of an association between playing at home and a higher expected goal count in these matches.

These are associations estimated from the observed matches. They should not be described as proof that playing at home or facing a particular opponent rank causes a change in goals scored.

### 5.3 Intercept

The intercept represents the log expected goal count for an away match against an opponent with rank zero. Rank zero is outside the observed opponent-rank range, so the intercept has little direct practical interpretation and is not a focus of the substantive conclusions.

## 6. Goodness of Fit and Dispersion

For the selected model fitted to all 46 matches:

| Measure                                      | Result |
|----------------------------------------------|-------:|
| Residual deviance                            | 49.785 |
| Residual degrees of freedom                  |     43 |
| Residual deviance / degrees of freedom       |  1.158 |
| Approximate deviance goodness-of-fit p-value |  0.221 |
| Pearson dispersion estimate                  |  0.990 |

The deviance-based goodness-of-fit test gives $p=0.221$. At the 5% level, this does not provide evidence of lack of fit.

The deviance-to-degrees-of-freedom ratio is approximately 1.16, while the Pearson dispersion estimate is approximately 0.99. These values do not indicate substantial overdispersion.

A supplementary quasi-Poisson model was also fitted using the same explanatory variables. Its estimated standard errors were very similar to those from the Poisson model:

| Term          | Poisson SE | Quasi-Poisson SE |
|---------------|-----------:|-----------------:|
| Intercept     |    0.37052 |          0.36874 |
| Opponent rank |    0.01939 |          0.01930 |
| Home          |    0.27386 |          0.27254 |

This comparison provides no indication that allowing a separate dispersion parameter materially changes the standard errors. The Poisson model is therefore retained as the primary model.

The goodness-of-fit p-value should be interpreted as a diagnostic check, not as proof that the model is correct. The residual plots and influence analysis are considered alongside it.

## 7. Model Diagnostics

The four-panel diagnostic plot was examined using deviance residuals, Pearson residuals, Cook's distance and residuals against leverage.

### 7.1 Residuals Against Fitted Values

The residual plots show the spread of residuals across the fitted expected goal counts. The points form bands and clusters, which is consistent with the response being a discrete count.

There is no simple, smooth pattern that by itself establishes a major systematic failure. However, the large positive residual associated with the eight-goal match is conspicuous.

### 7.2 Pearson Residuals

The Pearson residual plot also identifies the eight-goal match as having a much larger positive residual than most other observations. This indicates that the model underpredicts the observed goal count for that match.

### 7.3 Cook's Distance and Leverage

Cook's distance measures how much the fitted model is affected by an individual observation. Match 8 has a Cook's distance of approximately 0.639, substantially larger than the values for the other observations.

Its leverage is approximately 0.162 and its standardised residual is approximately 3.153.

The residuals-versus-leverage plot similarly identifies Match 8 as an observation with both relatively high leverage and a large residual. Other observations have much smaller Cook's distances.

Match 8 is therefore the main influential observation requiring investigation.

Diagnostic thresholds are guidelines rather than absolute rules. The conclusion that Match 8 is influential is supported by its exceptionally large Cook's distance relative to the other matches and by the sensitivity analysis below.

## 8. Sensitivity Analysis: Match 8

Match 8 recorded eight goals, against the weakest-ranked opponent (rank 24), in a home match. The primary model predicts approximately 3.00 goals for this match, so the observed count is substantially higher than the fitted value.

The primary analysis retains Match 8 because it is a genuine observation in the supplied dataset. To assess its influence, the selected model was refitted after excluding this match. This is a sensitivity analysis, not a replacement primary analysis.

### 8.1 Changes in Estimated Effects

| Term | All 46 matches: rate ratio (95% CI) | Excluding Match 8: rate ratio (95% CI) |
|------------------------|------------------------|------------------------|
| Opponent rank | 1.0559 (1.0165, 1.0968) | 1.0341 (0.9930, 1.0769) |
| Home vs away | 2.0000 (1.1693, 3.4209) | 1.7055 (0.9749, 2.9837) |

After excluding Match 8, both estimated rate ratios remain above 1, so the directions of the associations are unchanged. However, both estimates move closer to 1 and their 95% confidence intervals now include 1. The evidence for the associations is therefore less conclusive when Match 8 is omitted.

This indicates that Match 8 has a material influence on the estimated strength and statistical evidence of the opponent-rank and venue associations. It does not establish that the observation is erroneous, and there is no basis in the available information for deleting it from the primary analysis.

### 8.2 Model Selection Without Match 8

The four candidate models were also compared using the same 45 matches after excluding Match 8. M2 remained the model with the lowest AIC:

| Model                       | AIC without Match 8 |
|-----------------------------|--------------------:|
| M0: Intercept only          |             124.130 |
| M1: Opponent rank           |             123.702 |
| M2: Opponent rank and venue |         **122.097** |
| M3: Interaction             |             124.062 |

The corresponding LRT p-values were:

- M0 versus M1: 0.1192.
- M1 versus M2: 0.0576.
- M2 versus M3: 0.8522.

Thus, M2 still had the lowest AIC, although the evidence for adding opponent rank and venue was weaker in this reduced dataset. There remained no evidence supporting the interaction.

The reduced model's residual deviance was 42.387 on 42 degrees of freedom, with an approximate goodness-of-fit p-value of 0.454.

The model comparisons with and without Match 8 are each conducted within their respective datasets. AIC values from models fitted to different numbers of observations should not be compared directly.

## 9. Assessment of a Possible Quadratic Relationship

The primary model assumes that opponent rank has a linear association with the log of the expected goal count. A further model was fitted to investigate whether a quadratic term was warranted. Opponent rank was centred before fitting the quadratic model.

The linear and quadratic models were:

``` r
goals_scored ~ opponent_rank_c + home_away

goals_scored ~ opponent_rank_c +
  I(opponent_rank_c^2) + home_away
```

The quadratic model had a lower AIC:

| Model                        |     AIC |
|------------------------------|--------:|
| Linear opponent-rank term    | 133.433 |
| Quadratic opponent-rank term | 131.984 |

However, the LRT comparing these models gave a deviance reduction of 3.449 and a p-value of 0.0633. The quadratic coefficient had an estimated value of 0.00553 and a p-value of 0.0595.

The quadratic model therefore provides a modest improvement in AIC, and the test suggests some possible curvature, but the additional quadratic term does not meet the 5% significance threshold.

The evidence is not strong enough to justify replacing the simpler linear specification as the primary model. This check should be described as a qualification: it does not prove that the relationship is exactly linear.

## 10. Overall Conclusion

The selected Poisson regression model indicates that both opponent rank and venue are associated with the number of goals scored by Ashford United.

Holding venue constant, a one-place increase in the opponent's numerical rank is associated with an estimated 5.6% increase in expected goals. Since rank 1 represents the strongest team and rank 24 the weakest, this indicates that Ashford tended to score more goals against weaker opponents.

Holding opponent rank constant, the expected number of goals at home is estimated to be twice that away.

The selected additive model had the lowest AIC among the four initial candidate models, and the likelihood ratio tests supported including opponent rank and venue but not their interaction. The goodness-of-fit and dispersion checks did not indicate substantial overdispersion or clear lack of fit.

However, Match 8 is highly influential. Excluding it weakens the evidence for both explanatory variables, although the estimated associations remain in the same direction. The primary analysis therefore retains all 46 matches and reports the sensitivity analysis transparently.

The quadratic check also suggests possible, but not conclusive, curvature in the opponent-rank relationship.

The findings should be interpreted as associations in this simulated season, rather than causal effects. They are also based on a relatively small set of 46 matches, and the influence of one unusual match means that the estimated effects warrant some caution.
