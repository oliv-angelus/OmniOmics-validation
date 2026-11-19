# OmniOmics — Validation & Reproducibility Package

[![DOI](https://zenodo.org/badge/1367598567.svg)](https://doi.org/10.5281/zenodo.22780175)

Real, end-to-end validation of all five [OmniOmics](https://github.com/oliv-angelus/OmniOmics) pipelines (MAGMA, SIGMA, DOGMA, DEFINE, PRISM) against public datasets with a known, published ground truth. Companion package of the OmniOmics paper.

## Why this is a separate repository

OmniOmics does not modify or reimplement the algorithms of the tools it orchestrates — a head-to-head accuracy benchmark would measure those tools, not this contribution. What this package demonstrates instead: the orchestration layer (Snakemake DAG + config generation) reproduces correct, expected output when run for real, end to end, against data with a known answer.

Raw sequencing data is **never** re-hosted here — every dataset is already public (SRA/ENA/GEO/vendor open-data accessions, cited per pipeline below). This repository holds what's actually ours to share: the curated ground truth, the exact configs used, and the observed-vs-expected comparison once each run completes.

## Alpha test and validation

- **Validation (November 2026, current)** — every pipeline re-run after peer review, with the corrections and criteria the review asked for (see each pipeline's `results/README.md`). Pipelines run with Snakemake 9.26.0 on the tapajos cluster (UFOPA; 128-core, ~264 GB node, openSUSE Leap 15.3).
- **Alpha test (September 2026, v1.0.0)** — kept unchanged in each `<pipeline>/alpha_test/`.

## Layout

```
<pipeline>/
  ground_truth/   curated expected result + its citation (DOI)
  config/         the exact config.yaml + samples.tsv of the validation run
  results/        validation: observed-vs-expected table, README, the scripts that
                  produced the comparison, raw tool outputs, Snakemake run logs
  alpha_test/     alpha test: its config/ and results/, unchanged
```

## Outcomes (validation)

| Pipeline | Dataset | Reference | Pass criterion | Outcome |
|---|---|---|---|---|
| **MAGMA** | ZymoBIOMICS mock communities Even and Log, Illumina + ONT (Nicholls et al. 2019, [10.1093/gigascience/giz043](https://doi.org/10.1093/gigascience/giz043)) | Same Illumina reads aligned to the 10 reference genomes | Read-based abundance within ±10% (relative) per species, detection threshold 0.02%; MAG recovery out of 8 bacteria | **Partially met** — 8/10 (Even) and 6/10 (Log) within ±10%; 8 MAGs, one per bacterium in Even, all classified as the expected species |
| **SIGMA** | *E. coli* isolate of the same standard: Illumina (Nicholls et al. 2019), ONT and PacBio (McIntyre et al. 2019, [10.1038/s41467-019-08289-9](https://doi.org/10.1038/s41467-019-08289-9)) | Zymo's reference genome | QUAST: contigs, NGA50, genome fraction, misassemblies, mismatches/indels; hybrid vs. short-only | **Met** — both hybrids: 2 circular contigs, 100% genome fraction, 0 misassemblies |
| **DOGMA** | Soil metatranscriptomes, glucose amendment, t0 and t8, n = 4 each (Chuckran et al. 2021, [10.1128/mSystems.00161-21](https://doi.org/10.1128/mSystems.00161-21)) | Direction and significance of 14 genes/categories reported by the source | Same direction and significance, FDR < 0.01 after removing features with < 60 reads | **Partially met** — 12/14 (not met: crp, assimilatory nitrate reduction) |
| **DEFINE** | *E. coli* exposed to ²³⁹Pu vs. control, day 1, n = 3 each (GEO [GSE208658](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE208658); Wintenberg et al. 2023, [10.1128/msystems.00718-22](https://doi.org/10.1128/msystems.00718-22)) | DEGs from the authors' deposited count matrix with the source criteria; terms of the source's Fig. 4 | Gene-level precision/recall/Jaccard, direction, log2FC correlation; term recovery | **Partially met** — precision 0.72, recall 0.53; 3/3 GO terms, 0/3 KEGG pathways |
| **PRISM** | ZymoBIOMICS standard + 4 added species ("MSPlus"), ONT SQK-MAB114.24, 3 replicates (`s3://ont-open-data/zymo_16s_2025.09`) | Expected composition; the vendor's Emu classification of the same reads | All 4 added species detected; agreement with expected composition; Bray-Curtis to the vendor vs. between replicates | **Met** — all 12 bacteria detected in every replicate; the 8 of the base standard within 2-fold of their theoretical share |

Raw sequencing data is **never** re-hosted here — every dataset is already public.

## Reproducing a run

Each `<pipeline>/config/` folder has the `config.yaml` and `samples.tsv` used; their paths point to the cluster where the run was made, so edit them to where the data and databases are. The simplest way is OmniOmics's command line (see `docs/CLI.md` in the OmniOmics repository): `bin/omniomics run run.yaml` locally, or `--submit pbs` for one PBS job. Equivalently, Snakemake directly:

```bash
snakemake -s OmniOmics/pipelines/<pipeline>/Snakefile --configfile <pipeline>/config/config.yaml \
    --use-conda --cores 64 --keep-going
```

## Data Availability & Benefit-Sharing

All datasets reanalyzed here are already public (accessions above); no new biological samples were collected for this work. This repository is archived on Zenodo. Cite the concept DOI [10.5281/zenodo.22780175](https://doi.org/10.5281/zenodo.22780175): it always resolves to the latest version (v2.0.x, the validation). Each release also has its own version DOI, listed on the Zenodo record; v1.0.0 (the alpha test) is [10.5281/zenodo.22780176](https://doi.org/10.5281/zenodo.22780176).

## License

Code/scripts: MIT. Ground truth tables and result data: [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/).
