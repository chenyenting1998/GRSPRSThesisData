#' @title  Estimate biovolume with Length-width Relationship
#' @description Estimate the biovolume of individuals with a published shapeless conversion factors.
#'
#' @param Length Length of an organism
#' @param Width Width of an organism
#' @param Conversion_factor Shapeless conversion factor. For available conversion factors,
#'                          please see Fellwe & Warwick (1998).
#'
#' @return
#' @export
#'
#' @examples
#' LWR(10, 20, 0.5)
LWR <- function(Length, Width, Conversion_factor) {
  Length * Width * Width * Conversion_factor
}
