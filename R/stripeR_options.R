.onLoad <- function(libname, pkgname) {

  op <- options()
  op.stripeR <- list(
    stripeR.secret_test = Sys.getenv("stripeR.secret_test"),
    stripeR.public_test = Sys.getenv("stripeR.public_test"),
    stripeR.secret_live = Sys.getenv("stripeR.secret_live"), ## WARNING DO NOT PUBLISH I:E TO GITHUB
    stripeR.public_live = Sys.getenv("stripeR.public_live") ## WARNING DO NOT PUBLISH I:E TO GITHUB

  )
  toset <- !(names(op.stripeR) %in% names(op))
  if(any(toset)) options(op.stripeR[toset])

  invisible()

}
