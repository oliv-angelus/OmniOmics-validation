# PRISM validation

**Dataset**: ZymoBIOMICS Microbial Community DNA Standard supplemented with 4 additional species ("MSPlus"), 16S rRNA, Oxford Nanopore, kit SQK-MAB114.24 — released by ONT itself in September 2025 specifically to demonstrate the new kit's improved resolution of closely-related species.

Source: [EPI2ME blog, ONT open data release `zymo_16s_2025.09`](https://epi2me.nanoporetech.com/zymo_16s_2025.09/), bucket `s3://ont-open-data/zymo_16s_2025.09` (public, no-sign-request).

**Samples used**: `MSPLUS_REP1`, `MSPLUS_REP2`, `MSPLUS_REP3` — 3 of the release's 6 available replicates (SUP basecalling model). Each verified byte-identical against the official bucket before use, then converted BAM→FASTQ (`samtools fastq`).

**Not yet covered**: the equivalent PacBio path (vendor's Kinnex 16S mock-community release) — `downloads.pacbcloud.com` was unreachable from both the analysis machine and the HPC cluster at the time this was set up (DNS resolves, connection times out on port 443). Revisit if/when that host is reachable.

## Ground truth

Unlike the other 4 pipelines, no certified theoretical composition exists yet for this 2025 community (too new). Instead: ONT's own official Emu classification of these *exact same* read files, published in the same open-data release (`analysis/emu/MSPlus/MAB114/rep{1,2,3}/`) — `ground_truth/ONT_official_emu_MSPlus_MAB114_rep{1,2,3}_{classification,rel-abundance}.tsv`. This is a same-method reproducibility check (does PRISM's own Emu run on this data match ONT's), not a check against certified truth — stated explicitly, not presented as equivalent to the other 4 pipelines' ground truth.

Reference database: GTDB SSU r220 (Alishum A., Zenodo [10.5281/zenodo.13984843](https://doi.org/10.5281/zenodo.13984843), built on Parks et al. 2022, DOI [10.1093/nar/gkab776](https://doi.org/10.1093/nar/gkab776)) — chosen over SILVA for this validation because it needs no RNA→DNA/header conversion step and keeps PRISM's 16S output in the same GTDB-rank lineage format the other OmniOmics pipelines' Plots tab already expects.

## Results (pending)

`results/observed_vs_expected.tsv`, one row per replicate × species:

| column | meaning |
|---|---|
| `replicate` | `rep1`/`rep2`/`rep3` |
| `species` | GTDB-style lineage call |
| `ont_official_pct` | ONT's own Emu relative abundance for this read file |
| `prism_observed_pct` | PRISM's real Emu output (same method, GTDB SSU reference instead of ONT's own) |
| `correlation_per_replicate` | Pearson/Spearman correlation across all species, one value per replicate |
| `four_spiked_species_detected` | whether *Bifidobacterium adolescentis*, *Borrelia burgdorferi* (as *bissettiae*/*garinii* under GTDB), *Chlamydia trachomatis*, and *Gardnerella vaginalis* (as *Bifidobacterium vaginale* under GTDB) are all present |

Generated from the real pipeline output only. Run logs referenced alongside once available.
