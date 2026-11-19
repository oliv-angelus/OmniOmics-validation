# DEFINE results — round 2 (November 2026)

Run on the tapajos cluster (UFOPA; 128-core, ~264 GB node, openSUSE Leap 15.3) with Snakemake 9.26.0, from the configuration in `../config/`. `run_logs_summary.txt` lists every Snakemake invocation of the run (progress, errors, elapsed time).

**Status: partially met.**

E. coli K-12 MG1655 (RefSeq GCF_000005845.2, as in the source), 239Pu vs. control, day 1, 3 replicates each. DEFINE stops at the annotated count table (`raw_tool_outputs/contagem_anotada.tsv`); DESeq2 and over-representation analysis ran in the app's pinned R environment (R 4.5.3, DESeq2 1.50.2, clusterProfiler 4.18.4).

- Source criteria (|log2FC| > 2, padj < 0.05): 417 DEGs (10.0% of 4,186 tested genes) vs. 590 (13.8% of CDSs) reported by Wintenberg et al. (2023).
- Against the DEGs obtained with the same criteria from the authors' deposited matrix `GSE208658_Ec_count_matrix.txt.gz` (3,853 shared genes): precision 0.72, recall 0.53, Jaccard 0.44; 265 of 276 shared DEGs in the same direction; log2FC Pearson 0.58 / Spearman 0.67 (`define_cmp2.R`, output in `comparison_with_deposited_matrix.txt`; locus tags mapped to gene names with `locus2gene.py` → `locus2gene.tsv`).
- In the deposited matrix, the control day-1 replicate 2 and 3 columns are identical; DESeq2 on it as deposited returns the 590 DEGs the source reports.
- ORA (BH < 0.05): all 3 GO terms reported for this contrast recovered (respiratory chain complex I, respirasome, NADH dehydrogenase (quinone) activity); none of the 3 KEGG pathways. The same KEGG analysis on the deposited matrix returns one of the three (`define_ora.R`, `kegg_ora.R`, `kegg_source.R`; KEGG REST, November 2026).
