if (requiet("testthat") &&
  requiet("insight") &&
  requiet("performance") &&
  requiet("datawizard") &&
  requiet("stats") &&
  requiet("parameters")) {
  .runThisTest <- Sys.getenv("RunAllinsightTests") == "yes"

  test_that("standardize_names works as expected with parameters", {
    set.seed(123)

    # lm object
    lm_mod <- lm(wt ~ mpg, mtcars)
    x <- as.data.frame(parameters::model_parameters(lm_mod))

    expect_equal(
      names(standardize_names(x, style = "broom")),
      c(
        "term", "estimate", "std.error", "conf.level", "conf.low", "conf.high",
        "statistic", "df.error", "p.value"
      )
    )

    expect_equal(
      names(standardize_names(x, style = "easystats")),
      c(
        "Parameter", "Coefficient", "SE", "CI", "CI_low", "CI_high",
        "Statistic", "df", "p"
      )
    )

    # aov object
    aov_mod <- aov(wt ~ mpg, mtcars)
    y <- as.data.frame(parameters::model_parameters(aov_mod))

    expect_equal(
      names(standardize_names(y, style = "broom")),
      c("term", "sumsq", "df", "meansq", "statistic", "p.value")
    )
  })


  # t-test (this is yet to be finalized)
  z <- as.data.frame(parameters::model_parameters(t.test(1:10, y = c(7:20))))

  expect_equal(
    names(standardize_names(z, style = "broom")),
    c(
      "parameter1", "parameter2", "mean.parameter1", "mean.parameter2", "estimate",
      "conf.level", "conf.low", "conf.high", "statistic", "df.error", "p.value",
      "method", "alternative"
    )
  )

  # chi-square test
  chi <- as.data.frame(parameters::model_parameters(chisq.test(matrix(c(12, 5, 7, 7), ncol = 2))))

  expect_equal(
    names(standardize_names(chi, style = "broom")),
    c("statistic", "df", "p.value", "method")
  )
}

test_that("standardize_names works as expected with performance", {
  set.seed(123)

  # lm object
  lm_mod <- lm(wt ~ mpg, mtcars)
  x <- as.data.frame(performance::model_performance(
    lm_mod,
    metrics = c("AIC", "BIC", "R2", "R2_adj", "RMSE", "SIGMA")
  ))

  expect_equal(
    names(standardize_names(x, style = "broom")),
    c("aic", "bic", "r.squared", "adj.r.squared", "rmse", "sigma")
  )
})

test_that("standardize_names works as expected with datawizard", {
  set.seed(123)

  x <- datawizard::describe_distribution(rnorm(50))

  expect_equal(
    names(standardize_names(x, style = "broom")),
    c(
      "estimate", "std.dev", "iqr", "min", "max", "skewness", "kurtosis",
      "n.obs", "missing.obs"
    )
  )
})
