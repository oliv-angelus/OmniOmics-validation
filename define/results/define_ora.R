# Over-representation analysis of DEFINE's Pu-239 day-1 DEGs, compared with
# Wintenberg et al. 2023 (doi:10.1128/msystems.00718-22), Fig. 4.
# DEGs: DESeq2, |log2FC| > 2 and padj < 0.05 (source criteria). Terms: the
# eggNOG-mapper KEGG_Pathway and GOs columns of DEFINE's own annotated count
# table (the same TERM2GENE approach as plots/scripts/analyses/
# functional_enrichment.R), universe = all tested genes, BH < 0.05.
suppressMessages({ library(DESeq2); library(clusterProfiler) })
args <- commandArgs(TRUE)
d <- read.delim(args[1], check.names = FALSE, quote = "")
cc <- c("CTRL_D1_R1","CTRL_D1_R2","CTRL_D1_R3","PU239_D1_R1","PU239_D1_R2","PU239_D1_R3")
m <- as.matrix(d[, cc]); rownames(m) <- d$locus_tag; m <- m[rowSums(m) > 0, ]
cond <- factor(rep(c("ctrl","pu"), each = 3), levels = c("ctrl","pu"))
r <- as.data.frame(results(DESeq(DESeqDataSetFromMatrix(m, data.frame(cond = cond), ~cond), quiet = TRUE),
                           contrast = c("cond","pu","ctrl")))
r <- r[!is.na(r$padj), ]
sig <- rownames(r)[r$padj < 0.05 & abs(r$log2FoldChange) > 2]
uni <- rownames(r)
cat(sprintf("tested %d, DEGs %d (up %d, down %d)\n", length(uni), length(sig),
            sum(r[sig,"log2FoldChange"] > 0), sum(r[sig,"log2FoldChange"] < 0)))
ann <- d[match(uni, d$locus_tag), ]
t2g <- function(col, keep = function(x) TRUE) {
  v <- ann[[col]]
  out <- do.call(rbind, Map(function(g, s) {
    if (is.na(s) || s %in% c("", "-")) return(NULL)
    t <- trimws(strsplit(s, ",")[[1]]); t <- t[t != "" & t != "-" & keep(t)]
    if (!length(t)) return(NULL); data.frame(term = t, gene = g)
  }, ann$locus_tag, v))
  unique(out)
}
show <- function(lab, res, targets) {
  df <- as.data.frame(res)
  cat(sprintf("\n== %s: %d term(s) with BH < 0.05\n", lab, sum(df$p.adjust < 0.05)))
  if (nrow(df)) print(head(df[df$p.adjust < 0.05, c("ID","GeneRatio","BgRatio","p.adjust")], 30), row.names = FALSE)
  cat("-- source Fig. 4 terms:\n")
  for (t in names(targets)) {
    hit <- df[df$ID == t, ]
    cat(sprintf("  %-12s %-45s %s\n", t, targets[[t]],
                if (nrow(hit)) sprintf("p.adjust %.3g (%s)", hit$p.adjust, hit$GeneRatio) else "not tested / no DEG"))
  }
}
kegg <- enricher(sig, universe = uni, TERM2GENE = t2g("KEGG_Pathway", function(t) startsWith(t, "map")),
                 pvalueCutoff = 1, qvalueCutoff = 1, minGSSize = 1, maxGSSize = 5000)
show("KEGG (eggNOG KEGG_Pathway)", kegg, list(map02020 = "Two-component system",
     map00330 = "Arginine and proline metabolism", map02010 = "ABC transporters"))
go <- enricher(sig, universe = uni, TERM2GENE = t2g("GOs"),
               pvalueCutoff = 1, qvalueCutoff = 1, minGSSize = 1, maxGSSize = 5000)
show("GO (eggNOG GOs)", go, list(`GO:0045271` = "respiratory chain complex I",
     `GO:0070469` = "respirasome", `GO:0050136` = "NADH dehydrogenase (quinone) activity",
     `GO:0008137` = "NADH dehydrogenase (ubiquinone) activity"))
