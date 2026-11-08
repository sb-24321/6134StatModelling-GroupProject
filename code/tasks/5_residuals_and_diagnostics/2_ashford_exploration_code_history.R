#Ashford matches
> #Poisson regression analysis
  > ashford <- read.csv(file.choose())
  > View(ashford)
  > 
    > #Create home/away dummy variable
    > ashford$home <- ifelse(tolower(trimws(ashford$home_away)) == "home", 1, 0)
    > 
      > #Exploratory plots
      > #Scores against opposing rank
      > plot(ashford$opponent_rank,
             +      
               +      ashford$goals_scored,
             +      
               +      xlab = "Opponent Rank",
             +      
               +      ylab = "Goals Scored",
             +      
               +      main = "Goals Scored vs Opponent Rank",
             +      
               +      pch = 19,
             +      
               +      col = ifelse(ashford$home == 1,
                                   +                   
                                     +                   "lightpink", "lightblue"))
    > 
      > legend("topright",
               +        
                 +        legend = c("Home", "Away"),
               +        
                 +        col = c("lightpink", "lightblue"),
               +        
                 +        pch = 19)
    > #Goals scores at home versus away
      > boxplot(goals_scored ~ home_away,
                +         
                  +         data = ashford,
                +         
                  +         xlab = "Match Location",
                +         
                  +         ylab = "Goals Scored",
                +         
                  +         main = "Goals Scored: Home vs Away",
                +         
                  +         col = c("lightblue", "lightpink"))
    > 
      > #Poisson regression using opponent rank
      > fit1 <- glm(goals_scored ~ opponent_rank,
                    +             
                      +             data = ashford,
                    +             
                      +             family = poisson)
      > 
        > summary(fit1)
      
      Call:
        glm(formula = goals_scored ~ opponent_rank, family = poisson, 
            data = ashford)
      
      Coefficients:
        Estimate Std. Error z value Pr(>|z|)   
      (Intercept)   -0.49334    0.32242  -1.530  0.12599   
      opponent_rank  0.05435    0.01939   2.802  0.00507 **
        ---
        Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
      
      (Dispersion parameter for poisson family taken to be 1)
      
      Null deviance: 64.844  on 45  degrees of freedom
      Residual deviance: 56.580  on 44  degrees of freedom
      AIC: 138.23
      
      Number of Fisher Scoring iterations: 5
      
      > par(mfrow = c(1, 2))
      > 
        > plot(fitted(fit1),
               +      
                 +      resid(fit1, type = "deviance"),
               +      
                 +      xlab = "Fitted Values",
               +      
                 +      ylab = "Deviance Residuals",
               +      
                 +      main = "Model 1 - Deviance",
               +      
                 +      pch = 19,
               +      
                 +      col = "lightpink")
      > 
        > abline(h = 0, col = "lightblue", lty = 2)
      > 
        > plot(fitted(fit1),
               +      
                 +      resid(fit1, type = "pearson"),
               +      
                 +      xlab = "Fitted Values",
               +      
                 +      ylab = "Pearson Residuals",
               +      
                 +      main = "Model 1 - Pearson",
               +      
                 +      pch = 19,
               +      
                 +      col = "lightpink")
      > 
        > abline(h = 0, col = "lightblue", lty = 2)
      > 
        > par(mfrow = c(1, 1))
      > 
        > #Add dummy variable
        > fit2 <- glm(goals_scored ~ opponent_rank + home,
                      +             
                        +             data = ashford,
                      +             
                        +             family = poisson)
      > 
        > summary(fit2)
      
      Call:
        glm(formula = goals_scored ~ opponent_rank + home, family = poisson, 
            data = ashford)
      
      Coefficients:
        Estimate Std. Error z value Pr(>|z|)   
      (Intercept)   -0.89880    0.37052  -2.426  0.01528 * 
        opponent_rank  0.05435    0.01939   2.802  0.00507 **
        home           0.69315    0.27386   2.531  0.01137 * 
        ---
        Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
      
      (Dispersion parameter for poisson family taken to be 1)
      
      Null deviance: 64.844  on 45  degrees of freedom
      Residual deviance: 49.785  on 43  degrees of freedom
      AIC: 133.43
      
      Number of Fisher Scoring iterations: 5
      
      > anova(fit1, fit2, test = "Chisq")
      Analysis of Deviance Table
      
      Model 1: goals_scored ~ opponent_rank
      Model 2: goals_scored ~ opponent_rank + home
      Resid. Df Resid. Dev Df Deviance Pr(>Chi)   
      1        44     56.580                        
      2        43     49.785  1    6.796 0.009136 **
        ---
        Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
      > plot(fitted(fit2),
             +      
               +      resid(fit2, type = "deviance"),
             +      
               +      xlab = "Fitted Values",
             +      
               +      ylab = "Deviance Residuals",
             +      
               +      main = "Model 2 - Deviance",
             +      
               +      pch = 19,
             +      
               +      col = "lightpink")
      > 
        > abline(h = 0, col = "lightblue", lty = 2)
      > 
        > plot(fitted(fit2),
               +      
                 +      resid(fit2, type = "pearson"),
               +      
                 +      xlab = "Fitted Values",
               +      
                 +      ylab = "Pearson Residuals",
               +      
                 +      main = "Model 2 - Pearson",
               +      
                 +      pch = 19,
               +      
                 +      col = "lightpink")
      > 
        > abline(h = 0, col = "lightblue", lty = 2)
      > 
        > par(mfrow = c(1, 1))
      > 
        > fit3 <- glm(goals_scored ~ opponent_rank +
                        +                 
                        +                 I(opponent_rank^2) + home,
                      +             
                        +             data = ashford,
                      +             
                        +             family = poisson)
      > 
        > summary(fit3)
      
      Call:
        glm(formula = goals_scored ~ opponent_rank + I(opponent_rank^2) + 
              home, family = poisson, data = ashford)
      
      Coefficients:
        Estimate Std. Error z value Pr(>|z|)  
      (Intercept)        -0.205372   0.487541  -0.421   0.6736  
      opponent_rank      -0.093363   0.079603  -1.173   0.2409  
      I(opponent_rank^2)  0.005533   0.002936   1.884   0.0595 .
      home                0.693147   0.273861   2.531   0.0114 *
        ---
        Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
      
      (Dispersion parameter for poisson family taken to be 1)
      
      Null deviance: 64.844  on 45  degrees of freedom
      Residual deviance: 46.336  on 42  degrees of freedom
      AIC: 131.98
      
      Number of Fisher Scoring iterations: 5
      
      > anova(fit2, fit3, test = "Chisq")
      Analysis of Deviance Table
      
      Model 1: goals_scored ~ opponent_rank + home
      Model 2: goals_scored ~ opponent_rank + I(opponent_rank^2) + home
      Resid. Df Resid. Dev Df Deviance Pr(>Chi)  
      1        43     49.785                       
      2        42     46.336  1   3.4488   0.0633 .
      ---
        Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
      > par(mfrow = c(1, 2))
      > 
        > plot(fitted(fit3),
               +      
                 +      resid(fit3, type = "deviance"),
               +      
                 +      xlab = "Fitted Values",
               +      
                 +      ylab = "Deviance Residuals",
               +      
                 +      main = "Model 3 - Deviance",
               +      
                 +      pch = 19,
               +      
                 +      col = "lightpink")
      > 
        > abline(h = 0, col = "lightblue", lty = 2)
      > 
        > plot(fitted(fit3),
               +      
                 +      resid(fit3, type = "pearson"),
               +      
                 +      xlab = "Fitted Values",
               +      
                 +      ylab = "Pearson Residuals",
               +      
                 +      main = "Model 3 - Pearson",
               +      
                 +      pch = 19,
               +      
                 +      col = "lightpink")
      > 
        > abline(h = 0, col = "lightblue", lty = 2)
      > 
        > par(mfrow = c(1, 1))
      > 
        > fit4 <- glm(goals_scored ~ opponent_rank * home,
                      +             
                        +             data = ashford,
                      +             
                        +             family = poisson)
      > 
        > summary(fit4)
      
      Call:
        glm(formula = goals_scored ~ opponent_rank * home, family = poisson, 
            data = ashford)
      
      Coefficients:
        Estimate Std. Error z value Pr(>|z|)
      (Intercept)        -0.65906    0.52508  -1.255    0.209
      opponent_rank       0.03822    0.03276   1.167    0.243
      home                0.32386    0.66511   0.487    0.626
      opponent_rank:home  0.02453    0.04069   0.603    0.547
      
      (Dispersion parameter for poisson family taken to be 1)
      
      Null deviance: 64.844  on 45  degrees of freedom
      Residual deviance: 49.423  on 42  degrees of freedom
      AIC: 135.07
      
      Number of Fisher Scoring iterations: 5
      
      > anova(fit2, fit4, test = "Chisq")
      Analysis of Deviance Table
      
      Model 1: goals_scored ~ opponent_rank + home
      Model 2: goals_scored ~ opponent_rank * home
      Resid. Df Resid. Dev Df Deviance Pr(>Chi)
      1        43     49.785                     
      2        42     49.423  1  0.36103   0.5479
      > par(mfrow = c(1, 2))
      > 
        > plot(fitted(fit4),
               +      
                 +      resid(fit4, type = "deviance"),
               +      
                 +      xlab = "Fitted Values",
               +      
                 +      ylab = "Deviance Residuals",
               +      
                 +      main = "Model 4 - Deviance",
               +      
                 +      pch = 19,
               +      
                 +      col = "lightpink")
      > 
        > abline(h = 0, col = "lightblue", lty = 2)
      > 
        > plot(fitted(fit4),
               +      
                 +      resid(fit4, type = "pearson"),
               +      
                 +      xlab = "Fitted Values",
               +      
                 +      ylab = "Pearson Residuals",
               +      
                 +      main = "Model 4 - Pearson",
               +      
                 +      pch = 19,
               +      
                 +      col = "lightpink")
      > 
        > abline(h = 0, col = "lightblue", lty = 2)
      > 
        > par(mfrow = c(1, 1))
      > 
        > #compare fitted regression curves
        > 
        > # Create sequence of opponent ranks
        > 
        > rank_values <- seq(min(ashford$opponent_rank),
                             +                    
                               +                    max(ashford$opponent_rank),
                             +                    
                               +                    length.out = 100)
      > 
        > # Create prediction datasets
        > 
        > home_data <- data.frame(
          +     
            +     opponent_rank = rank_values,
          +     
            +     home = 1
          +     
            + )
      > 
        > away_data <- data.frame(
          +     
            +     opponent_rank = rank_values,
          +     
            +     home = 0
          +     
            + )
      > 
        > # Plot observed goals
        > 
        > plot(ashford$opponent_rank,
               +      
                 +      ashford$goals_scored,
               +      
                 +      xlab = "Opponent Rank",
               +      
                 +      ylab = "Goals Scored",
               +      
                 +      main = "Poisson Regression Model Comparison",
               +      
                 +      pch = 19,
               +      
                 +      col = ifelse(ashford$home == 1,
                                     +                   
                                       +                   "lightpink", "lightblue"))
      > 
        > # Model 1
        > 
        > lines(rank_values,
                +       
                  +       predict(fit1, newdata = home_data,
                                  +               
                                    +               type = "response"),
                +       
                  +       col = "black",
                +       
                  +       lwd = 2)
      > 
        > # Model 2: Home
        > 
        > lines(rank_values,
                +       
                  +       predict(fit2, newdata = home_data,
                                  +               
                                    +               type = "response"),
                +       
                  +       col = "lightpink",
                +       
                  +       lwd = 2)
      > 
        > # Model 2: Away
        > 
        > lines(rank_values,
                +       
                  +       predict(fit2, newdata = away_data,
                                  +               
                                    +               type = "response"),
                +       
                  +       col = "lightblue",
                +       
                  +       lwd = 2)
      > 
        > # Model 3: Home
        > 
        > lines(rank_values,
                +       
                  +       predict(fit3, newdata = home_data,
                                  +               
                                    +               type = "response"),
                +       
                  +       col = "deeppink",
                +       
                  +       lwd = 2,
                +       
                  +       lty = 2)
      > 
        > # Model 4: Home
        > 
        > lines(rank_values,
                +       
                  +       predict(fit4, newdata = home_data,
                                  +               
                                    +               type = "response"),
                +       
                  +       col = "hotpink",
                +       
                  +       lwd = 2,
                +       
                  +       lty = 3)
      > 
        > # Model 4: Away
        > 
        > lines(rank_values,
                +       
                  +       predict(fit4, newdata = away_data,
                                  +               
                                    +               type = "response"),
                +       
                  +       col = "steelblue",
                +       
                  +       lwd = 2,
                +       
                  +       lty = 3)
      > 
        > # Add legend
        > 
        > legend("topright",
                 +        
                   +        legend = c("Model 1",
                                       +                   
                                         +                   "Model 2 - Home",
                                       +                   
                                         +                   "Model 2 - Away",
                                       +                   
                                         +                   "Model 3 - Home",
                                       +                   
                                         +                   "Model 4 - Home",
                                       +                   
                                         +                   "Model 4 - Away"),
                 +        
                   +        col = c("black",
                                    +                
                                      +                "lightpink",
                                    +                
                                      +                "lightblue",
                                    +                
                                      +                "deeppink",
                                    +                
                                      +                "hotpink",
                                    +                
                                      +                "steelblue"),
                 +        
                   +        lty = c(1, 1, 1, 2, 3, 3),
                 +        
                   +        lwd = 2,
                 +        
                   +        cex = 0.7)
      > 
        > # Question 7: Compare model performance
        > 
        > # Compare AIC values
        > 
        > AIC(fit1, fit2, fit3, fit4)
      df      AIC
      fit1  2 138.2286
      fit2  3 133.4326
      fit3  4 131.9838
      fit4  4 135.0716
      > 
        > # Check for overdispersion
        > 
        > dispersion <- sapply(
          +     
            +     list(fit1, fit2, fit3, fit4),
          +     
            +     function(model) {
              +         
                +         sum(residuals(model, type = "pearson")^2) /
                +             
                +             df.residual(model)
              +         
                +     }
          +     
            + )
      > 
        > names(dispersion) <- c("Model 1",
                                 +                        
                                   +                        "Model 2",
                                 +                        
                                   +                        "Model 3",
                                 +                        
                                   +                        "Model 4")
      > 
        > dispersion
      Model 1   Model 2   Model 3   Model 4 
      1.1582226 0.9904079 0.8837302 0.9848625 