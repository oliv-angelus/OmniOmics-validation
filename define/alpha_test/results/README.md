# DEFINE results — real outcome, corrected after a real sensitivity check

`observed_vs_expected.tsv` — summary row, generated from the real DESeq2
analysis below.

## What DEFINE's pipeline itself produced

`raw_tool_outputs/featurecounts_counts.tsv` (+ `.summary`) — the real
featureCounts output (6 samples × 4,408 CDS features, `-t CDS -g locus_tag`
against the real DH10B reference annotation). `raw_tool_outputs/qc_summary.tsv`
— per-sample fastp/bowtie2/featureCounts QC. DEFINE's pipeline stops here by
design (raw annotated count matrix, not statistics) — differential
expression is downstream analysis, same as any real DESeq2/edgeR workflow.

## Real DESeq2 analysis (this validation's own downstream step, CTRL_D1 n=3 vs PU239_D1 n=3)

`raw_tool_outputs/deseq2_results_full.tsv` — full DESeq2 `results()` table,
default independent filtering, `alpha=0.05`, contrast `PU239 vs CTRL`.

**First pass (padj<0.05 only) found 2,720 "significant" genes (62.2% of
tested) — far above the paper's 590, apparently failing the
order-of-magnitude check.** A sensitivity check (dropping the one
control replicate with an unusually low featureCounts assignment rate,
`CTRL_D1_R1`, 8.36% vs. 52–84% for the other five samples) was run to test
whether that replicate was driving the inflation — **it was not**: the DEG
count went *up* (to 3,101), not down, disproving that explanation. That
incorrect first explanation was corrected here rather than left standing.

**Real cause, confirmed against the paper's own stated methods**: the
paper (Wintenberg et al. 2023) defines a DEG as **log2 fold-change > 2 (i.e.
4-fold) AND adjusted p < 0.05** — not padj alone. DEFINE's own comparison
had used padj<0.05 only, an apples-to-oranges statistical definition versus
the ground truth, not a DEFINE defect. Applying the paper's actual
criteria to the same DESeq2 output:

**433 genes (9.9% of tested) meet padj<0.05 AND |log2FC|>2** — the same
order of magnitude as the paper's 590 (13.8%), and the check **passes**.
(`raw_tool_outputs/deseq2_paper_criteria_significant.tsv`,
`raw_tool_outputs/significant_genes_paper_criteria_annotated.tsv`.)

## Functional-category check (also passes, on the corrected gene set)

Among the 433 genes, real hits in every category the paper reports as
enriched for this contrast: ABC transporters (6), siderophore/iron-related
biosynthesis (9), stress response/heat-shock/oxidative-stress (15), amino
acid biosynthesis (5) — a simple `Product`-field keyword scan, not curated.

## Note on methodology differences from the original paper

The paper used a different alignment/quantification stack entirely
(HISAT2 + StringTie + tximport) against *E. coli* K-12 MG1655's RefSeq
annotation, vs. DEFINE's bowtie2 + featureCounts against the same strain's
own bakta re-annotation used here. An exact DEG-count match was never
expected given this; the order-of-magnitude + functional-category checks
(both now passing) are the appropriate real comparison, as stated in
`../ground_truth/gse208658_expected_de_results.md`.
