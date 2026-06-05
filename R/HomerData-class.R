#' HomerData Class
#'
#' An S4 class to store parsed HOMER known motif discovery results.
#'
#' @slot motif_data A data.frame containing the parsed known motif results with
#'   columns: rank, motif_name, consensus, p_value, log_p_value, fdr,
#'   target_num, target_pct, bg_num, bg_pct.
#' @slot logo_files A character vector of file paths to motif logo PNG images,
#'   ordered by rank.
#' @slot homer_dir A character string of the original HOMER output directory.
#'
#' @export
#' @importFrom methods setClass new validObject
setClass("HomerData",
  representation(
    motif_data = "data.frame",
    logo_files = "character",
    homer_dir  = "character"
  ),
  validity = function(object) {
    errors <- character()

    # Check motif_data is not empty
    if (nrow(object@motif_data) == 0) {
      errors <- c(errors, "motif_data must have at least one row")
    }

    # Check required columns exist
    required_cols <- c("rank", "motif_name", "consensus", "log_p_value",
                       "target_pct")
    missing_cols <- setdiff(required_cols, colnames(object@motif_data))
    if (length(missing_cols) > 0) {
      errors <- c(errors,
        paste("motif_data is missing columns:", paste(missing_cols, collapse = ", ")))
    }

    # Check logo_files length matches motif_data rows
    if (length(object@logo_files) != nrow(object@motif_data)) {
      errors <- c(errors,
        "Length of logo_files must match the number of rows in motif_data")
    }

    if (length(errors) == 0) TRUE else errors
  }
)


#' Constructor for HomerData
#'
#' @param motif_data A data.frame of parsed HOMER results.
#' @param logo_files A character vector of paths to motif logo PNG files.
#' @param homer_dir The path to the HOMER output directory.
#'
#' @return A \code{HomerData} object.
#' @export
HomerData <- function(motif_data, logo_files, homer_dir) {
  new("HomerData",
    motif_data = motif_data,
    logo_files = logo_files,
    homer_dir  = homer_dir
  )
}


#' Show method for HomerData
#'
#' @param object A HomerData object.
#' @importFrom methods setMethod
setMethod("show", "HomerData", function(object) {
  cat("HomerData object\n")
  cat("  HOMER directory:", object@homer_dir, "\n")
  cat("  Number of motifs:", nrow(object@motif_data), "\n")
  cat("  Top motifs:\n")
  n_show <- min(5, nrow(object@motif_data))
  for (i in seq_len(n_show)) {
    cat(sprintf("    %2d. %s (logP = %.1f, target = %.1f%%)\n",
      object@motif_data$rank[i],
      object@motif_data$motif_name[i],
      object@motif_data$log_p_value[i],
      object@motif_data$target_pct[i]
    ))
  }
  if (nrow(object@motif_data) > 5) {
    cat(sprintf("    ... and %d more motifs\n", nrow(object@motif_data) - 5))
  }
})
