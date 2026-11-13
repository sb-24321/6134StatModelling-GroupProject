# MTH6134 – Statistical Modelling II

## Weeks 8–9: Contingency Tables

## 1. Overview

Weeks 8 and 9 investigate relationships between categorical variables using contingency tables and Poisson log-linear models.

The analyses use two datasets:

- `ashford_matches.csv`: contains 46 match observations for Ashford United.
- `league_players.csv`: contains 620 player observations from the league.

The main objectives are to investigate whether match outcomes are associated with home/away status and whether player injury status is associated with previous injuries and training load.

The methods used include:

- Two-way and three-way contingency tables.
- Row and column proportions and marginal totals.
- Chi-squared tests of independence.
- Poisson log-linear models.
- Likelihood-ratio tests and model comparisons.
- Model simplification using `drop1()`.
- Goodness-of-fit assessment.
- Interpretation of exponentiated interaction coefficients.

------------------------------------------------------------------------

## 2. Data preparation

Both datasets were loaded and examined using `str()`.

Missing values were checked for the variables required in each analysis. No missing values were identified in these variables.

| Dataset         | Initial observations | Observations remaining |
|-----------------|---------------------:|-----------------------:|
| Ashford matches |                   46 |                     46 |
| League players  |                  620 |                    620 |

No observations needed to be removed.

------------------------------------------------------------------------

## 3. Week 8 – Two-way contingency tables

### 3.1 Research question

Is there an association between whether Ashford United plays at home or away and its match result?

### 3.2 Variables

- **Home/away status:** Home or Away.
- **Match result:** Win, Draw or Loss.

Match results were created by comparing goals scored with goals conceded.

### 3.3 Contingency table

The observed frequencies were:

| Venue     |   Loss |   Draw |    Win |  Total |
|-----------|-------:|-------:|-------:|-------:|
| Away      |     10 |      6 |      7 |     23 |
| Home      |      3 |      5 |     15 |     23 |
| **Total** | **13** | **11** | **22** | **46** |

The row proportions show the distribution of results within each venue:

| Venue | Loss | Draw | Win |
|-------|-----:|-----:|----:|
| Away  |  43% |  26% | 30% |
| Home  |  13% |  22% | 65% |

The results suggest that Ashford United won a considerably larger proportion of its home matches than away matches.

### 3.4 Chi-squared test of independence

The hypotheses were:

- **Null hypothesis (H₀):** Home/away status and match result are independent.
- **Alternative hypothesis (H₁):** There is an association between home/away status and match result.

The Pearson chi-squared test produced:

- Chi-squared statistic: 6.7692
- Degrees of freedom: 2
- P-value: 0.03389

At the 5% significance level, the null hypothesis is rejected. There is evidence of an association between home/away status and match result.

The smallest expected frequency was 5.5, so all expected frequencies were at least 5. The usual expected-frequency guideline for the chi-squared approximation was therefore satisfied.

The standardised residuals also showed that:

- Away losses occurred more frequently than expected under independence.
- Away wins occurred less frequently than expected.
- Home wins occurred more frequently than expected.
- Home losses occurred less frequently than expected.

### 3.5 Poisson log-linear models

Two models were fitted to the contingency table.

**Independence model**

The model included the main effects of home/away status and match result, assuming no association between them.

**Saturated model**

The model included the interaction between home/away status and match result, allowing for an association.

A likelihood-ratio chi-squared test compared the models:

- Deviance difference: 7.0444
- Degrees of freedom: 2
- P-value: 0.02953

The saturated model provided a significantly better fit than the independence model.

The independence model's goodness-of-fit assessment also produced a p-value of 0.02953, indicating that it did not adequately describe the observed contingency table at the 5% significance level.

### 3.6 Week 8 conclusion

The analysis provides evidence that home/away status is associated with Ashford United's match results. In particular, the proportion of home wins was considerably higher than the proportion of away wins.

The chi-squared test and log-linear model comparison reached consistent conclusions.

However, the analysis is based on only 46 matches and does not establish that playing at home causes better results.

------------------------------------------------------------------------

## 4. Week 9 – Three-way contingency tables

### 4.1 Research question

How are player injury status, previous injuries and training load associated with one another?

### 4.2 Variables

Three categorical variables were created:

- **Current injury status:** Injured (Yes/No).
- **Previous injuries:** Whether the player had experienced at least one previous injury (Yes/No).
- **Training load:** Low or High.

Training load was grouped using the following rule:

- Low: training load below 4.
- High: training load of 4 or above.

This grouping was a decision made for the analysis. The original training-load distribution was also examined before grouping.

### 4.3 Variable distributions

The 620 players were distributed as follows:

| Variable          | Category | Frequency |
|-------------------|----------|----------:|
| Current injury    | No       |       505 |
| Current injury    | Yes      |       115 |
| Previous injuries | No       |       295 |
| Previous injuries | Yes      |       325 |
| Training load     | Low      |       392 |
| Training load     | High     |       228 |

### 4.4 Three-way contingency table

The observed frequencies were:

