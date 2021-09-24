#' @title Estimate biovolume with cone equation
#' @description Estimate the biovolume of individuals with cone equation.
#'
#' @param Length Length of an organism
#' @param Width Width of an organism
#'
#' @return
#' @export
#'
#' @examples
#' Cone(30, 1)
Cone <- function(Length, Width) {
  Length * (Width / 2) * (Width / 2) * pi / 3
}
