#' Read HOMER Known Motif Results Directory
#'
#' Parses a HOMER output directory containing \code{knownResults.txt} and
#' the \code{knownResults/} subdirectory with motif logo images. Returns a
#' \code{HomerData} object.
#'
#' @param homer_dir Character string. Path to the HOMER output directory
#'   (the directory containing \code{knownResults.txt}).
#' @param p_threshold Numeric. Only include motifs with log p-value less than
#'   this threshold (i.e., more significant). Default is 0 (include all).
#' @param top_n Integer or NULL. If specified, only return the top N most
#'   significant motifs. Default is NULL (return all).
#'
#' @return A \code{\link{HomerData}} object containing the parsed results.
#'
#' @details
#' The function expects the HOMER output directory to contain:
#' \itemize{
#'   \item \code{knownResults.txt}: Tab-delimited file with known motif
#'     enrichment statistics.
#'   \item \code{knownResults/}: Subdirectory containing motif logo images
#'     named as \code{known<N>.logo.png} (e.g., \code{known1.logo.png}).
#' }
#'
#' The \code{knownResults.txt} file is expected to have the following columns
#' (tab-separated):
#' \enumerate{
#'   \item Motif Name
#'   \item Consensus
#'   \item P-value
#'   \item Log P-value
#'   \item q-value (Benjamini)
#'   \item Number of Target Sequences with Motif(of total)
#'   \item \% of Target Sequences with Motif
#'   \item Number of Background Sequences with Motif(of total)
#'   \item \% of Background Sequences with Motif
#' }
#'
#' @examples
#' \dontrun{
#' # Read HOMER results from a directory
#' homer_data <- readHomerDir("/path/to/homer/output")
#'
#' # Read only top 20 motifs
#' homer_data <- readHomerDir("/path/to/homer/output", top_n = 20)
#' }
#'
#' @export
readHomerDir <- function(homer_dir, p_threshold = 0, top_n = NULL) {

  # --- Validate inputs ---
  homer_dir <- normalizePath(homer_dir, mustWork = TRUE)

  results_file <- file.path(homer_dir, "knownResults.txt")
  if (!file.exists(results_file)) {
    stop("Cannot find 'knownResults.txt' in: ", homer_dir,
         "\nMake sure this is a valid HOMER output directory.")
  }

  logo_dir <- file.path(homer_dir, "knownResults")
  if (!dir.exists(logo_dir)) {
    stop("Cannot find 'knownResults/' subdirectory in: ", homer_dir,
         "\nMake sure this is a valid HOMER output directory.")
  }

  # --- Parse knownResults.txt ---
  # Read the header line to determine column names
  header_line <- readLines(results_file, n = 1)
  header_fields <- strsplit(header_line, "\t")[[1]]

  # Read the data (skip header)
  raw_data <- read.delim(results_file, header = TRUE, sep = "\t",
                         stringsAsFactors = FALSE, check.names = FALSE,
                         comment.char = "")

  # Standardize column names
  # HOMER knownResults.txt has these columns:
  # 1: Motif Name, 2: Consensus, 3: P-value, 4: Log P-value,
  # 5: q-value (Benjamini), 6: # of Target Sequences with Motif(of <N>),
  # 7: % of Target Sequences with Motif, 8: # of Background Sequences with Motif(of <N>),
  # 9: % of Background Sequences with Motif
  if (ncol(raw_data) < 9) {
    stop("knownResults.txt has fewer than 9 columns. ",
         "Expected HOMER known motif results format.")
  }

  # Extract and rename the key columns
  motif_data <- data.frame(
    rank         = seq_len(nrow(raw_data)),
    motif_name   = .extract_tf_name(raw_data[[1]]),
    motif_full   = raw_data[[1]],
    consensus    = raw_data[[2]],
    p_value      = as.numeric(raw_data[[3]]),
    log_p_value  = as.numeric(raw_data[[4]]),
    fdr          = as.numeric(raw_data[[5]]),
    target_num   = .parse_count_column(raw_data[[6]]),
    target_pct   = .parse_pct_column(raw_data[[7]]),
    bg_num       = .parse_count_column(raw_data[[8]]),
    bg_pct       = .parse_pct_column(raw_data[[9]]),
    stringsAsFactors = FALSE
  )

  # Make log_p_value negative (HOMER stores as negative log p-value)
  # Ensure it's the absolute value for plotting
  motif_data$neg_log_p_value <- abs(motif_data$log_p_value)

  # --- Apply filters ---
  if (p_threshold < 0) {
    motif_data <- motif_data[motif_data$log_p_value <= p_threshold, ]
  }

  if (!is.null(top_n)) {
    top_n <- min(top_n, nrow(motif_data))
    motif_data <- motif_data[seq_len(top_n), ]
  }

  # Reset rank after filtering
  motif_data$rank <- seq_len(nrow(motif_data))

  # --- Locate logo files ---
  # Logo files are named known1.logo.png, known2.logo.png, etc.
  # The original rank (before filtering) determines the file name
  # We use the original row index from raw_data
  original_indices <- as.integer(rownames(motif_data))
  if (any(is.na(original_indices))) {
    # If row names were reset, use the original rank order
    original_indices <- seq_len(nrow(motif_data))
  }

  logo_files <- character(nrow(motif_data))
  for (i in seq_len(nrow(motif_data))) {
    idx <- original_indices[i]
    # Try both .logo.png and .logo.svg
    png_file <- file.path(logo_dir, paste0("known", idx, ".logo.png"))
    svg_file <- file.path(logo_dir, paste0("known", idx, ".logo.svg"))

    if (file.exists(png_file)) {
      logo_files[i] <- png_file
    } else if (file.exists(svg_file)) {
      logo_files[i] <- svg_file
    } else {
      warning(sprintf("Logo file not found for motif rank %d (known%d.logo.png)",
                       i, idx))
      logo_files[i] <- NA_character_
    }
  }

  # Reset rownames
  rownames(motif_data) <- NULL

  # --- Create and return HomerData object ---
  homer_obj <- HomerData(
    motif_data = motif_data,
    logo_files = logo_files,
    homer_dir  = homer_dir
  )

  message(sprintf("Successfully parsed %d known motifs from: %s",
                   nrow(motif_data), homer_dir))

  return(homer_obj)
}


# ---- Internal helper functions ----

#' Extract transcription factor name from HOMER motif name
#'
#' HOMER motif names have the format:
#' "TF_Name(Family)/Cell-ChIP-Seq(Accession)/homer" or similar.
#' This function extracts just the TF name (before the first parenthesis).
#'
#' @param motif_names Character vector of HOMER motif names.
#' @return Character vector of TF names.
#' @keywords internal
.extract_tf_name <- function(motif_names) {
  # Extract text before the first "(" or "/" 
  tf_names <- sub("\\(.*", "", motif_names)
  tf_names <- trimws(tf_names)
  return(tf_names)
}


#' Parse count column from HOMER results
#'
#' HOMER count columns may contain values like "123.0" or "123".
#'
#' @param x Character vector of count values.
#' @return Numeric vector.
#' @keywords internal
.parse_count_column <- function(x) {
  as.numeric(x)
}


#' Parse percentage column from HOMER results
#'
#' HOMER percentage columns contain values like "12.34%" or "12.34".
#'
#' @param x Character vector of percentage values.
#' @return Numeric vector of percentages (without the % sign).
#' @keywords internal
.parse_pct_column <- function(x) {
  as.numeric(gsub("%", "", x))
}
