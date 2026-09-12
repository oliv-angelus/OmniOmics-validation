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

## Results

**ONT path — done, PASS.** `results/observed_vs_expected.tsv` (generated from the real QUAST-vs-reference run, `results/quast_vs_reference_report.tsv`, plus real CheckM2/GTDB-Tk output in `results/raw_tool_outputs/`; full run log in `results/run_log_ont.txt`):

| sample | genome fraction | contigs | N50 | misassemblies | species call |
|---|---|---|---|---|---|
| `ECOLI_SHORT_ONLY` | 97.78% | 87 | 116 kb | 0 | *E. coli* ✓ |
| `ECOLI_HYBRID_ONT` | **100.000%** | **2** | **4.77 Mb** | 0 | *E. coli* ✓ |

Hybrid assembly recovers the full reference genome fraction, zero misassemblies, total length within 11 bp of the real reference (4,875,452 vs. 4,875,441). Short-only correctly shows no misassemblies either, just more fragmented — the intended demonstration that long-read polishing measurably improves contiguity without introducing structural errors.

**PacBio path — run in progress**, same table structure, not filled in yet.
