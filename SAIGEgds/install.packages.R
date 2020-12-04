#############################################################
## Install packages
##
## c.a.warmerdam@umcg.nl - December 2020
#############################################################

library <- Sys.getenv("R_LIBS")

if (!file.exists(library)) {
    dir.create(library)
}

.libPaths(library)

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos="https://cloud.r-project.org/")

if (!requireNamespace("SNPRelate", quietly = TRUE))
    BiocManager::install("SNPRelate")

if (!requireNamespace("GWASTools", quietly = TRUE))
    BiocManager::install("GWASTools")

if (!requireNamespace("SAIGEgds", quietly = TRUE))
    BiocManager::install("SAIGEgds")

if (!requireNamespace("data.table", quietly = TRUE))
    install.packages("data.table", repos="https://cloud.r-project.org/")

if (!requireNamespace("optparse", quietly = TRUE))
    install.packages("optparse", repos="https://cloud.r-project.org/")
