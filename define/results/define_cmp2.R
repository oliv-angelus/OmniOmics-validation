suppressMessages(library(DESeq2))
args <- commandArgs(TRUE); tab <- args[1]; src <- args[2]; map <- args[3]
d <- read.delim(tab, check.names=FALSE, quote="")
mp <- read.delim(map); d <- merge(d, mp, by="locus_tag")
cc <- c("CTRL_D1_R1","CTRL_D1_R2","CTRL_D1_R3","PU239_D1_R1","PU239_D1_R2","PU239_D1_R3")
m1 <- rowsum(as.matrix(d[, cc]), d$gene)
s <- read.delim(gzfile(src), check.names=FALSE, row.names=1)
sc <- c("counts.Ec_Con_D1_R1","counts.Ec_Con_D1_R2","counts.Ec_Con_D1_R3","counts.Ec_Pu239_D1_R1","counts.Ec_Pu239_D1_R2","counts.Ec_Pu239_D1_R3")
m2 <- round(as.matrix(s[, sc]))
run <- function(m, keep) {
  m <- m[, keep]; m <- m[rowSums(m) > 0, ]
  cond <- factor(ifelse(grepl("CTRL|Con", colnames(m)), "ctrl", "pu"), levels=c("ctrl","pu"))
  r <- results(DESeq(DESeqDataSetFromMatrix(m, data.frame(cond=cond), ~cond), quiet=TRUE), contrast=c("cond","pu","ctrl"))
  as.data.frame(r)
}
deg <- function(r) rownames(r)[!is.na(r$padj) & r$padj < 0.05 & abs(r$log2FoldChange) > 2]
report <- function(lab, r1, r2) {
  common <- intersect(rownames(r1), rownames(r2)); g1 <- intersect(deg(r1), common); g2 <- intersect(deg(r2), common)
  tp <- length(intersect(g1, g2)); both <- intersect(g1, g2)
  ok <- common[is.finite(r1[common,"log2FoldChange"]) & is.finite(r2[common,"log2FoldChange"])]
  cat(sprintf("== %s\n  genes tested DEFINE %d, deposited %d, shared %d\n  DEGs DEFINE %d, deposited %d (shared genes: %d vs %d)\n  overlap %d; precision %.3f; recall %.3f; Jaccard %.3f; direction %d/%d\n  log2FC Pearson %.3f, Spearman %.3f\n",
    lab, nrow(r1), nrow(r2), length(common), length(deg(r1)), length(deg(r2)), length(g1), length(g2), tp, tp/length(g1), tp/length(g2), tp/length(union(g1,g2)),
    sum(sign(r1[both,"log2FoldChange"])==sign(r2[both,"log2FoldChange"])), length(both),
    cor(r1[ok,"log2FoldChange"], r2[ok,"log2FoldChange"]), cor(r1[ok,"log2FoldChange"], r2[ok,"log2FoldChange"], method="spearman")))
}
report("A: as published (deposited n=3 with duplicated control column; DEFINE n=3 true replicates)", run(m1, 1:6), run(m2, 1:6))
report("B: same design both sides (controls R1+R2, Pu-239 R1-R3)", run(m1, c(1,2,4,5,6)), run(m2, c(1,2,4,5,6)))
