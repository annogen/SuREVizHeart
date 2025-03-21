# Start with the Miniconda3 image
# Fast and small builds of conda-based environments in containers using micromamba.
FROM mambaorg/micromamba:0.25.0

# Set the working directory
WORKDIR /shiny-server

# Create the mamba environment and install packages
RUN micromamba create -n sureviz -c conda-forge -c bioconda \
    r-base r-data.table r-dbi r-dt r-formattable r-ggplot2 r-ggseqlogo \
    bioconductor-genomicranges r-gridextra r-here r-kableextra bioconductor-memes r-optparse \
    r-patchwork r-pheatmap r-plotly r-rcolorbrewer r-rsqlite r-signac \
    r-shiny r-shinyfiles r-shinywidgets r-shinyalert r-shinycssloaders \
    r-shinydashboard r-shinyjs r-tidyr bioconductor-universalmotif r-zip \
    bioconductor-bsgenome.hsapiens.ucsc.hg38 bioconductor-rtracklayer r-bslib

# Initialize the micromamba shell for bash
SHELL ["/bin/bash", "-c"]

# Copy the rest of your Shiny app files
COPY . /shiny-server/SuREViz           

# Expose the Shiny app port
EXPOSE 3838

# Run the Shiny app with environment activation and list files with R
CMD ["bash", "-c", "eval \"$(micromamba shell hook --shell=bash)\" && micromamba activate sureviz && shiny::runApp('/shiny-server/SuREViz/app.R', host = '0.0.0.0', port = 3838)"]