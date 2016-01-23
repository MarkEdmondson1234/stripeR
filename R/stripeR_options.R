.onLoad <- function(libname, pkgname) {

  op <- options()
  op.stripeR <- list(
    stripeR.secret_test = "sk_test_tUdZkwiXEAuIksPEVSWwDQWC",
    stripeR.public_test = "pk_test_uvPJ2bAcdwezpQjV1V4N5vAe",
    stripeR.secret_live = "sk_live_XXX", ## WARNING DO NOT PUBLISH I:E TO GITHUB
    stripeR.public_live = "pk_live_XXX" ## WARNING DO NOT PUBLISH I:E TO GITHUB

  )
  toset <- !(names(op.stripeR) %in% names(op))
  if(any(toset)) options(op.stripeR[toset])

  invisible()

}
