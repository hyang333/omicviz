\name{readHomerDir}
\alias{readHomerDir}
\title{Read HOMER Known Motif Results Directory}
\description{
Parses a HOMER output directory containing \code{knownResults.txt} and the
\code{knownResults/} subdirectory with motif logo images. Returns a
\code{\link{HomerData-class}} object.
}
\usage{
readHomerDir(homer_dir, p_threshold = 0, top_n = NULL)
}
\arguments{
  \item{homer_dir}{Character string. Path to the HOMER output directory (the
    directory containing \code{knownResults.txt}).}
  \item{p_threshold}{Numeric. Only include motifs with log p-value less than
    this threshold (i.e., more significant). Default is 0 (include all).}
  \item{top_n}{Integer or NULL. If specified, only return the top N most
    significant motifs. Default is NULL (return all).}
}
\value{
A \code{\link{HomerData-class}} object containing the parsed results.
}
\details{
The function expects the HOMER output directory to contain:
\itemize{
  \item \code{knownResults.txt}: Tab-delimited file with known motif enrichment
    statistics.
  \item \code{knownResults/}: Subdirectory containing motif logo images named as
    \code{known<N>.logo.png} (e.g., \code{known1.logo.png}).
}

The \code{knownResults.txt} file is expected to have the following columns
(tab-separated):
\enumerate{
  \item Motif Name
  \item Consensus
  \item P-value
  \item Log P-value
  \item q-value (Benjamini)
  \item Number of Target Sequences with Motif
  \item Percent of Target Sequences with Motif
  \item Number of Background Sequences with Motif
  \item Percent of Background Sequences with Motif
}
}
\seealso{
  \code{\link{HomerData-class}}, \code{\link{vizHomerBar}}
}
\examples{
\dontrun{
# Read HOMER results from a directory
homer_data <- readHomerDir("/path/to/homer/output")

# Read only top 20 motifs
homer_data <- readHomerDir("/path/to/homer/output", top_n = 20)
}
}
