# MAGMA results — round 2 (November 2026)

Run on the tapajos cluster (UFOPA; 128-core, ~264 GB node, openSUSE Leap 15.3) with Snakemake 9.26.0, from the configuration in `../config/`. `run_logs_summary.txt` lists every Snakemake invocation of the run (progress, errors, elapsed time).

**Status: partially met.**

## Read-based abundance (`observed_vs_expected.tsv`, `abundance_vs_alignment_reference.txt`)

Reference: the same clean Illumina pairs aligned with Bowtie2 to the 10 Zymo genomes, counting uniquely placed pairs (MAPQ ≥ 10); 98.7% (Even) and 94.7% (Log) of pairs aligned. Kraken2 (PlusPFP, `--confidence 0.05`) + Bracken, summed per genus. `compare.py raw_tool_outputs` regenerates the table.

- Even: 8 of 10 species within ±10% of the reference; *S. enterica* +22%, *E. coli* −21%.
- Log: 6 of 10 within ±10%. Detection threshold 0.02% of classified reads (just above the largest genus outside the community, 0.018%): the 6 species above it were all detected, 5 within ±10% (*S. enterica* +26%); the 4 below it fall under the threshold.
- Genera outside the community: 0.087% (Even), 0.031% (Log).
- `--confidence` 0.05 (default) gave the best total of the values tested (0.05–0.5).

## MAGs (`raw_tool_outputs/final_mag_catalog.tsv`, `gtdbtk.bac120.summary.tsv`, `checkm2_*.tsv`, `coverm_coverage.tsv`)

Before dereplication: Even, 8 MAGs, one per bacterial species (CheckM2 completeness ≥ 99.6%, contamination ≤ 0.96%); Log, 3 MAGs (*L. monocytogenes*, *P. aeruginosa*, *B. subtilis*), the three bacteria above 0.8% of reads. After dereplication, 8 MAGs, each classified by GTDB-Tk as the expected species (*B. subtilis* as *B. spizizenii*, *L. monocytogenes* as *L. monocytogenes_B*); 7 meet MIMAG high quality, and the *E. faecalis* MAG (no 23S rRNA gene) is medium quality.

Genome-resolved abundance (CoverM, mean coverage × MAG length, share among the 8 bacteria): Even, 7 of 8 within ±10%; Log, *L. monocytogenes*, *P. aeruginosa*, *S. enterica* and *E. coli* within ±10%, *B. subtilis* +24%.

Note: in this cluster run, `final_mag_catalog.tsv` was first built before GTDB-Tk finished and read a GTDB-Tk summary left from an earlier attempt (the hand-written cluster config's `active_tools` did not list `gtdbtk`, which is what orders the two rules; configurations written by the app or the command line list it). The catalog was rebuilt from the final GTDB-Tk output; the file here is the rebuilt one.

## VIBRANT

VIBRANT first finished without results (incomplete database on the node; VIBRANT exits 0 on this error). The rule now fails in that case; VIBRANT was re-run with a complete database: 31 (Even) and 34 (Log) putative phages.
