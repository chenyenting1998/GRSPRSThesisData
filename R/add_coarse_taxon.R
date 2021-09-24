#' Add coarse taxon for complex taxon names
#'
#' @param data A data frame with a column named \code{Taxon}
#' @param match_file A data.frame with at least two columns. One of the columns
#'                   must be named \code{Taxon}; the name of the other column is not restricted.
#' @param output  The name of the output column.
#'
#' @return
#' @export
#'
#' @examples
#' a <- data.frame(Taxon = c("Polychaeta", "Nematoda", "Hydrozoa"))
#' add_coarse_taxon(data = a, match_file = NULL, output = "Phylum")
add_coarse_taxon <- function(data, match_file = NULL, output = "Phylum") {

  # if match_file left NULL, match_file = default
  if (is.null(match_file)) {
    match_file <- coarse_taxon
  }

  if(!is.null(match_file) & is.object(match_file)) {
    match_file <- match_file
  } else {
    stop("match_file is not an object.
         Remember the match_file needs to have at least two columns:
         the `Taxon` column (name fixed) and the output column (name decided by the user)")
  }

  #
  if (length(output) > 1) {
    stop("output lenght should be 1")
  } else if (!is.character(output)) {
    stop("output should be a character string")
  }
  if (output %in% colnames(match_file)) {

    # extract Taxon paired with output names
    extract <- data.frame(Taxon = match_file$Taxon, match_file[,colnames(match_file) == output])

    # compare the taxon column of data with that of extract (returns a numeric vector)
    comparing <- match(data$Taxon, extract$Taxon)

    # use the numeric vector to return new names
    result <- extract[comparing, 2]
  } else {
      stop('The Method is not in the match_file')
  }
  data$output <- result
  colnames(data)[ncol(data)] <- output

  data
}
