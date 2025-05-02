# Multiple Linear Regression of Teenage Gambling in Britain
This project presents a complete multiple linear regression analysis of teen gambling behavior in Britain, using the `teengamb` dataset. The workflow includes exploratory data visualization, model building with interaction terms, exhaustive model selection, diagnostic checks, transformation using Box-Cox and log functions, and final model interpretation. 

## Dataset Information
### Description
The teengamb data frame has 47 rows and 5 columns. A survey was conducted to study teenage gambling in Britain.

### Format
This data frame contains the following columns:

### sex
0=male, 1=female

### status
Socioeconomic status score based on parents' occupation

### income
in pounds per week

### verbal
verbal score in words out of 12 correctly defined

### gamble
expenditure on gambling in pounds per year

### Source
Ide-Smith & Lea, 1988, Journal of Gambling Behavior, 4, 110-118

## Preliminary Analysis

### Preliminary Visual Analysis between income and gambling expenditure
<img width="441" alt="スクリーンショット 2025-05-01 午後4 24 15" src=https://github.com/user-attachments/assets/96244e23-80ac-4977-a6aa-f2f1d85fe4bd />

A Preliminary plot of Gambling Expenditure shows that there exists a slight positive correlation between income and gambling expenditure. In other words, people with higher incomes tend to spend more on gambling per year.

### Preliminary Visual Analysis between sex and gambling expenditure
<img width="441" alt="スクリーンショット 2025-05-01 午後4 24 15" src="https://github.com/user-attachments/assets/ea00f114-1f76-4016-94a7-2774a9547773" />

A Preliminary box-plot of sex and gambling expenditure shows that males tend to have both a higher tendency, higher variance and higher median of gambling expenditure compared to a female.

## Interaction Terms
To Validate the initial analysis, we add the following interaction terms in to the model:
- `status * income`: Effect of income on gambling depending on a person's status
- `sex * income`: Effect of income on gambling depending on a person's sex

Cognitive abilities are also known to affect a person's gambling expenditure. Thus we add this interaction term to measure whether the effect is the same between a person's sex.
- `sex * verbal`: Effect of verbal score on gambling depending on a person's sex

## Exhaustive Subset Selection
### Adjusted R²
<img width="678" alt="スクリーンショット 2025-05-01 午後4 29 25" src="https://github.com/user-attachments/assets/0d9d465f-3691-45db-b0cb-2ec3eff959b1" />

### Baysian Information Criterion
<img width="681" alt="スクリーンショット 2025-05-01 午後4 29 59" src="https://github.com/user-attachments/assets/12f24318-a879-47a2-8d74-74c5972ac41c" />

### Mallow's CP
<img width="672" alt="スクリーンショット 2025-05-01 午後4 30 13" src="https://github.com/user-attachments/assets/87fad4d6-35d4-4b07-8593-c8629ba9835e" />

The overall trends in BIC and Mallows’ Cp suggest a model with 3 predictors, whereas the Adjusted R² reaches its maximum with 6 predictors. However, the improvement in Adjusted R² from 3 to 6 variables is marginal. Therefore, following the principle of **Occam’s Razor**, we select the simpler 3-variable model for analysis

### Final Model Selection
<img width="919" alt="スクリーンショット 2025-05-01 午後5 02 18" src="https://github.com/user-attachments/assets/c67feb03-1329-4c0b-afdb-e3f14e925240" />

We proceed with the analysis with the predictor variates: 
- `income`
- `status * income`
- `sex * income`

## Diagnostic Check for Multiple Linear Regression

### Heteroscedasticity
<img width="660" alt="スクリーンショット 2025-05-01 午後5 14 01" src="https://github.com/user-attachments/assets/eae54c67-5cd9-4920-abe7-15ba67fa8dfa" />

There clearly exists a fanning out pattern in the residual plot thus it breaks the assumption of constant variance or Homoscedasticity.

### Normality of Residuals
<img width="673" alt="スクリーンショット 2025-05-01 午後5 28 15" src="https://github.com/user-attachments/assets/366bfe46-bffc-4129-898a-ef637bd2080c" />

Most of the plot is on the line which implies that most of the residuals are normally distributed but there exists a slight deviation in the upper right tail of the plot signalling a right skewness of the residuals.

## Box-Cox Transformation
It is clear that the current model breaks some MLR assumptions thus we apply a **Box-Cox Transformation** to find a suitable transformation to correct the model.
### Transformation

<img width="671" alt="スクリーンショット 2025-05-01 午後5 37 33" src="https://github.com/user-attachments/assets/ff360b4c-bc8f-4901-a597-8fc36433f76a" />

<img width="741" alt="スクリーンショット 2025-05-01 午後5 36 39" src="https://github.com/user-attachments/assets/02191efb-c09a-4470-bca3-5841b2c227c8" />

λ = 0.606 implies that we need to apply a log tranformation. We perform the transformation log(x + 1) since some entries are 0. 

