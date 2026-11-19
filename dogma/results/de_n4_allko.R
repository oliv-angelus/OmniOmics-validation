#!/usr/bin/env Rscript
# DOGMA validation, sensitivity check: the full KEGG-ortholog x sample matrix
# (every KO eggNOG assigned, Salmon NumReads summed per KO within each
# sample), DESeq2 with its default median-of-ratios size factors -- the
# source study's own set-up (Chuckran et al. 2021: KO read counts, DESeq2,
# >= 60 reads in total, FDR < 0.01).
suppressMessages(library(DESeq2))
base <- commandArgs(TRUE)[1]
samples <- c("C0R1","C0R2","C0R3","C0R4","C8R1","C8R2","C8R3","C8R4")
condition <- factor(rep(c("C0","C8"), each = 4), levels = c("C0","C8"))
strip <- function(x) sub("\\.p[0-9]+$", "", x)
cols <- list()
for (s in samples) {
  q <- read.delim(file.path(base, "quant", paste0(s, "_quant.sf")))
  reads <- setNames(q$NumReads, q$Name)
  e <- read.delim(file.path(base, "eggnog", paste0(s, "_eggnog.tsv")), header = FALSE,
                  comment.char = "#", quote = "", na.strings = "-", stringsAsFactors = FALSE)
  e <- e[!is.na(e[[12]]), c(1, 12)]
  kl <- strsplit(gsub("ko:", "", e[[2]]), ",")
  d <- unique(data.frame(t = strip(rep(e[[1]], lengths(kl))), ko = unlist(kl)))
  d$r <- reads[d$t]; d$r[is.na(d$r)] <- 0
  cols[[s]] <- tapply(d$r, d$ko, sum)
}
kos <- sort(unique(unlist(lapply(cols, names))))
m <- sapply(samples, function(s) { v <- cols[[s]][kos]; v[is.na(v)] <- 0; v })
rownames(m) <- kos
m <- round(m); storage.mode(m) <- "integer"
m <- m[rowSums(m) >= 60, ]
cat(nrow(m), "KOs with >= 60 reads\n")
# Size factors from the KO matrix alone; the three NCycDB pathway categories
# (pooled gene families, Tu et al. 2019) are then tested with those factors.
sf <- sizeFactors(estimateSizeFactors(DESeqDataSetFromMatrix(m, data.frame(condition, row.names = samples), ~condition)))
fam <- list("nitrification (all)" = c("amoA_A","amoA_B","amoB_A","amoB_B","amoC_A","amoC_B","hao","nxrB"),
            "denitrification (most)" = c("narG","narH","narI","narJ","narY","narZ","napA","napB","napC","nirK","nirS","norB","norC","nosZ"),
            "assimilatory nitrate reduction" = c("nasA","nasB","narB","NR","nirA"))
nc <- sapply(samples, function(s) {
  q <- read.delim(file.path(base, "quant", paste0(s, "_quant.sf"))); reads <- setNames(q$NumReads, q$Name)
  n <- read.delim(file.path(base, "ncycdb", paste0(s, "_ncycdb.tsv")), header = FALSE, stringsAsFactors = FALSE)
  sapply(fam, function(f) { t <- unique(strip(n[[1]][n[[7]] %in% f])); v <- reads[t]; sum(v[!is.na(v)]) })
})
nc <- round(nc); storage.mode(nc) <- "integer"
m <- rbind(m, nc)
dds <- DESeqDataSetFromMatrix(m, data.frame(condition, row.names = samples), ~condition)
sizeFactors(dds) <- sf
dds <- DESeq(dds, quiet = TRUE)
r <- as.data.frame(results(dds, contrast = c("condition","C8","C0"), alpha = 0.01))
tg <- c("nitrification (all)"="nitrification (all)","denitrification (most)"="denitrification (most)","assimilatory nitrate reduction"="assimilatory nitrate reduction",K03320="amtB",K01915="glnA",K00265="gltB",K00266="gltD",K00284="gltS",K00990="glnD",
        K04751="glnB",K04752="glnK",K07712="NtrC-family",K10914="crp",K03092="rpoN")
out <- cbind(gene = tg[rownames(r)[rownames(r) %in% names(tg)]], r[rownames(r) %in% names(tg), c("baseMean","log2FoldChange","lfcSE","padj")])
print(out, digits = 3)
write.csv(r, file.path(base, "deseq2_results_allko.csv"))
write.csv(m[rownames(m) %in% names(tg), ], file.path(base, "target_counts_allko.csv"))
print(sf)
