# Load and inspect the Teen Gambling dataset
teengamb <- faraway::teengamb
?faraway::teengamb
head(teengamb)
library(leaps)
library(MASS)

# Visualize relationship between income and gambling expenditure
plot(teengamb$income, teengamb$gamble, main = "Gambling Expenditure per Year (pounds) vs income per week (pounds)",
     xlab="Income per Week (pounds)", 
     ylab="Gambling Expenditure per Year (pounds)")
model <- lm(gamble ~ income, data = teengamb)
abline(model)

# Set sex as a factor and plot gambling expenditure by sex
teengamb$sex <- factor(teengamb$sex, labels = c("Male", "Female"))
boxplot(gamble ~ sex, data = teengamb,
        main = "Gambling Expenditure by Sex (pounds)",
        xlab = "Sex",
        ylab = "Gambling Expenditure per Year (pounds)",
        col = c("lightblue", "lightgreen"))

# Exhaustive subset selection using Adjusted R², BIC, and Mallow's Cp
full_model <- lm(gamble ~ sex + status + income + verbal + status*income + sex*income + sex*verbal, data = teengamb)
selection <- regsubsets(gamble ~ sex + status + income + verbal + status*income + sex*income + sex*verbal, data = teengamb, method = "exhaustive")
selection_summary <- summary(selection)

# Plot Adjusted R² for model selection
plot(1:7, selection_summary$adjr2,
     type = "b", pch=16, lty=2,
     xlab = "# of Predictor Variates", ylab = "Adjusted R²",
     main = "Adjusted R² for Subset Models")

# Plot BIC for model selection
plot(1:7, selection_summary$bic,
     type = "b", pch = 16, lty=2, col = "darkgreen",
     xlab = "# Predictor Variates", ylab = "BIC",
     main = "BIC vs. Number of Predictors")

# Plot Mallow's Cp for model selection
plot(1:7, selection_summary$cp,
     type = "b", pch = 16, lty=2, col = "purple",
     xlab = "# Predictor Variates", ylab = "Mallow's Cp",
     main = "Mallow's Cp vs. Number of Predictors")

# Fit selected linear model with interaction terms
mod_3 <- lm(gamble ~ income + status*income + sex*income, data = teengamb)

# Residual plot to check for heteroscedasticity (variance consistency)
plot(mod_3$fitted.values, resid(mod_3),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "Residuals vs Fitted (3 Predictor Model)")

# QQ plot to assess normality of residuals
qqnorm(resid(mod_3))
qqline(resid(mod_3))

# Use Box-Cox transformation to determine suitable transformation (must load MASS)
mod_3_shifted <- lm(I(gamble + 1) ~ income + status:income + sex:income, data = teengamb)
bc <- boxcox(mod_3_shifted, plotit=TRUE)
bc$x[which.max(bc$y)]

# Fit model using log transformation to stabilize variance and handle zeros
mod_3_log <- lm(log(gamble + 1) ~ income + status:income + sex:income, data = teengamb)

# Residual plot for transformed model
plot(mod_3_log$fitted.values, resid(mod_3_log),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "Residuals vs Fitted After Log Transformation")

# QQ plot for transformed model residuals
qqnorm(resid(mod_3_log))
qqline(resid(mod_3_log))

# View summary statistics of the transformed model
summary(mod_3_log)

# Extract confidence intervals for coefficients of the log model
confint(mod_3_log)

# Compare full interaction model to simpler model with only income via ANOVA
model_reduced <- lm(log(gamble + 1) ~ income, data = teengamb)
anova(model_reduced, mod_3_log)

# Identify influential observation using Cook’s Distance
cooks_d <- cooks.distance(mod_3_log)
which.max(cooks_d)  # Index of most influential point

# Refit model without influential point
influential_index <- which.max(cooks_d)
teengamb_clean <- teengamb[-influential_index, ]
mod_3_clean <- lm(log(gamble + 1) ~ income + status:income + sex:income, data = teengamb_clean)
summary(mod_3_clean)

# Refit reduced model without influential point
model_reduced_clean <- lm(log(gamble + 1) ~ income, data = teengamb_clean)
anova(model_reduced_clean, mod_3_clean)

# Predict log-transformed gambling for new individuals, back-transform to original scale
new_data <- data.frame(
  income = c(10, 25, 40),
  status = c(30, 45, 60),
  sex = factor(c("Male", "Female", "Female"), levels = c("Male", "Female"))
)
# Predict on log scale with 95% prediction intervals
log_preds <- predict(mod_3_log, newdata = new_data, interval = "prediction", level = 0.95)
# Back-transform from log(gamble + 1) to original gamble scale
exp(log_preds) - 1

# Final model summary
summary(mod_3_log)
