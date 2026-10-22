# Week 4 Statistical Modelling
# Temperature and Sex of Turtles
# Logistic Regression Analysis


# Question 1: Observed proportions against temperature

plot(turtle$temp,
     turtle$female / (turtle$male + turtle$female),
     xlab = "Temperature",
     ylab = "Proportion of Females",
     main = "Observed Proportion of Female Turtles",
     pch = 19)


# Question 2: Linear logistic regression

# Create response variable
y <- cbind(turtle$female, turtle$male)

# Fit linear logistic regression model
fit1 <- glm(y ~ temp,
            data = turtle,
            family = binomial)

# View model results
summary(fit1)

# Plot deviance and Pearson residuals
par(mfrow = c(1, 2))

# Deviance residuals
plot(fitted(fit1), resid(fit1, type = "deviance"),
     xlab = "Fitted Values",
     ylab = "Deviance Residuals",
     main = "Linear Model - Deviance",
     pch = 19,
     col = "steelblue")

abline(h = 0, col = "red", lty = 2)

# Pearson residuals
plot(fitted(fit1), resid(fit1, type = "pearson"),
     xlab = "Fitted Values",
     ylab = "Pearson Residuals",
     main = "Linear Model - Pearson",
     pch = 19,
     col = "steelblue")

abline(h = 0, col = "red", lty = 2)

par(mfrow = c(1, 1))


# Question 3: Quadratic logistic regression

# Fit quadratic logistic regression model
fit2 <- glm(y ~ poly(temp, 2),
            data = turtle,
            family = binomial)

# View quadratic model results
summary(fit2)

# Compare linear and quadratic models
anova(fit1, fit2, test = "Chisq")

# Plot quadratic model residuals
par(mfrow = c(1, 2))

# Deviance residuals
plot(fitted(fit2), resid(fit2, type = "deviance"),
     xlab = "Fitted Values",
     ylab = "Deviance Residuals",
     main = "Quadratic Model - Deviance",
     pch = 19,
     col = "steelblue")

abline(h = 0, col = "red", lty = 2)

# Pearson residuals
plot(fitted(fit2), resid(fit2, type = "pearson"),
     xlab = "Fitted Values",
     ylab = "Pearson Residuals",
     main = "Quadratic Model - Pearson",
     pch = 19,
     col = "steelblue")

abline(h = 0, col = "red", lty = 2)

par(mfrow = c(1, 1))


# Question 4: Cubic and quartic logistic regression

# Fit cubic logistic regression model
fit3 <- glm(y ~ poly(temp, 3),
            data = turtle,
            family = binomial)

# View cubic model results
summary(fit3)

# Compare quadratic and cubic models
anova(fit2, fit3, test = "Chisq")

# Plot cubic model residuals
par(mfrow = c(1, 2))

# Deviance residuals
plot(fitted(fit3), resid(fit3, type = "deviance"),
     xlab = "Fitted Values",
     ylab = "Deviance Residuals",
     main = "Cubic Model - Deviance",
     pch = 19,
     col = "steelblue")

abline(h = 0, col = "red", lty = 2)

# Pearson residuals
plot(fitted(fit3), resid(fit3, type = "pearson"),
     xlab = "Fitted Values",
     ylab = "Pearson Residuals",
     main = "Cubic Model - Pearson",
     pch = 19,
     col = "steelblue")

abline(h = 0, col = "red", lty = 2)

par(mfrow = c(1, 1))


# Fit quartic logistic regression model
fit4 <- glm(y ~ poly(temp, 4),
            data = turtle,
            family = binomial)

# View quartic model results
summary(fit4)

# Compare cubic and quartic models
anova(fit3, fit4, test = "Chisq")

# Plot quartic model residuals
par(mfrow = c(1, 2))

# Deviance residuals
plot(fitted(fit4), resid(fit4, type = "deviance"),
     xlab = "Fitted Values",
     ylab = "Deviance Residuals",
     main = "Quartic Model - Deviance",
     pch = 19,
     col = "steelblue")

abline(h = 0, col = "red", lty = 2)

# Pearson residuals
plot(fitted(fit4), resid(fit4, type = "pearson"),
     xlab = "Fitted Values",
     ylab = "Pearson Residuals",
     main = "Quartic Model - Pearson",
     pch = 19,
     col = "steelblue")

abline(h = 0, col = "red", lty = 2)

par(mfrow = c(1, 1))


# Question 5: Comparison of fitted regression curves

# Create a sequence of temperatures
tempstar <- seq(26, 30, 0.01)

# Create prediction dataset
newdata <- data.frame(temp = tempstar)

# Plot observed proportions
plot(turtle$temp,
     turtle$female / (turtle$male + turtle$female),
     pch = 16,
     xlab = "Temperature (C)",
     ylab = "Proportion of Female Turtles",
     main = "Comparison of Logistic Regression Models",
     col = "black",
     ylim = c(0, 1))

# Linear model
lines(tempstar,
      predict(fit1, newdata = newdata, type = "response"),
      col = "blue",
      lty = 1,
      lwd = 2)

# Quadratic model
lines(tempstar,
      predict(fit2, newdata = newdata, type = "response"),
      col = "red",
      lty = 2,
      lwd = 2)

# Cubic model
lines(tempstar,
      predict(fit3, newdata = newdata, type = "response"),
      col = "darkgreen",
      lty = 3,
      lwd = 2)

# Quartic model
lines(tempstar,
      predict(fit4, newdata = newdata, type = "response"),
      col = "purple",
      lty = 4,
      lwd = 2)

# Add legend
legend("topright",
       legend = c("Linear", "Quadratic", "Cubic", "Quartic"),
       col = c("blue", "red", "darkgreen", "purple"),
       lty = c(1, 2, 3, 4),
       lwd = 2,
       cex = 0.8)

.