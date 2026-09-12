# SIGMA validation

**Dataset**: an individual *E. coli* isolate from the same ZymoBIOMICS reference material used by MAGMA (strain NRRL B-1109, MLST ST10), sequenced on three platforms by two different studies:
- Illumina (short-only baseline): `ERR2935852` (Nicholls et al. 2019, same paper as MAGMA's dataset)
- Oxford Nanopore GridION: `SRR7415634`
- PacBio RS II (CLR subreads): `SRR8154675`

ONT/PacBio source: McIntyre AB et al. 2019. "Single-molecule sequencing detection of N6-methyladenine in microbial reference materials." *Nat Commun* 10:579. DOI: [10.1038/s41467-019-08289-9](https://doi.org/10.1038/s41467-019-08289-9) (BioProject `PRJNA477598`).

Three separate validation runs, same isolate:
1. `ECOLI_SHORT_ONLY` — Illumina only (baseline, no long-read polishing)
2. `ECOLI_HYBRID_ONT` — Illumina + ONT GridION (`config/ont/`)
3. `ECOLI_HYBRID_PACBIO` — Illumina + PacBio RS II (`config/pacbio/`, separate project directory — SIGMA's `long_read_platform` is a whole-project setting, not per-sample, so ONT and PacBio can't share one config)

Comparing all three against each other is itself part of the demonstration: hybrid assembly should show real improvement (fewer contigs, higher N50, fewer misassemblies) over short-only, for both long-read platforms independently.

## Ground truth

`ground_truth/ecoli_isolate_expected_reference.md` — strain identity, the official Zymo reference-genome package (`ZymoBIOMICS.STD.refseq.v2.zip`), and what "correct" means for this comparison (QUAST against the reference, GTDB-Tk species call, CheckM2 completeness/contamination).

## Data-quality note (real, not hypothetical)

`SRR8154675`'s SRA-deposited PacBio subreads have colliding read IDs (multiple subreads/passes from the same ZMW share the SRA-assigned base ID, differing only in a description field most tools ignore) — `filtlong` rejects duplicate names outright. Reads were renamed to guaranteed-unique sequential IDs before use; this is a real SRA-deposit quirk, not a modification of the underlying sequence data.

## Results (pending)

`results/observed_vs_expected.tsv`, one row per sample (`ECOLI_SHORT_ONLY`, `ECOLI_HYBRID_ONT`, `ECOLI_HYBRID_PACBIO`):

| column | meaning |
|---|---|
| `n_contigs`, `n50`, `genome_fraction_pct`, `n_misassemblies` | from QUAST vs. the real Zymo reference genome |
| `gtdbtk_species_call` | should be *Escherichia coli* for all three |
| `checkm2_completeness_pct`, `checkm2_contamination_pct` | isolate genome quality |

Generated from the real pipeline output only. Run logs referenced alongside once available.
