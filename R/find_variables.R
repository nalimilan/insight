#' @title Find names of all variables
#' @name find_variables
#'
#' @description Returns a list with the names of all variables, including
#'   response value and random effects.
#'
#' @inheritParams find_predictors
#' @inheritParams find_formula
#'
#' @note The difference to [find_terms()] is that
#'   `find_variables()` returns each variable name only once, while
#'   `find_terms()` may return a variable multiple times in case of
#'   transformations or when arithmetic expressions were used in the formula.
#'
#' @inheritSection find_predictors Model components
#'
#' @return A list with (depending on the model) following elements (character
#'    vectors):
#' - `response`, the name of the response variable
#' - `conditional`, the names of the predictor variables from the *conditional* model (as opposed to the zero-inflated part of a model)
#' - `cluster`, the names of cluster or grouping variables
#' - `dispersion`, the name of the dispersion terms
#' - `instruments`, the names of instrumental variables
#' - `random`, the names of the random effects (grouping factors)
#' - `zero_inflated`, the names of the predictor variables from the *zero-inflated* part of the model
#' - `zero_inflated_random`, the names of the random effects (grouping factors)
#'
#' @examples
#' if (require("lme4")) {
#'   data(cbpp)
#'   data(sleepstudy)
#'   # some data preparation...
#'   cbpp$trials <- cbpp$size - cbpp$incidence
#'   sleepstudy$mygrp <- sample(1:5, size = 180, replace = TRUE)
#'   sleepstudy$mysubgrp <- NA
#'   for (i in 1:5) {
#'     filter_group <- sleepstudy$mygrp == i
#'     sleepstudy$mysubgrp[filter_group] <-
#'       sample(1:30, size = sum(filter_group), replace = TRUE)
#'   }
#'
#'   m1 <- glmer(
#'     cbind(incidence, size - incidence) ~ period + (1 | herd),
#'     data = cbpp,
#'     family = binomial
#'   )
#'   find_variables(m1)
#'
#'   m2 <- lmer(
#'     Reaction ~ Days + (1 | mygrp / mysubgrp) + (1 | Subject),
#'     data = sleepstudy
#'   )
#'   find_variables(m2)
#'   find_variables(m2, flatten = TRUE)
#' }
#' @export
find_variables <- function(x,
                           effects = "all",
                           component = "all",
                           flatten = FALSE,
                           verbose = TRUE) {
  effects <- match.arg(effects, choices = c("all", "fixed", "random"))
  component <- match.arg(component, choices = c("all", "conditional", "zi", "zero_inflated", "dispersion", "instruments", "smooth_terms"))

  if (component %in% c("all", "conditional")) {
    resp <- find_response(x, combine = FALSE)
  } else {
    resp <- NULL
  }

  pr <- find_predictors(
    x,
    effects = effects,
    component = component,
    flatten = flatten,
    verbose = verbose
  )

  if (flatten) {
    unique(c(resp, pr))
  } else if (is.null(resp)) {
    pr
  } else {
    c(list(response = resp), pr)
  }
}
