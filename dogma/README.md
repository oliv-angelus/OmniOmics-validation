# DOGMA validation

**Dataset**: agricultural soil metatranscriptome, glucose-amendment time course. No mock-community RNA standard exists (Zymo's own standards are DNA-only), so this substitutes a real paired-omics study with a reported, checkable direction of transcriptional change instead of a certified composition.

Source: Chuckran PF et al. 2021. "Rapid Response of Nitrogen Cycling Gene Transcription to Labile Carbon Amendments in a Soil Microbial Community." *mSystems* 6(3):e00161-21. DOI: [10.1128/mSystems.00161-21](https://doi.org/10.1128/mSystems.00161-21). Sample accession table: Chuckran PF et al. 2020, *Microbiol Resour Announc* 9:e00895-20 (PMC7595945).

**Samples used** (reduced from the paper's full 4-timepoints × 4-replicates design — see "Sample size" below): `C0R1`/`C0R2` (t0, baseline) and `C8R1`/`C8R2` (t8, 8h post-glucose), 2 replicates each. `ground_truth/all_16_metatranscriptome_samples.tsv` has the full 16-sample table (all 4 timepoints × 4 replicates) for anyone who wants to extend this.

## Ground truth

`ground_truth/chuckran2021_expected_direction_of_change.md` — real fold-changes and gene categories quoted directly from the paper's Results section: ammonium transporter `amtB` (16× higher at t8), GS-GOGAT assimilation genes, N regulatory network genes all up at t8; nitrification and denitrification genes down.

## Sample size

2 replicates × 2 timepoints (not the paper's full 4×4) follows field convention for this kind of orchestration-layer demonstration, not a novel biological replication study — see [nf-core](https://nf-co.re/)'s own minimal `test`-profile convention. 2 per group is DESeq2's technical floor (1 per group gives 0 residual degrees of freedom and DESeq2 refuses to fit).

## Known limitation: CAT/BAT taxonomy skipped (real infrastructure constraint)

DOGMA's optional CAT/BAT taxonomic-classification step (`cat_setup` +
`cat_annotate`) was **omitted from this validation run**
(`--omit-from cat_setup`), for a real, external reason unrelated to
DOGMA's own code:

- CAT_pack's GTDB database setup downloads `gtdb_proteins_aa_reps.tar.gz`
  directly from `data.gtdb.ecogenomic.org` (hosted by the University of
  Queensland, Australia). A `HEAD` request against that URL confirmed the
  real file size: **`Content-Length: 131946537881` bytes (~123 GB)**.
- From this cluster (UFOPA, tapajos), sustained real transfer speed to
  that host was ~100–170 KB/s (measured directly, both with CAT_pack's own
  downloader and independently with `wget`), even for small files from the
  same host (e.g. a single tree file took over 20s to fail with a
  timeout). At that rate the ~123 GB file would take on the order of
  **10 days** — not a download that failed, a download that is real but
  impractically slow over this specific network path.
- No mirror of this exact file (GTDB's `genomic_files_reps` bundle) was
  found on Zenodo, AWS Open Data, or elsewhere; unofficial GTDB mirrors
  that do exist online host different data products (e.g. Mash sketch
  databases for `sourmash`), not this CAT_pack-specific protein archive.
- **Not on DOGMA's actual validation critical path**: this pipeline's
  pass criterion (see Ground truth above) is the *direction* of
  differential expression for named nitrogen-cycling genes, determined
  from assembly + functional annotation (eggNOG/NCycDB/SCycDB) +
  Salmon quantification + DESeq2 — none of which depend on CAT/BAT's
  taxonomic classification of contigs. Skipping it does not affect the
  real result reported below.

This is analogous to MAGMA's BiG-SCAPE/VIBRANT being skipped on this same
cluster for a different real reason (their databases were never
downloaded here) — both are documented rather than silently worked
around, per this validation's own honesty standard.

## Results

Real HPC run completed 2026-09-15 (`run1`, 54/54 steps, `EXIT_CODE=0`,
elapsed 20h36m — `results/run_log_final_tail.txt`). All 4 samples
(`C0R1`, `C0R2`, `C8R1`, `C8R2`) completed the full chain: QC → rRNA
removal → domain filtering (prokaryote) → 3-assembler ensemble
(rnaSPAdes+MEGAHIT+Trinity) → MMseqs2 dedup → TransDecoder ORF calling →
functional annotation (eggNOG, CAZy, NCycDB, SCycDB, MCycDB, CANT-HYD,
FeGenie) → Salmon quantification.

`results/observed_vs_expected.tsv` — 13 genes/categories named in the
ground truth doc, checked via gene-family-level DESeq2 (C8 vs C0); see
`results/README.md` for the full method and result table.

**11 of 12 detected genes/categories (92%) match the paper's reported
direction of change**, including every gene/category the paper reports
as a strong effect (`amtB`, GS-GOGAT, N-regulatory network,
nitrification, denitrification — all significant, padj ≤ 0.04). The one
mismatch (`crp`) is a subtle, non-significant effect in both this run
and the original paper (see `results/README.md` for the scientific
justification). `gltS` was not detected in any sample's eggNOG
annotation.
