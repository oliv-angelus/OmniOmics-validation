# Same contrast as define_ora.R, but with clusterProfiler::enrichKEGG against
# KEGG's own E. coli K-12 MG1655 pathways (organism "eco", b-number IDs), the
# method of Wintenberg et al. 2023 Fig. 4. DEFINE loci -> RefSeq gene name by
# coordinate overlap (locus2gene.tsv) -> b-number (RefSeq GFF locus_tag).
suppressMessages({ library(DESeq2); library(clusterProfiler) })
d <- read.delim("contagem_anotada.tsv", check.names = FALSE, quote = "")
l2g <- read.delim("locus2gene.tsv"); n2b <- read.delim("name2b.tsv", header = FALSE, col.names = c("gene","b"))
cc <- c("CTRL_D1_R1","CTRL_D1_R2","CTRL_D1_R3","PU239_D1_R1","PU239_D1_R2","PU239_D1_R3")
m <- as.matrix(d[, cc]); rownames(m) <- d$locus_tag; m <- m[rowSums(m) > 0, ]
cond <- factor(rep(c("ctrl","pu"), each = 3), levels = c("ctrl","pu"))
r <- as.data.frame(results(DESeq(DESeqDataSetFromMatrix(m, data.frame(cond = cond), ~cond), quiet = TRUE), contrast = c("cond","pu","ctrl")))
r <- r[!is.na(r$padj), ]
b <- n2b$b[match(l2g$gene[match(rownames(r), l2g$locus_tag)], n2b$gene)]
sig <- unique(na.omit(b[r$padj < 0.05 & abs(r$log2FoldChange) > 2])); uni <- unique(na.omit(b))
cat(sprintf("b-numbers: universe %d, DEGs %d\n", length(uni), length(sig)))
k <- as.data.frame(enrichKEGG(sig, organism = "eco", keyType = "kegg", universe = uni, pvalueCutoff = 1, qvalueCutoff = 1, pAdjustMethod = "BH"))
cat(sprintf("\nKEGG terms with BH < 0.05: %d\n", sum(k$p.adjust < 0.05)))
print(k[k$p.adjust < 0.05, c("ID","Description","GeneRatio","p.adjust")], row.names = FALSE)
cat("-- source Fig. 4 KEGG terms:\n")
print(k[k$ID %in% c("eco02020","eco00330","eco02010"), c("ID","Description","GeneRatio","p.adjust")], row.names = FALSE)
