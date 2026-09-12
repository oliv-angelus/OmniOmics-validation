# OmniOmics — Validation & Reproducibility Package

Real, non-dry-run validation of all five [OmniOmics](https://github.com/oliv-angelus/OmniOmics) pipelines (MAGMA, SIGMA, DOGMA, DEFINE, PRISM) against public datasets with a known, published ground truth. This is Deliverable B of the OmniOmics tool paper.

## Why this is a separate repository

OmniOmics does not modify or reimplement the algorithms of the tools it orchestrates — a head-to-head accuracy benchmark would measure those tools, not this contribution. What this package demonstrates instead: the orchestration layer (Snakemake DAG + config generation) reproduces correct, expected output when run for real, end to end, against data with a known answer.

Raw sequencing data is **never** re-hosted here — every dataset is already public (SRA/ENA/GEO/vendor open-data accessions, cited per pipeline below). This repository holds what's actually ours to share: the curated ground truth, the exact configs used, and the observed-vs-expected comparison once each run completes.

## Layout

Each pipeline has the same three folders:

```
<pipeline>/
  ground_truth/   curated expected result + its real citation (DOI), not fabricated
  config/         the exact config.yaml + samples.tsv used for the real run
  results/        observed-vs-expected comparison table, generated from the real
                   pipeline output (never hand-typed) + a pointer to the raw
                   Snakemake run log as proof of real execution
```

## Datasets and what "correct" means, per pipeline

| Pipeline | Dataset | Ground truth | Tolerance / pass criterion |
|---|---|---|---|
| **MAGMA** | ZymoBIOMICS mock community, "even" + "log" distributions, hybrid Illumina+Nanopore (Nicholls et al. 2019, *GigaScience*, [10.1093/gigascience/giz043](https://doi.org/10.1093/gigascience/giz043)) | Certified theoretical composition (%) per species | Observed relative abundance per species within 10% of the certified value; taxonomy call at species level for all 10 |
| **SIGMA** | Individual *E. coli* isolate from the same Zymo series (Illumina ERR2935852) + independent ONT/PacBio reads of the same reference material (McIntyre et al. 2019, *Nat Commun*, [10.1038/s41467-019-08289-9](https://doi.org/10.1038/s41467-019-08289-9)) | Zymo's own reference genome for the isolate | QUAST vs. reference: genome fraction, N50, # misassemblies; short-only vs. hybrid-ONT vs. hybrid-PacBio compared to show real improvement from long-read polishing |
| **DOGMA** | Soil metatranscriptome, glucose-amendment time course (Chuckran et al. 2021, *mSystems*, [10.1128/mSystems.00161-21](https://doi.org/10.1128/mSystems.00161-21)) | Direction of change (up/down) for named gene categories at t8 vs t0, with real fold-changes quoted from the paper | DESeq2 log2FoldChange sign matches the paper's reported direction for ammonium/nitrate transport, N-assimilation (up) and nitrification/denitrification (down) |
| **DEFINE** | *E. coli* exposed to ²³⁹Pu vs. non-irradiated control, day 1 (GEO [GSE208658](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE208658), *mSystems*, [10.1128/msystems.00718-22](https://doi.org/10.1128/msystems.00718-22)) | 590 DEGs (13.8% of CDSs) reported for this exact contrast; functional categories (ABC transporters, siderophore biosynthesis, stress response) | DEG count in the same order of magnitude; enriched functional categories overlap the paper's reported ones |
| **PRISM** | ZymoBIOMICS 16S "MSPlus" community, ONT (vendor open-data release, `s3://ont-open-data/zymo_16s_2025.09`) | ONT's own official Emu classification for the exact same read file (no certified % exists yet for this 2025 community) | Species-level relative abundance correlates with ONT's own result for the same input; all 4 spiked-in species detected |

Sample-size choices (fewer replicates than the original studies for DOGMA/DEFINE) follow standard practice for this kind of demonstration, not a novel biological study — see [nf-core](https://nf-co.re/)'s own minimal `test` profile convention and [SARTools](https://doi.org/10.1101/021741)'s 3-replicates-per-condition validation as the field precedent, documented per-pipeline below.

## Reproducing a run

Each `<pipeline>/config/` folder has the real `config.yaml` and `samples.tsv` used. Point OmniOmics's own `pipelines/<pipeline>/Snakefile` at them with `--configfile`, same invocation the app itself generates internally (see OmniOmics's own `MANUAL_PIPELINE.md` for the headless/HPC command form). No path is local-machine-specific beyond the SRA/ENA/vendor download step, which is documented per dataset above.

## Data Availability & Benefit-Sharing

All datasets reanalyzed here are already public (accessions above); no new biological samples were collected for this work. A Zenodo DOI for this repository will be minted before manuscript submission (not yet assigned).

## License

Code/scripts: MIT. Ground truth tables and result data: [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/).
