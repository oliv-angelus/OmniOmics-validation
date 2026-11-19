# PRISM validation

**Dataset**: ZymoBIOMICS Microbial Community DNA Standard with *Bifidobacterium adolescentis*, *Borrelia burgdorferi*, *Chlamydia trachomatis* and *Gardnerella vaginalis* gDNA added ("MSPlus"), full-length 16S, Oxford Nanopore kit SQK-MAB114.24, released by ONT in September 2025 (`zymo_16s_2025.09`, [EPI2ME](https://epi2me.nanoporetech.com/zymo_16s_2025.09/), bucket `s3://ont-open-data/zymo_16s_2025.09`).

Samples: `MSPLUS_REP1`–`MSPLUS_REP3`, 3 of the release's replicates (SUP basecalls), checked byte-identical against the bucket and converted BAM → FASTQ (`samtools fastq`).

## Reference and pass criterion

- The expected composition of the standard (theoretical 16S share for its 8 bacteria).
- The vendor's own Emu classification of the same reads, as a **reference classification**, not a ground truth (`ground_truth/ONT_official_emu_MSPlus_MAB114_rep{1,2,3}_*.tsv`).
- All 4 added species detected; genus-level agreement with the expected composition; Bray-Curtis to the vendor classification compared with the between-replicate value.

## Configuration

`config/config.yaml` + `config/samples.tsv`: primer preset `16s_ont_mab_kit` (the kit's primers, including the Chlamydia- and Borrelia-specific ones); classification with Emu (Curry et al. 2022, [10.1038/s41592-022-01520-4](https://doi.org/10.1038/s41592-022-01520-4)) and its default database (rrnDB v5.6 + NCBI 16S RefSeq).

## Result — met

Details in [`results/README.md`](results/README.md). All 12 bacteria detected in every replicate (*C. trachomatis* 2.0–2.1%); the 8 of the base standard within 2-fold of their theoretical share, closer to it than the vendor classification for 7 of the 8; Bray-Curtis to the vendor 0.022–0.042 vs. 0.005–0.008 between the vendor's replicates. The same run repeated through OmniOmics's command line gave an identical abundance table.

## Alpha test

The alpha test (September 2026) is kept unchanged in [`alpha_test/`](alpha_test/) (its `config/` and `results/`). It is superseded by the validation above.
