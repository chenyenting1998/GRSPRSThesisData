#' @title calculate biovolume of each individual
#' @description Calculates biovolume of the individuals with its assigned methods.
#' @param data A long format data with Length (L), Width (W), and Method (Method) as their variables.
#'
#' @return The same data frame except that a new column called "Size" contains the volume data.
#' @export
#' @details Note that this function will first remove all the entris in the `Size` column.
#'          Another thing is that this function is not flexible enough. Further revision is needed.
#' @examples
#' a <- data.frame(
#'   L = c(10, 5, 6, 78, 1, 6),
#'   W = c(0.1, 3, 4, 1, 2, 3),
#'   Method = c("LWR", "LWR", "Cylinder", "Cylinder", "Cone", "Elliposid"),
#'   C = c(0.53, 0.45, NA, NA, NA, NA)
#' )
#' calculate_biovolume(a)
calculate_biovolume <- function(data) {

  # initial if_else control flow --------------------------------------------
  if (is.character(data)) {
    if (grepl(".xlsx", data)) { # data have ".xlsx"
      data <- read_xlsx(data) %>% data.frame()
    }
    if (grepl(".csv", data)) { # data have ".xlsx"
      data <- read.csv(data) %>% data.frame()
    }
  } else if (is.object(data)) { # data = object
    data <- data.frame(data)
  } else {
    message("data is not a .csv file, a .xlsx file, or an object")
    stop()
  }

  # Add a type column if such column does not exist
  if (!("Method" %in% colnames(data))) {
    message("data lacks a [Method] column")
    stop()
  }

  if (!"L" %in% colnames(data) | !"W" %in% colnames(data)) {
    message("Misses L and/or W for biovolume calculation")
    stop()
  }

  # calculate biovolume -----------------------------------------------------
  data <-
    data %>%
    mutate(Size = NA) # remove previous calculations

  # LWR
  data[data$Method == "LWR", ] <-
    data %>%
    filter(Method == "LWR") %>%
    mutate(Size = LWR(L, W, C))

  # cylinder
  data[data$Method == "Cylinder", ] <-
    data %>%
    filter(Method == "Cylinder") %>%
    mutate(Size = Cylinder(L, W))

  # cone
  data[data$Method == "Cone", ] <-
    data %>%
    filter(Method == "Cone") %>%
    mutate(Size = Cone(L, W))

  # ellipsoid
  data[data$Method == "Ellipsoid", ] <-
    data %>%
    filter(Method == "Ellipsoid") %>%
    mutate(Size = Ellipsoid(L, W))

  data
}
