#' omicviz: Visualization of HOMER Known Motif Discovery Results
#'
#' The omicviz package provides tools to parse and visualize HOMER known
#' motif discovery results. It creates publication-quality ComplexHeatmap
#' plots showing motif rank, transcription factor names, motif logos,
#' significance, and target enrichment.
#'
#' @section Main functions:
#' \describe{
#'   \item{\code{\link{readHomerDir}}}{Parse a HOMER output directory and
#'     return a \code{HomerData} object.}
#'   \item{\code{\link{vizHomerBar}}}{Create a ComplexHeatmap visualization
#'     of known motif enrichment results.}
#'   \item{\code{\link{vizVolcano}}}{Create a volcano plot from DESeq2
#'     differential expression results.}
#' }
#'
#' @section Class:
#' \describe{
#'   \item{\code{\link{HomerData-class}}}{S4 class to store parsed HOMER
#'     known motif results.}
#' }
#'
#' @docType package
#' @name omicviz-package
#' @aliases omicviz
NULL
