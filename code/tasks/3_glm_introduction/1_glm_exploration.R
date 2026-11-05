# Week 3: Generalised linear models - setting up and exploring responses
# Run from the project root. Edit data_dir if the CSVs live elsewhere.

data_dir <- "."
out_dir  <- file.path("outputs", "Week 3")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

matches <- read.csv(file.path(data_dir, "ashford_matches.csv"), stringsAsFactors = FALSE)
players <- read.csv(file.path(data_dir, "league_players.csv"),  stringsAsFactors = FALSE)

matches$home_away <- factor(matches$home_away, levels = c("Away", "Home"))  # Away = reference
players$position  <- factor(players$position)
players$team      <- factor(players$team)

str(matches); str(players)

# ---------------------------------------------------------------------------
# 1-3. Responses, explanatory variables, type, family and link
# ---------------------------------------------------------------------------
variable_plan <- data.frame(
  dataset     = c("players", "matches", "matches", "players", "players", "players"),
  response    = c("injured", "goals_scored", "goals_conceded",
                  "prev_injuries", "minutes_played", "bmi"),
  type        = c("binary (0/1)", "count", "count", "count",
                  "continuous (positive)", "continuous"),
  family      = c("binomial", "poisson", "poisson", "poisson",
                  "gaussian (or Gamma)", "gaussian"),
  link        = c("logit (alt: probit, cloglog)", "log", "log", "log",
                  "identity (Gamma: log)", "identity"),
  explanatory = c("position, age, minutes_played, training_load, prev_injuries, bmi (team as grouping)",
                  "home_away, opponent_rank",
                  "home_away, opponent_rank",
                  "age, position, minutes_played, bmi",
                  "age, position, training_load, bmi",
                  "age, position"),
  notes       = c("Main response of interest",
                  "Check overdispersion; quasipoisson / negative binomial if needed",
                  "Check overdispersion",
                  "More naturally an explanatory variable for injured",
                  "Bounded above, so Gaussian is approximate",
                  "Roughly symmetric, so Gaussian is reasonable"),
  stringsAsFactors = FALSE
)
print(variable_plan)
write.csv(variable_plan, file.path(out_dir, "variable_plan.csv"), row.names = FALSE)

# ---------------------------------------------------------------------------
# 4a. Injury proportions
# ---------------------------------------------------------------------------
prop_table <- function(g) {
  data.frame(group    = names(table(g)),
             n        = as.vector(table(g)),
             injured  = as.vector(tapply(players$injured, g, sum)),
             prop     = as.vector(tapply(players$injured, g, mean)))
}
inj_overall  <- data.frame(group = "All players", n = nrow(players),
                           injured = sum(players$injured), prop = mean(players$injured))
inj_position <- prop_table(players$position)
inj_team     <- prop_table(players$team)
inj_previous <- prop_table(factor(players$prev_injuries))

inj_all <- rbind(cbind(by = "overall",        inj_overall),
                 cbind(by = "position",       inj_position),
                 cbind(by = "prev_injuries",  inj_previous),
                 cbind(by = "team",           inj_team))
print(inj_all)
write.csv(inj_all, file.path(out_dir, "injury_proportions.csv"), row.names = FALSE)

# Ashford vs the rest of the league
ash   <- players$team == "Ashford United"
tab   <- table(Ashford = ash, Injured = players$injured)
fisher_ash <- fisher.test(tab)
print(tab); print(fisher_ash)

png(file.path(out_dir, "injury_by_position.png"), width = 700, height = 500)
barplot(inj_position$prop, names.arg = inj_position$group, ylim = c(0, 0.4),
        ylab = "Proportion injured", main = "Injury proportion by position")
abline(h = mean(players$injured), lty = 2)
dev.off()

# ---------------------------------------------------------------------------
# 4b. Means and variances of count variables (Poisson: mean ~ variance)
# ---------------------------------------------------------------------------
mv <- function(x) c(n = length(x), mean = mean(x), var = var(x), var_over_mean = var(x) / mean(x))

