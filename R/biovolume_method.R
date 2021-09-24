#' @title Biovolume method
#' @description This data documents the biovolume estimation methods
#'              respective to each taxon.
#'  \itemize{
#'     \item \code{Taxon} Taxa in the recorded form.
#'     \item \code{Note} Parsing the taxa into different estimation methods.
#'     \item \code{Method} The methods for biovolume methods. Currently
#'                         allowing cone, cylinder, ellipsoid, and LWR.
#'     \item \code{C} The conversion factors for LWR.
#'     \item \code{C_origin} The origin of conversion factors for taxa
#'                           without published factors.
#'     \item \code{Comment} Comment about the whole row.
#'     }
#'
"biovolume_method"
