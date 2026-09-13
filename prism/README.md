# PRISM validation

**Dataset**: ZymoBIOMICS Microbial Community DNA Standard supplemented with 4 additional species ("MSPlus"), 16S rRNA, Oxford Nanopore, kit SQK-MAB114.24 — released by ONT itself in September 2025 specifically to demonstrate the new kit's improved resolution of closely-related species.

Source: [EPI2ME blog, ONT open data release `zymo_16s_2025.09`](https://epi2me.nanoporetech.com/zymo_16s_2025.09/), bucket `s3://ont-open-data/zymo_16s_2025.09` (public, no-sign-request).

**Samples used**: `MSPLUS_REP1`, `MSPLUS_REP2`, `MSPLUS_REP3` — 3 of the release's 6 available replicates (SUP basecalling model). Each verified byte-identical against the official bucket before use, then converted BAM→FASTQ (`samtools fastq`).

**Not yet covered**: the equivalent PacBio path (vendor's Kinnex 16S mock-community release) — `downloads.pacbcloud.com` was unreachable from both the analysis machine and the HPC cluster at the time this was set up (DNS resolves, connection times out on port 443). Revisit if/when that host is reachable.

## Ground truth

Unlike the other 4 pipelines, no certified theoretical composition exists yet for this 2025 community (too new). Instead: ONT's own official Emu classification of these *exact same* read files, published in the same open-data release (`analysis/emu/MSPlus/MAB114/rep{1,2,3}/`) — `ground_truth/ONT_official_emu_MSPlus_MAB114_rep{1,2,3}_{classification,rel-abundance}.tsv`. This is a same-method reproducibility check (does PRISM's own Emu run on this data match ONT's), not a check against certified truth — stated explicitly, not presented as equivalent to the other 4 pipelines' ground truth.

Reference database: GTDB SSU r220 (Alishum A., Zenodo [10.5281/zenodo.13984843](https://doi.org/10.5281/zenodo.13984843), built on Parks et al. 2022, DOI [10.1093/nar/gkab776](https://doi.org/10.1093/nar/gkab776)) — chosen over SILVA for this validation because it needs no RNA→DNA/header conversion step and keeps PRISM's 16S output in the same GTDB-rank lineage format the other OmniOmics pipelines' Plots tab already expects.

## Results — real, honest mixed outcome (strong correlation, one real miss)

**Done.** `results/observed_vs_expected.tsv` + full writeup in
`results/README.md`, generated from PRISM's real Emu output (GTDB SSU
r220) against ONT's own official Emu classification of the same reads.

| check | result |
|---|---|
| Genus-level community correlation vs. ONT's own result | **PASSED** — Pearson r = 0.96–0.98 across all 3 replicates (mean 0.966) |
| All 4 spiked species detected | **FAILED (3/4)** — *Bifidobacterium adolescentis*, *B. vaginale* (=*Gardnerella vaginalis*), and *Borreliella/Borrelia burgdorferi* detected with closely matching abundances; *Chlamydia trachomatis* not detected at all (0% vs. ONT's ~1.9–2.0%), most likely due to the well-documented mismatch between "universal" 16S primers and Chlamydiae sequences — see `results/README.md` for the full investigation (database coverage ruled out; loss traced to the primer-trimming step). |

Reported as-is, same honesty standard applied throughout this validation.
