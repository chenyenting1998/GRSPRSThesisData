#' @title  Assign volume estimation method in to each individuals
#'
#' @description This function adds the following two columns to your original data frame:
#'      \itemize{
#'      \item \code{Method} : This column stores the method for biomass calculation.
#'      \item \code{C} : This column stores the conversion factors for individuals that uses
#'                       length-weight relationships for biomass calculation.
#'      }
#'
#' @param data The data that records observations of each individuals size measurements
#'             with at least the following columns: "Taxon"
#' @param method_file The file that contains the pairwise biovolume estimation method.
#'                    Note that the method file has a specific format to follow. See
#'                    \code{biovolume method} for more information.
#'                    If NULL, the method file will use the default "biovolume_method"
#'                    data.
#' @return
#' @export
#'
#' @examples
#' # the default estimation method for each available taxon.
#' biovolume_method
#' a <- data.frame(Taxon = c("Polychaeta", "Oligochaeta", "Sipuncula", "Not in the column"))
#' assign_method(a)
assign_method <- function(data, method_file = NULL) {

  # initial if_else control flow --------------------------------------------
  if (is.character(data)) {
    if (grepl(".xlsx", data)) { # measurement_file have ".xlsx"
      data <- read_xlsx(data) %>% data.frame()
    }
    if (grepl(".csv", data)) { # measurement_file have ".xlsx"
      data <- read.csv(data) %>% data.frame()
    }
  } else if (is.object(data)) { # measurement_file = object
    data <- data.frame(data)
  } else {
    stop("Neither measurement_file nor object")
  }

  # assign method -----------------------------------------------------------
  if (is.null(method_file)) {
    method_file <- biovolume_method
  } else if (is.object(method_file)) {
    method_file <- method_file
  } else {
    stop("method file is neither NULL or an object")
  }

  # separate simple cases and exceptional cases
  simple <- method_file[is.na(method_file$Note), ] %>% select(Taxon, Method, C)
  exceptional <- method_file[!is.na(method_file$Note), ] %>% select(Taxon, Note, Method, C)

  # merging data
  result_simple <-
    data %>%
    filter(Taxon %in% simple$Taxon) %>%
    left_join(simple)

  result_exceptional <-
    data %>%
    filter(Taxon %in% exceptional$Taxon) %>%
    left_join(exceptional)

  # assign conversion factors for organisms that uses LWR
  output <- full_join(result_exceptional, result_simple)

  if (any(is.na(output$Method))) {
    cat("The following observations do not have methods", "\n",
        output[is.na(output$Method),])
    return(output)
  } else {
    output
  }
}
