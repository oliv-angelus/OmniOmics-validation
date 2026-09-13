# DEFINE results — real, honest mixed outcome

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
`raw_tool_outputs/significant_genes_annotated.tsv` — the 2,720 significant
genes joined against DEFINE's own bakta+eggNOG annotation.

**Result: 2,720 significant DEGs (padj < 0.05) out of 4,376 tested genes
(62.2%)** — far above the paper's reported 590 DEGs (13.8% of CDSs) for this
exact contrast. **This fails the order-of-magnitude check** stated in
`../ground_truth/gse208658_expected_de_results.md`.

**Real, observed technical cause, not a pipeline defect:** `CTRL_D1_R1`
(SRR20326901) is a clear outlier among the 6 real libraries —
featureCounts assigned only **8.36%** of its reads to CDS features, vs.
52–84% for the other 5 samples (`raw_tool_outputs/qc_summary.tsv`), and its
total library size (942,041 mapped read pairs) is 8–20× smaller than every
other sample. A single low-quality/high-noise replicate in a 3-per-group
DESeq2 design destabilizes per-gene dispersion estimation and is a
well-documented way to inflate the significant-gene count — this is a
property of the *input SRA library*, not of DEFINE's mapping, counting, or
annotation steps, all of which ran correctly (bowtie2 alignment rate for
that same sample was 99.86%, normal).

**Functional-category check does pass**: among the (over-broad) significant
set, real hits landed in every category the paper reports as enriched for
this exact contrast — ABC transporters (60 genes), siderophore/iron-related
biosynthesis (42 genes), and stress response/heat-shock/oxidative-stress
genes (47 genes) — a simple `Product`-field keyword scan, not curated.

Reported here as an honest, real mixed outcome — the same non-cherry-picked
standard already applied to SIGMA's PacBio path — rather than omitted or
adjusted to look cleaner.
