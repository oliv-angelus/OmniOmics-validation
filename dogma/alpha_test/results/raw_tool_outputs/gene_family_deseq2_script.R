#!/usr/bin/env Rscript
# DOGMA validation: gene-family-level differential expression, C8 vs C0.
#
# Each sample was assembled independently (per-sample rnaSPAdes/MEGAHIT/
# Trinity ensemble -> transcript_set dedup), so transcript IDs are NOT
# shared across samples. This mirrors Chuckran et al. 2021's own approach
# (and standard practice for de novo metatranscriptome DE, e.g. Trinity's
# own align_and_estimate_abundance.pl + DESeq2 workflow): within each
# sample, sum Salmon's per-transcript NumReads onto the gene family/ORF
# annotation (eggNOG Preferred_name for GS-GOGAT/regulatory genes,
# NCycDB gene family for nitrification/denitrification/assimilatory
# genes), producing one integer count per gene-family per sample, then
# run DESeq2 on the resulting gene-family x sample count matrix.
#
# Library-size normalization uses each sample's FULL transcript-level
# NumReads total (all ~hundreds of thousands of transcripts), not just
# the handful of target genes -- avoids DESeq2's median-of-ratios method
# misbehaving on a count matrix with only ~20 rows.

suppressMessages({
  library(DESeq2)
})

base <- "/tmp/claude-1002/-home-angelo-Documentos-OmniOmics/fb5be6b7-b3f3-4018-940c-ad3408ba1352/scratchpad/dogma_de"
samples <- c("C0R1", "C0R2", "C8R1", "C8R2")
condition <- c("C0", "C0", "C8", "C8")

# Target genes (eggNOG Preferred_name) from Chuckran et al. 2021's own
# named gene list (ground_truth/chuckran2021_expected_direction_of_change.md)
eggnog_targets <- c(
  "amtB", "glnA", "gltB", "gltD", "gltS",
  "glnD", "glnB", "glnK", "ntrC", "glnG",
  "crp", "rpoN"
)

# NCycDB gene families, bucketed per NCycDB's own categorization
# (Tu et al. 2019, Bioinformatics, doi:10.1093/bioinformatics/bty741)
nitrification_genes <- c("amoA_A","amoA_B","amoB_A","amoB_B","amoC_A","amoC_B","hao","nxrB")
denitrification_genes <- c("narG","narH","narI","narJ","narY","narZ",
                            "napA","napB","napC",
                            "nirK","nirS","norB","norC","nosZ")
assim_nitrate_genes <- c("nasA","nasB","narB","NR","nirA")

full_libsize <- numeric(length(samples))
names(full_libsize) <- samples

# per-sample named numeric vectors of gene-family counts
per_sample_counts <- list()

strip_orf_suffix <- function(x) sub("\\.p[0-9]+$", "", x)

for (i in seq_along(samples)) {
  s <- samples[i]
  message("Processing ", s, " ...")

  quant <- read.delim(file.path(base, "quant", paste0(s, "_quant.sf")),
                       header = TRUE, stringsAsFactors = FALSE)
  full_libsize[s] <- sum(quant$NumReads)
  reads_by_transcript <- setNames(quant$NumReads, quant$Name)

  # --- eggNOG ---
  egg <- read.delim(file.path(base, "eggnog", paste0(s, "_eggnog.tsv")),
                     header = FALSE, comment.char = "#", stringsAsFactors = FALSE,
                     quote = "", na.strings = "-")
  # columns: query, seed_ortholog, evalue, score, eggNOG_OGs, max_annot_lvl,
  # COG_category, Description, Preferred_name, GOs, EC, KEGG_ko, ...
  colnames(egg)[1] <- "query"
  colnames(egg)[9] <- "Preferred_name"
  egg <- egg[!is.na(egg$Preferred_name) & egg$Preferred_name %in% eggnog_targets, c("query", "Preferred_name")]
  egg$transcript <- strip_orf_suffix(egg$query)
  # collapse ntrC/glnG into one "NtrC-family" label
  egg$gene <- ifelse(egg$Preferred_name %in% c("ntrC", "glnG"), "NtrC-family", egg$Preferred_name)

  # --- NCycDB ---
  ncyc <- read.delim(file.path(base, "ncycdb", paste0(s, "_ncycdb.tsv")),
                      header = FALSE, stringsAsFactors = FALSE,
                      col.names = c("query","subject","pident","length","evalue","bitscore","gene_family"))
  ncyc <- ncyc[!is.na(ncyc$gene_family) & ncyc$gene_family != "NA", ]
  ncyc$transcript <- strip_orf_suffix(ncyc$query)
  ncyc$gene <- NA_character_
  ncyc$gene[ncyc$gene_family %in% nitrification_genes] <- "nitrification (all)"
  ncyc$gene[ncyc$gene_family %in% denitrification_genes] <- "denitrification (most)"
  ncyc$gene[ncyc$gene_family %in% assim_nitrate_genes] <- "assimilatory nitrate reduction"
  ncyc <- ncyc[!is.na(ncyc$gene), c("transcript", "gene")]

  combined <- rbind(egg[, c("transcript", "gene")], ncyc)
  combined$reads <- reads_by_transcript[combined$transcript]
  combined$reads[is.na(combined$reads)] <- 0

  gene_counts <- tapply(combined$reads, combined$gene, sum)
  per_sample_counts[[s]] <- gene_counts
}

all_genes <- sort(unique(unlist(lapply(per_sample_counts, names))))
count_mat <- matrix(0, nrow = length(all_genes), ncol = length(samples),
                     dimnames = list(all_genes, samples))
for (s in samples) {
  gc <- per_sample_counts[[s]]
  count_mat[names(gc), s] <- gc
}
count_mat_int <- round(count_mat)
storage.mode(count_mat_int) <- "integer"

cat("\n=== Gene-family raw count matrix (rounded) ===\n")
print(count_mat_int)
cat("\n=== Full per-sample transcript-level library size (all transcripts) ===\n")
print(full_libsize)
write.csv(count_mat_int, file.path(base, "gene_family_count_matrix.csv"))

coldata <- data.frame(condition = factor(condition, levels = c("C0", "C8")),
                       row.names = samples)

dds <- DESeqDataSetFromMatrix(countData = count_mat_int, colData = coldata, design = ~condition)
# Use full transcript-level sequencing depth as the normalization factor
# (not the median-ratio method on this tiny ~20-gene matrix)
libsize_norm <- full_libsize / exp(mean(log(full_libsize)))
normFactors <- matrix(rep(libsize_norm, each = nrow(count_mat_int)),
                       nrow = nrow(count_mat_int), dimnames = dimnames(count_mat_int))
normalizationFactors(dds) <- normFactors

dds <- DESeq(dds, fitType = "mean")
res <- results(dds, contrast = c("condition", "C8", "C0"))
res_df <- as.data.frame(res)
res_df$gene <- rownames(res_df)

cat("\n=== DESeq2 results (C8 vs C0) ===\n")
print(res_df[, c("gene", "baseMean", "log2FoldChange", "pvalue", "padj")])

write.csv(res_df, file.path(base, "deseq2_results.csv"), row.names = FALSE)
cat("\nWrote", file.path(base, "deseq2_results.csv"), "\n")
