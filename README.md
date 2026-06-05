# homerviz

Visualization of HOMER Known Motif Discovery Results.

## Installation

```r
# Install dependencies from Bioconductor
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("ComplexHeatmap")

# Install homerviz from local source
install.packages("/path/to/homerviz", repos = NULL, type = "source")

# Or using devtools
devtools::install_local("/path/to/homerviz")
```

## Usage

```r
library(homerviz)

# 1. Read HOMER known motif results
homer_data <- readHomerDir("/path/to/homer/output")

# 2. Visualize top 20 motifs
vizHomerBar(homer_data, top_n = 20)

# 3. Customize the plot
vizHomerBar(homer_data,
            top_n = 15,
            pvalue_col = "#4393C3",
            target_col = "#D6604D",
            title = "My Motif Enrichment")
```

## Expected HOMER Directory Structure

The HOMER output directory should contain:

```
homer_output/
├── knownResults.txt       # Tab-delimited known motif results
└── knownResults/          # Motif logo images
    ├── known1.logo.png
    ├── known2.logo.png
    ├── known3.logo.png
    └── ...
```

## Output

The `vizHomerBar()` function produces a ComplexHeatmap plot with 5 columns:

| Column | Description |
|--------|-------------|
| Rank | Numerical rank of motif significance |
| TF | Transcription factor name |
| Motif | Sequence logo image |
| -log(Pvalue) | Horizontal bar plot of significance |
| % Targets | Horizontal bar plot of target enrichment |

## Dependencies

- R (>= 4.0)
- [ComplexHeatmap](https://bioconductor.org/packages/ComplexHeatmap/) (Bioconductor)
- grid
- png
- circlize