### Post-Transformation Result Analysis
<img width="657" alt="スクリーンショット 2025-05-01 午後5 40 20" src="https://github.com/user-attachments/assets/c8eae513-67f7-4ec4-baaa-363ed0a369b3" />

It is clear that the fanning out pattern of the residuals plot has been severely mitigated post-transformation. There was a small cluster of residuals near the left side which has been spread out.

<img width="660" alt="スクリーンショット 2025-05-01 午後7 02 00" src="https://github.com/user-attachments/assets/3830b5f2-215a-4b2e-b3a5-4452bd20749a" />

The normality of Residuals did not change much after transformation. There still exists a slight deviation in both tails of the residuals. But the over all fit still lies near the line thus the residuals are generally normally distributed.

## Analysis of Variance (ANOVA)
We first establish that we will proceed with null hypothesis with α = 0.05

### ANOVA of status:income and sex:income
#### $H_0: \beta_{\text{income:status}} = \beta_{\text{income:sex}} = 0$

<img width="549" alt="スクリーンショット 2025-05-01 午後7 18 02" src="https://github.com/user-attachments/assets/6e9e947d-52fc-48c5-bf1d-6360a3a85b70" />

Since p=0.001361<α, we reject the null hypothesis. This indicates that at least one of the interaction terms, status:income or sex:income, is statistically significant in explaining variation in gambling expenditure.

### Null Hypothesis for each predictor variate
<img width="498" alt="スクリーンショット 2025-05-01 午後7 32 53" src="https://github.com/user-attachments/assets/6a93bdb3-094e-4519-822d-5d9c7d1e0d53" />

#### $H_0: \beta_{\text{income}} = 0$
Since p = 0.003134 < α, we reject the null hypothesis. This indicates that income is statistically significant in explaining the variation in annual gambling expenditures. 

#### $H_0: \beta_{\text{income:status}} = 0$
Since p = 0.671 > α, we fail to reject the null hypothesis. This suggests that the interaction between income and status does not provide a statistically significant improvement in explaining variation in gambling expenditure. In other words, the effect of income on gambling appears to be independent of status level, and including the income:status term does not meaningfully enhance the model.

#### $H_0: \beta_{\text{income:sex}} = 0$
Since p = 0.000799 < α, we reject the null hypoethesis. This indicates that the interaction between income and sex is statistically significant in explaining the variation in gambling expenditures.

### 10-fold Cross Validation
<img width="647" alt="スクリーンショット 2025-05-01 午後8 03 36" src="https://github.com/user-attachments/assets/1d3d5f1f-ba86-4795-9a8a-9281a7a6132e" />

Although status:income slightly lowers the cross-validation error, the improvement is too small to justify keeping a term with such a high p-value (≈ 0.67) and no significant contribution in ANOVA. Thus we delete the predictor variate `status:income`

## Outliers
We use Cook's Distance to Identify an Influential Outlier and refit the model after deleting it.

### Comparing with the original model
<img width="717" alt="スクリーンショット 2025-05-01 午後8 47 41" src="https://github.com/user-attachments/assets/fed3b87e-7cc6-4cd0-8257-e8df28119046" />

#### Before Deletion (teengamb)

    Adjusted R²: 0.426

    Residual SE: 1.134

    income: significant (p ≈ 4.7e-6)

    income:sexFemale: significant (p ≈ 0.00028)

#### After Deletion (teengamb_clean)

    Adjusted R²: 0.441

    Residual SE: 1.132

    income: still very significant (p ≈ 1e-5)

    income:sexFemale: still very significant (p ≈ 0.00023)

The output is almost negligible thus removing the outlier is not neccessary.

## Prediction Interval for sample Individuals
We Create 3 Sample Individual to Test the prediction intervals with out model.
### income = £10 per week, sex = Male
The predicted gambling expenditure is approximately £41.24, with a 95% prediction interval of £2.88 to £458.77.

### income = £25 per week, sex = Female
The predicted gambling expenditure is approximately £1.98, with a 95% prediction interval of £0 to £166.11.

### income = £40 per week, sex = Female
The predicted gambling expenditure is approximately £1.72, with a 95% prediction interval of £0 to £1,061.14.

## Final Model

`log(gamble + 1) ~ income + sex:income`

### Summary
<img width="595" alt="スクリーンショット 2025-05-01 午後9 00 23" src="https://github.com/user-attachments/assets/92a9395d-ed18-4ae6-8e20-5effac402f47" />

## Final Interpretation
We conclude that there does exist a significant relationship between income and yearly gambling expenditure but only among males. \
For each £1 increase in weekly income, males’ gambling expenditure increases substantially, while females’ gambling does not increase — in fact, it slightly decreases, but not meaningfully. \
We also see that there is no statistical evidence that the effect of weekly income on gambling expenditure depends on a teen's socioeconomic status.
