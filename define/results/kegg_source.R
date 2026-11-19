# enrichKEGG (organism eco, BH) on DEGs from the authors' deposited matrix
# (GSE208658_Ec_count_matrix), source criteria |log2FC|>2 & padj<0.05:
# A = as deposited (control R2 == R3, duplicated column), B = controls R1+R2.
suppressMessages({ library(DESeq2); library(clusterProfiler) })
s <- read.delim(gzfile("GSE208658_Ec_count_matrix.txt.gz"), check.names = FALSE, row.names = 1)
n2b <- read.delim("name2b.tsv", header = FALSE, col.names = c("gene","b"))
sc <- c("counts.Ec_Con_D1_R1","counts.Ec_Con_D1_R2","counts.Ec_Con_D1_R3","counts.Ec_Pu239_D1_R1","counts.Ec_Pu239_D1_R2","counts.Ec_Pu239_D1_R3")
m <- round(as.matrix(s[, sc]))
run <- function(keep, lab) {
  x <- m[, keep]; x <- x[rowSums(x) > 0, ]
  cond <- factor(ifelse(grepl("Con", colnames(x)), "ctrl", "pu"), levels = c("ctrl","pu"))
  r <- as.data.frame(results(DESeq(DESeqDataSetFromMatrix(x, data.frame(cond = cond), ~cond), quiet = TRUE), contrast = c("cond","pu","ctrl")))
  r <- r[!is.na(r$padj), ]
  b <- n2b$b[match(rownames(r), n2b$gene)]
  sig <- unique(na.omit(b[r$padj < 0.05 & abs(r$log2FoldChange) > 2])); uni <- unique(na.omit(b))
  k <- as.data.frame(enrichKEGG(sig, organism = "eco", universe = uni, pvalueCutoff = 1, qvalueCutoff = 1))
  cat(sprintf("\n== %s: DEGs %d (b-numbers %d); KEGG BH<0.05: %d\n", lab, sum(r$padj < 0.05 & abs(r$log2FoldChange) > 2), length(sig), sum(k$p.adjust < 0.05)))
  print(k[k$p.adjust < 0.05, c("ID","GeneRatio","p.adjust")], row.names = FALSE)
  cat("-- source terms:\n"); print(k[k$ID %in% c("eco02020","eco00330","eco02010"), c("ID","GeneRatio","p.adjust")], row.names = FALSE)
}
run(1:6, "A deposited as-is (duplicated control column)")
run(c(1,2,4,5,6), "B controls R1+R2 (duplicate removed)")
