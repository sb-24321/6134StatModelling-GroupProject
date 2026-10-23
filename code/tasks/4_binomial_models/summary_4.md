# Week 4 – Binomial Logistic Regression

## Objective

We investigated whether player characteristics were associated with the probability of injury using binomial logistic regression with a logit link.

Two separate analyses were conducted: one using all 620 players and another restricted to the 25 Ashford United players. Both analyses used age, minutes played (in thousands), training load, previous injuries and BMI as explanatory variables.

For each dataset, we fitted an intercept-only model and a full model containing all five predictors.

## All Players

Of the 620 players, 115 (18.5%) experienced an injury.

The full logistic regression model improved fit compared with the intercept-only model (likelihood ratio test: χ² = 56.168, df = 5, p = 7.506 × 10⁻¹¹). The AIC decreased from 596.71 to 550.55.

Age, training load and previous injuries were statistically significant predictors at the 5% level.

Holding other predictors constant, each additional year of age was associated with an 11.1% increase in the odds of injury. Each one-unit increase in training load was associated with a 35.4% increase, while each additional previous injury was associated with a 67.1% increase.

Minutes played and BMI were not statistically significant after adjusting for the other variables.

## Ashford United

Of the 25 Ashford United players, four (16%) experienced an injury.

The full model did not significantly improve fit compared with the intercept-only model (likelihood ratio test: χ² = 1.794, df = 5, p = 0.8768).

The AIC increased from 23.98 to 32.19, suggesting that the more complex model was not justified by the improvement in fit.

None of the five predictors was statistically significant. However, the small number of injury events and wide confidence intervals limit the reliability of the estimates.

## Model Diagnostics and Limitations

Residual plots showed the expected two-band structure for binary outcomes.

The all-players analysis contained some observations with relatively large residuals, while the Ashford United analysis showed several potentially influential observations.

The Ashford United model is particularly vulnerable to unstable estimates because only four injury events were available for estimating five predictor effects.

## Conclusion

The all-players analysis provided strong evidence that the explanatory variables collectively improve the modelling of injury probability. Age, training load and previous injuries showed positive associations with injury odds.

The Ashford United analysis did not provide sufficient evidence of an improvement over the intercept-only model, although its small sample size substantially limits the conclusions that can be drawn.
