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

## Results (pending)

`results/observed_vs_expected.tsv` will report, once the run completes:

| column | meaning |
|---|---|
| `species` | one of the 10 Zymo reference species |
| `expected_pct_even` / `expected_pct_log` | certified theoretical abundance |
| `observed_pct_even` / `observed_pct_log` | MAGMA's real output (`abundance_table_final_RAW.tsv`, reads-based) |
| `deviation_even` / `deviation_log` | `abs(observed - expected)` |
| `pass_10pct` | `deviation <= 0.10 * expected` |
| `mag_taxonomy_match` | whether a dereplicated MAG (`final_mag_catalog.tsv`, GTDB-Tk call) resolves to the correct species |

Generated from the real pipeline output only — never hand-entered. Run log referenced alongside once available.
