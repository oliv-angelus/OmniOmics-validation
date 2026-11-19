# SIGMA results — validation (November 2026)

Run on the tapajos cluster (UFOPA; 128-core, ~264 GB node, openSUSE Leap 15.3) with Snakemake 9.26.0, from the configuration in `../config/ont/` and `../config/pacbio/`. `run_logs_summary.txt` lists every Snakemake invocation of the run (progress, errors, elapsed time). (`run_logs_summary_ont.txt`, `run_logs_summary_pacbio.txt`)

**Status: met.**

QUAST against Zymo's reference genome for the isolate (4,875,441 bp); hybrid assemblies polished with Polypolish and Pypolca (`quast_vs_reference_report.tsv`, `observed_vs_expected.tsv`).

| Assembly | Contigs | NGA50 | Genome fraction | Misassemblies | Mismatches / indels per 100 kbp |
|---|---|---|---|---|---|
| Short-only | 87 | 116 kb | 97.78% | 0 | 6.06 / 0.36 |
| ONT hybrid | 2 (circular) | 4.77 Mb | 100.000% | 0 | 10.99 / 1.17 |
| PacBio hybrid | 2 (circular) | 4.77 Mb | 100.000% | 0 | 11.01 / 1.07 |

The first PacBio run used SRR8154675, which is *E. coli* K-12 MG1655, not the Zymo strain (NRRL B-1109): 21 misassemblies against the B-1109 reference (`quast_vs_reference_report_first_pacbio_K12.tsv`). The PacBio reads of the Zymo strain (SRR7498041, McIntyre et al. 2019) were used for the result above. Reference-guided scaffolding (RagTag) was not used.

VIBRANT was re-run with a complete database (see MAGMA): 6, 5 and 8 putative phages in the ONT hybrid, PacBio hybrid and short-only assemblies.
