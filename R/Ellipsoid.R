#' @title Estimate biovolume with ellipsoid equation
#' @description Estimate the biovolume of individuals with ellipsoid equation.
#'
#' @param Length Length of an organism
#' @param Width Width of an organism
#'
#' @return
#' @export
#'
#' @examples
#' Ellipsoid(10, 5)
Ellipsoid <- function(Length, Width) {
  4 / 3 * pi * (Length / 2) * (Width / 2) * (Width / 2)
}