count_overall <- rbind(goals_scored   = mv(matches$goals_scored),
                       goals_conceded = mv(matches$goals_conceded),
                       prev_injuries  = mv(players$prev_injuries))
count_by_venue <- do.call(rbind, lapply(c("goals_scored", "goals_conceded"), function(v) {
  r <- t(sapply(split(matches[[v]], matches$home_away), mv))
  data.frame(variable = v, home_away = rownames(r), r, row.names = NULL)
}))
print(round(count_overall, 3)); print(count_by_venue)
write.csv(round(count_overall, 3), file.path(out_dir, "count_mean_variance_overall.csv"))
write.csv(count_by_venue,          file.path(out_dir, "count_mean_variance_by_venue.csv"), row.names = FALSE)

png(file.path(out_dir, "goals_scored_vs_poisson.png"), width = 700, height = 500)
obs <- table(factor(matches$goals_scored, levels = 0:max(matches$goals_scored)))
exp_p <- dpois(0:max(matches$goals_scored), mean(matches$goals_scored)) * nrow(matches)
bp <- barplot(as.vector(obs), names.arg = names(obs), xlab = "Goals scored",
              ylab = "Matches", main = "Goals scored: observed vs Poisson")
points(bp, exp_p, pch = 19, col = "red", type = "b")
legend("topright", legend = "Poisson expected", pch = 19, col = "red", bty = "n")
dev.off()

# ---------------------------------------------------------------------------
# 5. Gaussian glm() vs lm()
#    The Week 2 lm is not available to me, so I assume goals_scored ~ home_away + opponent_rank.
#    Swap in your own formula here.
# ---------------------------------------------------------------------------
frm <- goals_scored ~ home_away + opponent_rank
fit_lm  <- lm(frm, data = matches)
fit_glm <- glm(frm, data = matches, family = gaussian(link = "identity"))

print(summary(fit_lm)); print(summary(fit_glm))

cmp_coef <- data.frame(term = names(coef(fit_lm)),
                       lm_est  = coef(fit_lm),  glm_est = coef(fit_glm),
                       lm_se   = summary(fit_lm)$coefficients[, "Std. Error"],
                       glm_se  = summary(fit_glm)$coefficients[, "Std. Error"],
                       lm_t    = summary(fit_lm)$coefficients[, "t value"],
                       glm_t   = summary(fit_glm)$coefficients[, "t value"],
                       row.names = NULL)
cmp_fit <- data.frame(
  quantity = c("residual variance (sigma^2 / dispersion)", "RSS / deviance",
               "residual df", "logLik", "AIC"),
  lm  = c(summary(fit_lm)$sigma^2,  sum(residuals(fit_lm)^2), df.residual(fit_lm),
          as.numeric(logLik(fit_lm)),  AIC(fit_lm)),
  glm = c(summary(fit_glm)$dispersion, deviance(fit_glm), df.residual(fit_glm),
          as.numeric(logLik(fit_glm)), AIC(fit_glm)))
print(cmp_coef); print(cmp_fit)
print(all.equal(unname(coef(fit_lm)), unname(coef(fit_glm))))
write.csv(cmp_coef, file.path(out_dir, "lm_vs_gaussian_glm_coefficients.csv"), row.names = FALSE)
write.csv(cmp_fit,  file.path(out_dir, "lm_vs_gaussian_glm_fit.csv"),          row.names = FALSE)

sink(file.path(out_dir, "model_summaries.txt"))
cat("== lm ==\n");  print(summary(fit_lm))
cat("\n== Gaussian glm (identity link) ==\n"); print(summary(fit_glm))
cat("\n== Ashford vs rest, Fisher exact test ==\n"); print(tab); print(fisher_ash)
sink()

writeLines(capture.output(sessionInfo()), file.path(out_dir, "sessionInfo.txt"))
