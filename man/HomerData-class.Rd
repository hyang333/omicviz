\name{HomerData-class}
\alias{HomerData-class}
\alias{HomerData}
\title{HomerData Class}
\description{
An S4 class to store parsed HOMER known motif discovery results.
}
\section{Slots}{
  \describe{
    \item{\code{motif_data}}{A \code{data.frame} containing the parsed known motif
      results with columns: rank, motif_name, motif_full, consensus, p_value,
      log_p_value, fdr, target_num, target_pct, bg_num, bg_pct,
      neg_log_p_value.}
    \item{\code{logo_files}}{A character vector of file paths to motif logo PNG
      images, ordered by rank.}
    \item{\code{homer_dir}}{A character string of the original HOMER output
      directory path.}
  }
}
\section{Constructor}{
  \code{HomerData(motif_data, logo_files, homer_dir)} creates a new
  \code{HomerData} object.

  \describe{
    \item{motif_data}{A data.frame of parsed HOMER results.}
    \item{logo_files}{A character vector of paths to motif logo PNG files.}
    \item{homer_dir}{The path to the HOMER output directory.}
  }
}
\seealso{
  \code{\link{readHomerDir}}, \code{\link{vizHomerBar}}
}
\examples{
\dontrun{
homer_data <- readHomerDir("/path/to/homer/output")
homer_data
}
}
