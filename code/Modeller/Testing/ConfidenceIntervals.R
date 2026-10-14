ConfidenceInterval <- function(model, type='asymptotic', level=0.95){

  if (type=='asymptotic') {
    return (confint.default(model, level=level))
  } else {
    return (confint(model, level=level))
  }

}
