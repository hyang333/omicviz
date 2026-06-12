# PubOmix: Elegance and Simplicity in Multi-Omics Visualization (in development)

**PubOmix** is a comprehensive and extremely user-friendly R package designed to bridge the gap between complex multi-omics data and stunning, publication-quality figures. 

Whether you are working with transcriptomics, genomics, or epigenomics, **PubOmix** eliminates the pain of endless code-tweaking. It empowers researchers to transform raw analytical results into beautiful, journal-ready visualizations with just a few lines of code. 

If you have ever felt frustrated by the thought, *"I have the data, but I don't know how to draw a good plot,"* PubOmix is built exactly for you.

---

## ✨ Key Features

* **🧬 Comprehensive Multi-Omics Support** Seamlessly process, analyze, and visualize diverse omics datasets, including RNA-seq (transcriptomics), WGS/WES (genomics), and methylation/ChIP-seq (epigenomics).
* **🎨 Publication-Ready by Default** Say goodbye to complex `ggplot2` parameter adjustments. PubOmix comes with meticulously crafted built-in themes and color palettes tailored to meet the strict aesthetic standards of top-tier journals (e.g., *Nature*, *Science*, *Cell*).
* **🚀 "Zero-Friction" User Experience** Designed with beginners and clinicians in mind. The API is incredibly straightforward—achieve complex multi-omics integration and visualization with "one-click" style functions.
* **📊 Rich Visualization Gallery** Effortlessly generate high-quality heatmaps, volcano plots, PCA/UMAP scatter plots, violin plots, and multi-omics correlation networks out of the box.

---

## 🎯 Why Choose PubOmix?

In modern bioinformatics, the hardest part often isn't running the pipeline—it's crafting the perfect figure for your manuscript. **PubOmix** handles the heavy lifting of data reshaping and graphical mapping behind the scenes, allowing you to focus purely on the biology. You bring the data; we provide the aesthetics.

---

## 📦 Installation

You can install the development version of PubOmix from GitHub with:

```R
# install.packages("devtools")
remotes::install_github("hyang333/PubOmix")



## Usage

```r
library(PubOmix)

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

## Usage: Volcano Plots

The `vizVolcano()` function generates publication-quality volcano plots from DESeq2 results. It features 5-category color mapping, zone background shading, configurable borders, and automated top-n gene labeling.

```r
# 1. Read DESeq2 results (must contain log2FoldChange and padj columns)
# If labelling genes, also ensure the gene symbol column is present.
res <- read.csv("deseq2_results.csv")

# 2. Basic volcano plot with default 5-category coloring and zone shading
vizVolcano(res, lfc_threshold = 1, padj_cutoff = 0.05)

# 3. Customize colors, labels, and borders
vizVolcano(res, 
           lfc_threshold = 1, 
           padj_cutoff = 0.05,
           top_n_labels = 10,       # Label the top 10 most significant genes
           label_arrows = TRUE,     # Use arrows for labels
           full_border = FALSE,     # Use half-open L-shaped border
           shade_alpha = 0.05,      # Adjust zone shading transparency
           col_up_high = "#D6604D", 
           col_down_high = "#4393C3")
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
