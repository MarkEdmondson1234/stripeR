#' Idempotency
#'
#' A random code to ensure no repeats
#' @param seed Random seed
#'
#' @return A random 15 digit hash
#'
#' @export
idempotency <- function(seed = 1234567){
  set.seed(seed)
  paste(sample(c(LETTERS, letters, 0:9), 15, TRUE),collapse="")
}

#' Is this a try error?
#'
#' Utility to test errors
#'
#' @param test_me an object created with try()
#'
#' @return Boolean
#'
#' @keywords internal
is.error <- function(test_me){
  inherits(test_me, "try-error")
}

#' Get the error message
#'
#' @param test_me an object that has failed is.error
#'
#' @return The error message
#'
#' @keywords internal
error.message <- function(test_me){
  if(is.error(test_me)) attr(test_me, "condition")$message
}

#' Make Metadata keys
#'
#' Can have 20 keys total, keynames < 40, values < 500
#'
#' @param meta_list A named list of meta data
#'
#' @return meta data suitable to pass to API
#' @keywords internal
make_meta <- function(metadata){

  stopifnot(max(nchar(names(metadata))) <= 40,
            max(nchar(metadata)) <= 500,
            length(metadata) <= 20)

  names(metadata) <- paste0("metadata[",names(metadata),"]")

  metadata

}
