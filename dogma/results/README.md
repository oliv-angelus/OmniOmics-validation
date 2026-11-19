# DOGMA results — validation (November 2026)

Run on the tapajos cluster (UFOPA; 128-core, ~264 GB node, openSUSE Leap 15.3) with Snakemake 9.26.0, from the configuration in `../config/`. `run_logs_summary.txt` lists every Snakemake invocation of the run (progress, errors, elapsed time).

**Status: partially met — 12 of 14 targets significant in the direction reported by Chuckran et al. (2021).**

## Design

n = 4 per time point (t0: C0R1–C0R4, t8: C8R1–C8R4; the alpha test used 2). Source criteria: features with < 60 summed reads removed, FDR < 0.01.

## Method

**KEGG-ortholog targets — OmniOmics's own DOGMA analysis.** The 11 KO targets come from the application's Plots-tab analysis `dogma_functional_differential` (`plots/scripts/load_dogma_table.R` + `plots/scripts/analyses/dogma_functional_differential.R`), run in the application's pinned R environment (R 4.5.3, DESeq2 1.50.2) with `--annotation_column eggnog_KEGG_ko --min_total_count 60 --alpha 0.01`, `time` t8 vs t0 (`app_metadata.tsv`). It sums Salmon `NumReads` per KEGG ortholog within each sample (an ORF with several KOs counts toward each), keeps features with ≥ 60 summed reads (3,506 KOs) and runs DESeq2 with its default median-of-ratios size factors. Full output: `raw_tool_outputs/app_dogma_functional_differential_KO.csv`.

**NCycDB categories — `de_n4_allko.R`.** Nitrification, denitrification and assimilatory nitrate reduction are pooled NCycDB gene families (Tu et al. 2019, [10.1093/bioinformatics/bty741](https://doi.org/10.1093/bioinformatics/bty741)), which the app tests per family rather than pooled. The script builds the same KO matrix, takes its size factors, and tests the three pooled categories with them (`Rscript de_n4_allko.R <folder>`, where `<folder>` holds `quant/`, `eggnog/` and `ncycdb/` per sample). Its KO results agree with the app's to within 0.02 in log2FC (`raw_tool_outputs/deseq2_results_allko.csv`).

Note: running the app's DOGMA loader on this run exposed a bug — FeGenie writes the header of `FeGenie-geneSummary.csv` twice, which the loader did not handle; fixed in OmniOmics 1.1.0.

## Result (`observed_vs_expected.tsv`)

| Target | Source | log2FC ± SE | padj | Met |
|---|---|---|---|---|
| amtB | up, 16-fold | 3.75 ± 0.50 | 4.5e-13 | yes |
| glnA | up | 2.70 ± 0.22 | 4.9e-33 | yes |
| gltB | up | 3.00 ± 0.23 | 8.3e-37 | yes |
| gltD | up | 4.21 ± 0.47 | 8.0e-18 | yes |
| gltS | up | 2.58 ± 0.25 | 2.2e-23 | yes |
| glnD | up | 5.56 ± 0.59 | 5.5e-20 | yes |
| glnB | up | 3.94 ± 0.41 | 1.7e-20 | yes |
| glnK | up | 4.16 ± 0.41 | 9.1e-23 | yes |
| NtrC family | up | 2.62 ± 0.35 | 4.1e-13 | yes |
| nitrification | down | −5.15 ± 0.58 | 1.5e-17 | yes |
| denitrification | down | −2.95 ± 0.47 | 2.8e-09 | yes |
| rpoN | down, LFC < −1 | −1.22 ± 0.26 | 9.7e-06 | yes |
| assimilatory nitrate reduction | up | 0.32 ± 0.29 | 0.32 | no |
| crp | down, LFC < −1 | 0.76 ± 0.30 | 0.020 | no |

## Counting by gene name (`de_n4.R`)

Counting eggNOG `Preferred_name` instead of KOs, with size factors from each sample's total reads (columns `gene_name_counting_*`; `raw_tool_outputs/deseq2_results.csv`), gives assimilatory nitrate reduction significantly up (1.29 ± 0.31, padj 3.0e-5), crp significantly up (0.82 ± 0.27, padj 0.003) and rpoN not significant (−0.36 ± 0.59); under `Preferred_name`, most K00284 (gltS) transcripts are named `gltB`, so gltS is not detected. The KO counting is reported as the result because it is the source's own.

## The two targets not met

Both are community-level sums over every transcript assigned to the category, so they combine changes in expression per cell with changes in the abundance of the organisms carrying the genes, and they changed with the counting and normalization used. The source assembled and annotated differently (per-sample MEGAHIT, KEGG), and small effects such as that reported for crp are the most sensitive to these differences.

## Steps not run

CAT/BAT, EUKulele and the paired MAGMA MAG database (`--omit-from cat_setup eukulele_setup magma_mag_db`): their databases were not installed on the compute node. None is on the path of this comparison.

## Files

- `raw_tool_outputs/app_dogma_functional_differential_KO.csv` — the app's DESeq2 results for every KO
- `raw_tool_outputs/deseq2_results_allko.csv` — the script's results for all KOs + 3 NCycDB categories
- `raw_tool_outputs/target_counts_allko.csv` — counts of the 14 targets per sample
- `raw_tool_outputs/deseq2_results.csv`, `gene_family_count_matrix.csv` — counting by gene name
