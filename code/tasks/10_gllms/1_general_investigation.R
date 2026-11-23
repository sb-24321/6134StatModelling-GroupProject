# install.packages(c("lme4", "MuMIn", "MASS", "nnet"))
library(lme4)
library(MuMIn)
library(MASS)
library(nnet)

options(na.action = "na.fail")   # required by dredge()
players <- read.csv("./data/league_players.csv")

players$team     <- factor(players$team)
players$position <- factor(players$position)

responses <- c("injured", "age", "minutes_played", "training_load",
               "prev_injuries", "bmi", "position")

select_best_model <- function(y, data) {
  preds <- setdiff(names(data), c(y, "team"))
  d <- data[complete.cases(data[, c(y, "team", preds)]), ]
  rhs <- paste(preds, collapse = " + ")

  # Categorical response: multinomial model, no random effect (nnet cannot fit one)
  if (is.factor(d[[y]]) && nlevels(d[[y]]) > 2) {
    f    <- as.formula(paste(y, "~", rhs))
    full <- multinom(f, data = d, trace = FALSE)
    best <- stepAIC(full, trace = FALSE)
    return(list(model = best, type = "multinomial logistic (no random effect)"))
  }

  f <- as.formula(paste(y, "~", rhs, "+ (1 | team)"))

  if (y == "injured") {
    full <- glmer(f, data = d, family = binomial)
    type <- "mixed logistic (binomial)"
  } else if (y == "prev_injuries") {
    full <- glmer.nb(f, data = d)
    type <- "mixed negative binomial (counts)"
  } else {
    full <- lmer(f, data = d, REML = FALSE)   # ML fit so AICc can compare fixed effects
    type <- "mixed linear (gaussian)"
  }

  dd   <- dredge(full, rank = "AICc")
  best <- get.models(dd, subset = 1)[[1]]
  list(model = best, type = type)
}

# Main ==================================================================================

cat("\n### STARTED 10_gllms/1_general_investigation.R ###\n")

# For each response variable, create the best model.
results <- setNames(lapply(responses, function(y) {

                   cat(paste0("\nTesting: ", y, "\n"))
  suppressMessages(
                   tryCatch(select_best_model(y, players), error = function(e) {
    message("Failed for ", y, ": ", conditionMessage(e))
    NULL
  }))
}), responses)

for (y in responses) {
  r <- results[[y]]
  if (is.null(r)) next

  f <- formula(r$model)

  cat("\n=== Response:", y, "===\n")
  cat("Fixed-effect variables:\n")
  print(labels(terms(nobars(f))))

  if (!is.null(findbars(f))) {
    cat("Random-effect term:", deparse(findbars(f)[[1]]), "\n")
  } else {
    cat("Random-effect term: none\n")
  }
}

cat("\n### FINISHED 10_gllms/1_general_investigation.R ###\n")



