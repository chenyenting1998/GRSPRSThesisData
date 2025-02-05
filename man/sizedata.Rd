% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sizedata.R
\docType{data}
\name{sizedata}
\alias{sizedata}
\alias{size_LGD_2006}
\alias{size_OR1_1219}
\alias{size_OR1_1242}
\title{Individual size data of all cruises}
\format{
An object of class \code{data.frame} with 2282 rows and 20 columns.

An object of class \code{data.frame} with 1769 rows and 20 columns.

An object of class \code{data.frame} with 1396 rows and 20 columns.
}
\usage{
size_LGD_2006

size_OR1_1219

size_OR1_1242
}
\description{
Individual size data of all cruises
}
\details{
The condition and unit of each column were listed below.
\itemize{
\item{\code{Cruise}} The cruise during sampling.
\item{\code{Habitat}} Habitat type (Shelf, slope, canyon)
\item{\code{Location}} Geographic region; Pearl river-shelf (PRS) and Gaoping river-shelf {GRS}
\item{\code{Station}} Sampling station.
\item{\code{Deployment}} Number of deployment.
\item{\code{Tube}} Order of tubes.
\item{\code{Section}} sampled section in cm
\item{\code{Taxon}} Recorded grouping taxa of the specimen
\item{\code{Family}} The family of the speciemn
\item{\code{Genus}} The genus of the speciemn
\item{\code{Condition}} The condition of the specimen
\item{\code{L}} maximum body length in mm
\item{\code{W}} maximum body length in mm
\item{\code{a}} deprecated; the half of L
\item{\code{b}} deprecated; the half of W
\item{\code{size}} the volume of the specimen in mm^3
\item{\code{Note}} Comments and further information for the specimen
\item{\code{Type}} The respective geometric shapes for biovolume estimation
\item{\code{C}} The conversion factors for biovolume estimation
\item{\code{WM}} wet mass in mg
}
}
\author{
Yen-Ting Chen \email{r08241220@ntu.edu.tw}
}
\keyword{datasets}
