#' @title Combine arm and disc measurements of ophiuroids
#' @description Note that this function only works under my measure
#'              protocol for ophiuroids. If you use different measurement protocols
#'              while using this function, dubious results might appear. See
#'              example for more insight.
#'
#' @param data A long format data that had their biovolume stored in the column "Size".
#' @param protocol_ophiuroid Currently have two options:.
#' \itemize{
#'   \item \code{all_arms}: calculate the biovolume of one ophiuroid by simply add all the arms and
#'                   and their respective disc.
#'   \item \code{longest_arms} : calculate the biovolume of one ophiuroid by seeking the longest arm
#'                        that is still attached to the disc and assume all arms are of the
#'                        same length as the longest arms.
#'   }
#' @param grouping_variables A character vector of the subset of column names. The variables
#'                           should at least include the dates, stations, and replicates to
#'                           prevent individuals across different samples from being added
#'                           together.
#'
#' @return The modified input data with the size of the ophiuroids manipulated
#' @export
#'
#' @examples
#' a <- data.frame(
#'   Taxon = rep("Ophiuroidea", 6),
#'   Size = runif(6, min = 1, max = 5),
#'   Note = c("Dics-1", rep("Arm-1", 4), "Arm")
#' )
#' define_ophiuroid_size(data = a, protocol = "all_arms")
#' define_ophiuroid_size(data = a, protocol = "longest_arm")
define_ophiuroid_size <- function(data,
                                  protocol_ophiuroid,
                                  grouping_variables) {
  oph <-
    data %>%
    filter(Taxon == "Ophiuroidea")

  # exract oph and assign body parts and individual number tags
  oph_split <-
    oph %>%
    mutate(
      Note = gsub("-.*", "", oph$Note), # body parts
      ind = gsub(".*-", "", oph$Note)
    ) # individual tags

  if (protocol_ophiuroid == "all_arms") {

    # summation
    oph_sum_group <- c(grouping_variables, "Taxon", "ind")
    oph_sum <-
      oph_split %>%
      mutate(Type = NA, L = NA, W = NA) %>%
      group_by(across(all_of(oph_sum_group))) %>%
      # think about this part
      summarise(Size = sum(Size)) %>%
      ungroup()

    # remove redundant observations
    oph_sum_cleaned <-
      oph_sum %>%
      filter(!ind %in% c("Arm", "Disc")) %>%
      mutate(Condition = "C", Method = "Coumpound")

    oph_sum_cleaned$ind <- NULL

    result <- full_join(data[data$Taxon != "Ophiuroidea", ], oph_sum_cleaned)
    return(result)
  } else if (protocol_ophiuroid == "longest_arm") {

    # identify the longest arm
    oph_max_size_group <- c(grouping_variables, "Taxon", "Note", "ind")
    oph_max_size <-
      oph_split %>%
      mutate(Type = NA, L = NA, W = NA) %>%
      # removing redundant information
      filter(!ind %in% c("Arm", "Disc")) %>%
      group_by(across(all_of(oph_max_size_group))) %>%
      # group
      filter(Size == max(Size)) %>%
      # find largest sizes with respect to the arms and discs
      distinct() %>%
      # drop identical values
      mutate(Size = if_else(Note == "Arm", Size * 5, Size)) %>%
      # size of arm * 5
      ungroup()

    oph_max_size_sum_group <- c(grouping_variables, "Taxon", "ind")
    oph_max_size_sum <-
      oph_max_size %>%
      group_by(across(all_of(oph_max_size_sum_group))) %>%
      # group
      summarise(Size = sum(Size)) %>%
      mutate(Method = "Compound", Condition = "C")

    oph_max_size_sum$ind <- NULL

    result <- full_join(data[data$Taxon != "Ophiuroidea", ], oph_max_size_sum)
    return(result)
  } else {
    message("wrong protocol")
    stop()
  }
}
