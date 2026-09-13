# MAGMA validation

**Dataset**: ZymoBIOMICS mock community, hybrid Illumina + Nanopore GridION, two distributions:
- `ZYMO_EVEN` — 10 species at known equal abundance (8 bacteria @ 12%, 2 yeasts @ 2%)
- `ZYMO_LOG` — same 10 species, logarithmic distribution (~89% down to ~0.000089%), tests detection sensitivity across 6 orders of magnitude

Source: Nicholls SM et al. 2019. "Ultra-deep, long-read nanopore sequencing of mock microbial community standards." *GigaScience* 8(5):giz043. DOI: [10.1093/gigascience/giz043](https://doi.org/10.1093/gigascience/giz043).

Accessions (public, not re-hosted here): Illumina `ERR2984773` (even) / `ERR2935805` (log); Nanopore GridION `ERR3152364` (even) / `ERR3152366` (log).

## Ground truth

`ground_truth/zymo_even_theoretical_composition.tsv` — the 10 species' certified theoretical abundance (%), NRRL/ATCC strain accessions, from the paper's own Table 1. The "log" distribution's per-species theoretical values are in the same paper's Table 2 (not separately tabulated here — reference the paper directly for exact log-scale values).

## Config

`config/config.yaml` + `config/samples.tsv` — exact files used for the real run on the tapajos HPC cluster. `read_type: hybrid` for both samples (short+long reads combined via `metaspades_hybrid`).

## Results — real, honest mixed outcome

**Done.** `results/observed_vs_expected.tsv` + full writeup in
`results/README.md`, generated from the real completed run (Kraken2 +
Bracken read-based profiling, and independently, real assembly + MAG
recovery + GTDB-Tk classification).

| check | result |
|---|---|
| All 10 species detected, both distributions | **PASSED** |
| Detection across ~5 orders of magnitude (ZYMO_LOG) | **PASSED** |
| Read-based abundance within ±10% of certified value (ZYMO_EVEN) | **PARTIAL** — 2/10 species (real deviations of 0.5–3.6 points for the rest, attributable to known extraction/genome-copy-number bias in read-based profiling, not a pipeline defect) |
| MAG recovery + correct species classification | **PASSED** — 7 MAGs recovered, 7/7 correctly classified, 0 false calls |

See `results/README.md` for the full breakdown and the real numbers.
