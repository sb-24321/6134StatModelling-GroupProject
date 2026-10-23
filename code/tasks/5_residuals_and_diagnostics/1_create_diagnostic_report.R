create_diagnostic_report <- function(model, model_name){
  # Load the model =========================================================================

  ## Get the model type:
  model_type <- model$family[[1]]

  # Testing the model on different metrics =================================================

  page1 <- capture.output({
    cat("MODEL SUMMARY\n\n")
    print(summary(model))
  })

  page2 <- capture.output({
    cat("\nEXPONENTIATED COEFFICIENTS\n\n")
    print(exp(coef(model)))

    cat("\nEXPONENTIATED CONFIDENCE INTERVALS\n\n")
    print(exp(confint(model)))
  })

  # Analysis of Deviance table
  page3 <- capture.output({
    print(anova(model, test = "Chisq"))
  })

  # Save the diagnostic information ========================================================

  # Create the pdf
  filename <- paste0(model_name, '_diagnostics.pdf')
  filepath <- paste0('./outputs/diagnostic_reports/', model_type,'/', filename)
  dir.create(filepath, recursive=TRUE, showWarnings=FALSE)
  pdf(filepath)

  # Write the console outputs to the pdf.
  plot.new()
  text(
       x = 0,
       y = 1,
       labels = paste(page1, collapse = "\n"),
       adj = c(0, 1),
       family = "mono",
       cex = 0.5
  )

  plot.new()
  text(
       x = 0,
       y = 1,
       labels = paste(page2, collapse = "\n"),
       adj = c(0, 1),
       family = "mono",
       cex = 0.5
  )

  plot.new()
  text(
       x = 0,
       y = 1,
       labels = paste(page3, collapse = "\n"),
       adj = c(0, 1),
       family = "mono",
       cex = 0.5
  )

  # Residuals vs Fitted
  plot(model, which = 1)

  # QQ Plot
  plot(model, which = 2)

  # Cooks distance.
  cd <- cooks.distance(model)

  plot(cd, type = "h",
       xlab = "Observation",
       ylab = "Cook's distance",
       main = "Cook's Distance")

  abline(h = 8 / length(cd), col = "red", lty = 2)

  # Labels influential observarions
  idx <- which(cd > 8 / length(cd))

  text(x = idx, y = cd[idx],
       labels = idx,
       pos = 3, cex = 0.7, col = "red")

  dev.off()
}

