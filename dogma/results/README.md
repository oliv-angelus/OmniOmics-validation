# DOGMA results — validation (November 2026)

Run on the tapajos cluster (UFOPA; 128-core, ~264 GB node, openSUSE Leap 15.3) with Snakemake 9.26.0, from the configuration in `../config/`. `run_logs_summary.txt` lists every Snakemake invocation of the run (progress, errors, elapsed time).

**Status: partially met — 12 of 14 targets significant in the direction reported by Chuckran et al. (2021).**

## Design

n = 4 per time point (t0: C0R1–C0R4, t8: C8R1–C8R4; the alpha test used 2). Source criteria: features with < 60 summed reads removed, FDR < 0.01.

## Method (`de_n4_allko.R`)

Counted as in the source (KEGG-ortholog read counts): within each sample, Salmon `NumReads` summed per KEGG ortholog assigned by eggNOG-mapper (a transcript with several KOs counts toward each); 3,513 KOs kept after the ≥ 60-read filter; DESeq2 (1.50.2) with its default median-of-ratios size factors; contrast t8 vs t0, `alpha = 0.01`. Nitrification, denitrification and assimilatory nitrate reduction are pooled NCycDB gene families (Tu et al. 2019, [10.1093/bioinformatics/bty741](https://doi.org/10.1093/bioinformatics/bty741)), tested with the size factors of the KO matrix.

Run: `Rscript de_n4_allko.R <folder>`, where `<folder>` holds `quant/<sample>_quant.sf`, `eggnog/<sample>_eggnog.tsv` and `ncycdb/<sample>_ncycdb.tsv` from DOGMA's `06_QUANTIFICATION/<sample>/prokaryote/` and `05_ANNOTATION/<sample>/prokaryote/{eggnog,ncycdb}/`.

## Result (`observed_vs_expected.tsv`)

| Target | Source | log2FC ± SE | padj | Met |
|---|---|---|---|---|
| amtB | up | 3.75 ± 0.49 | 3.3e-13 | yes |
| glnA | up | 2.71 ± 0.22 | 5.2e-33 | yes |
| gltB | up | 3.01 ± 0.23 | 5.3e-38 | yes |
| gltD | up | 4.22 ± 0.47 | 5.7e-18 | yes |
| gltS | up | 2.59 ± 0.25 | 6.0e-24 | yes |
| glnD | up | 5.57 ± 0.59 | 4.9e-20 | yes |
| glnB | up | 3.93 ± 0.41 | 1.3e-20 | yes |
| glnK | up | 4.14 ± 0.41 | 3.3e-22 | yes |
| NtrC family | up | 2.63 ± 0.35 | 3.3e-13 | yes |
| nitrification | down | −5.15 ± 0.58 | 1.5e-17 | yes |
| denitrification | down | −2.95 ± 0.47 | 2.8e-09 | yes |
| rpoN | down, LFC < −1 | −1.21 ± 0.26 | 1.1e-05 | yes |
| assimilatory nitrate reduction | up | 0.32 ± 0.29 | 0.32 | no |
| crp | down, LFC < −1 | 0.76 ± 0.29 | 0.016 | no |

## Alpha-test counting at n = 4 (`de_n4.R`)

The alpha test counted eggNOG `Preferred_name` instead of KOs, with size factors from each sample's total reads. Under `Preferred_name`, most K00284 (gltS) transcripts are named `gltB`, so gltS was "not detected" in the alpha test. The same counting at n = 4 (columns `first_round_method_*` in `observed_vs_expected.tsv`; `raw_tool_outputs/deseq2_results.csv`) gives assimilatory nitrate reduction significantly up (1.29 ± 0.31, padj 3.0e-5), crp significantly up (0.82 ± 0.27, padj 0.003) and rpoN not significant (−0.36 ± 0.59). The KO counting is reported as the result because it is the source's own; both are given here.

## The two targets not met

Both are community-level sums over every transcript assigned to the category, so they combine changes in expression per cell with changes in the abundance of the organisms carrying the genes, and they changed with the counting and normalization used. The source assembled and annotated differently (per-sample MEGAHIT, KEGG), and small effects such as that reported for crp are the most sensitive to these differences.

## Steps not run

CAT/BAT, EUKulele and the paired MAGMA MAG database (`--omit-from cat_setup eukulele_setup magma_mag_db`): their databases were not installed on the compute node. None is on the path of this comparison.

## Files

- `raw_tool_outputs/deseq2_results_allko.csv` — DESeq2 results for all 3,513 KOs + 3 NCycDB categories
- `raw_tool_outputs/target_counts_allko.csv` — counts of the 14 targets per sample
- `raw_tool_outputs/deseq2_results.csv`, `gene_family_count_matrix.csv` — alpha-test counting at n = 4
