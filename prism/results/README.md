# PRISM results — round 2 (November 2026)

Run on the tapajos cluster (UFOPA; 128-core, ~264 GB node, openSUSE Leap 15.3) with Snakemake 9.26.0, from the configuration in `../config/`. `run_logs_summary.txt` lists every Snakemake invocation of the run (progress, errors, elapsed time).

**Status: met.**

Re-run after fixing read orientation at primer trimming (reads sequenced in reverse orientation were discarded in round 1) and with the kit's primer preset `16s_ont_mab_kit` (SQK-MAB114.24 includes Chlamydia- and Borrelia-specific primers).

- Reads retained per step (rep1/rep2/rep3): raw 53,011/69,034/59,873; Filtlong 85.8/85.7/85.5%; primer trimming 67.9/67.1/72.0% (28.2% in round 1); VSEARCH chimera removal 87.7/90.4/88.6%; 51.1/52.0/54.5% of raw reads in the final table.
- All 4 added species detected in all 3 replicates: *C. trachomatis* 2.0–2.1%, *B. burgdorferi* 2.9%, *B. adolescentis* 6.1–6.3%, *G. vaginalis* 8.1–8.6%. Genera outside the standard: 0.03–0.08%.
- The 8 Zymo bacteria are within 2-fold of the theoretical 16S composition; the vendor's classification of the same reads deviates in the same direction for every genus, and PRISM is closer to the theoretical value for 7 of the 8.
- Bray-Curtis to the vendor's Emu classification: 0.022–0.042, vs. 0.005–0.008 between the vendor's own replicates. This measures agreement between classifications, not accuracy.

`observed_vs_expected.tsv` gives the mean of the three replicates. `comparison_with_vendor.txt` (from `cmp_prism.py`) also lists database/chimera-removal configurations tested along the way; the validated run is the column `PIPELINE new`. The same run was repeated through the command line (`omniomics run --submit pbs`): identical abundance table, read count by read count.
