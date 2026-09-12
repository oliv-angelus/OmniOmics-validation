# DOGMA validation

**Dataset**: agricultural soil metatranscriptome, glucose-amendment time course. No mock-community RNA standard exists (Zymo's own standards are DNA-only), so this substitutes a real paired-omics study with a reported, checkable direction of transcriptional change instead of a certified composition.

Source: Chuckran PF et al. 2021. "Rapid Response of Nitrogen Cycling Gene Transcription to Labile Carbon Amendments in a Soil Microbial Community." *mSystems* 6(3):e00161-21. DOI: [10.1128/mSystems.00161-21](https://doi.org/10.1128/mSystems.00161-21). Sample accession table: Chuckran PF et al. 2020, *Microbiol Resour Announc* 9:e00895-20 (PMC7595945).

**Samples used** (reduced from the paper's full 4-timepoints × 4-replicates design — see "Sample size" below): `C0R1`/`C0R2` (t0, baseline) and `C8R1`/`C8R2` (t8, 8h post-glucose), 2 replicates each. `ground_truth/all_16_metatranscriptome_samples.tsv` has the full 16-sample table (all 4 timepoints × 4 replicates) for anyone who wants to extend this.

## Ground truth

`ground_truth/chuckran2021_expected_direction_of_change.md` — real fold-changes and gene categories quoted directly from the paper's Results section: ammonium transporter `amtB` (16× higher at t8), GS-GOGAT assimilation genes, N regulatory network genes all up at t8; nitrification and denitrification genes down.

## Sample size

2 replicates × 2 timepoints (not the paper's full 4×4) follows field convention for this kind of orchestration-layer demonstration, not a novel biological replication study — see [nf-core](https://nf-co.re/)'s own minimal `test`-profile convention. 2 per group is DESeq2's technical floor (1 per group gives 0 residual degrees of freedom and DESeq2 refuses to fit).

## Results (pending)

`results/observed_vs_expected.tsv`, one row per gene/category named in the ground truth doc:

| column | meaning |
|---|---|
| `gene_or_category` | e.g. `amtB`, `nitrification (all)` |
| `expected_direction` | `up` or `down`, from the paper |
| `observed_log2fc` | DESeq2 log2FoldChange, C8 vs C0, from DOGMA's real output |
| `direction_match` | whether the sign agrees with `expected_direction` |

Generated from the real pipeline output only. Run logs referenced alongside once available.
