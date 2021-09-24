#' @title Estimate biovolume with cylinder equation
#' @description Estimate the biovolume of individuals with cylinder equation.
#'
#' @param Length Length of an organism
#' @param Width Width of an organism
#'
#' @return The volume
#' @export
#'
#' @examples
#' Cylinder(15, 0.75)
Cylinder <- function(Length, Width) {
  Length * (Width / 2) * (Width / 2) * pi
}