| Injury status | Previous injuries | Low load | High load |
|---------------|-------------------|---------:|----------:|
| No            | No                |      173 |        90 |
| Yes           | No                |       17 |        15 |
| No            | Yes               |      163 |        79 |
| Yes           | Yes               |       39 |        44 |

The table suggests that current injuries are more common among players with previous injuries, particularly in the high training-load category.

For example, the proportion currently injured within each previous-injury and training-load combination was:

| Previous injuries | Training load | Injury frequency | Injury proportion |
|-------------------|---------------|-----------------:|------------------:|
| No                | Low           |           17/190 |              8.9% |
| Yes               | Low           |           39/202 |             19.3% |
| No                | High          |           15/105 |             14.3% |
| Yes               | High          |           44/123 |             35.8% |

These descriptive results suggest that both previous injury history and training load may be relevant to current injury status.

### 4.5 Saturated Poisson log-linear model

A saturated log-linear model was initially fitted.

It included:

- All three main effects.
- All three two-way interactions.
- The three-way interaction.

The `drop1()` procedure was used to assess whether the three-way interaction could be removed.

The test produced:

- Likelihood-ratio statistic: 0.47926
- Degrees of freedom: 1
- P-value: 0.4888

As the p-value was greater than 0.05, there was insufficient evidence that the three-way interaction improved model fit. It was therefore removed.

### 4.6 Examination of two-way interactions

The reduced model retained all three two-way interactions initially.

The `drop1()` results were:

| Interaction                       | Likelihood-ratio statistic |      P-value |
|-----------------------------------|---------------------------:|-------------:|
| Injury × Previous injuries        |                    22.5172 | 2.083 × 10⁻⁶ |
| Injury × Training load            |                    12.1279 |    0.0004967 |
| Previous injuries × Training load |                     0.0096 |       0.9221 |

The previous-injuries by training-load interaction was not statistically significant at the 5% level and was removed.

The remaining two interactions were retained because their removal would significantly worsen model fit.

The final model was:

`freq ~ inj + prev + load + inj:prev + inj:load`

### 4.7 Final model and goodness of fit

The final model produced:

- Residual deviance: 0.48883
- Residual degrees of freedom: 2
- Goodness-of-fit p-value: 0.78316
- AIC: 59.332

The goodness-of-fit p-value was greater than 0.05, so there was no evidence of a lack of fit based on the residual deviance assessment.

The final model therefore provided an adequate fit to the observed three-way contingency table.

### 4.8 Exponentiated interaction coefficients

The final model contained two interaction terms.

| Interaction                | Exponentiated coefficient |
|----------------------------|--------------------------:|
| Injury × Previous injuries |                     2.819 |
| Injury × Training load     |                     2.095 |

These exponentiated interaction coefficients describe multiplicative associations in the log-linear model. In this model, they represent conditional odds ratios for the relevant pairs of variables.

The injury-by-previous-injuries interaction indicates a positive association between previous injury history and current injury status.

The injury-by-training-load interaction also indicates that the association between training load and current injury status is not independent of injury status.

These are associations rather than evidence of causation. The interaction terms should be interpreted in the context of the model and its reference categories.

### 4.9 Week 9 conclusion

The three-way log-linear analysis did not provide sufficient evidence to retain the three-way interaction.

However, both the injury-by-previous-injuries and injury-by-training-load interactions were statistically significant and were retained in the final model.

The final model achieved an adequate goodness of fit, suggesting that these two interactions capture important associations in the observed contingency table.

------------------------------------------------------------------------

## 5. Overall conclusions

Weeks 8–9 introduced methods for analysing relationships between categorical variables.

The Week 8 analysis found evidence of an association between home/away status and Ashford United's match results. Home matches had a higher proportion of wins than away matches.

The Week 9 analysis found evidence of associations between current injury status, previous injuries and training load. The final log-linear model retained the injury-by-previous-injuries and injury-by-training-load interactions, while removing the non-significant three-way and previous-injuries-by-training-load interactions.

Together, these analyses demonstrate how contingency tables, chi-squared tests and Poisson log-linear models can be used to investigate relationships between categorical variables.

The findings may help inform the group's wider project, although further analysis and consideration of other explanatory variables may be necessary before drawing broader conclusions.

------------------------------------------------------------------------

## 6. Output organisation

The analysis results are organised into separate folders:

``` text
outputs/
├── week8/
│   ├── contingency_table.csv
│   ├── row_proportions.csv
│   ├── expected_frequencies.csv
│   └── standardised_residuals.csv
│
└── week9/
    ├── three_way_table.csv
    └── final_model_summary.txt
```

### Week 8 outputs

- `contingency_table.csv`: observed frequencies for home/away status and match result.
- `row_proportions.csv`: proportions of wins, draws and losses within each venue.
- `expected_frequencies.csv`: expected frequencies under independence.
- `standardised_residuals.csv`: standardised residuals from the chi-squared test.

### Week 9 outputs

- `three_way_table.csv`: observed frequencies for the three categorical variables.
- `final_model_summary.txt`: summary of the selected final Poisson log-linear model.

The complete R script is maintained separately in the project's code folder.
