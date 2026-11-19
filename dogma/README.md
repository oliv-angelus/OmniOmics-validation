# DOGMA validation

**Dataset**: agricultural soil metatranscriptomes before (t0) and 8 h after (t8) glucose amendment, 4 replicates each. No mock RNA community exists (Zymo's standards are DNA), so the reference is a published study's reported transcriptional response.

Samples: Chuckran PF et al. 2020, *Microbiol Resour Announc* 9:e00895-20, [10.1128/MRA.00895-20](https://doi.org/10.1128/MRA.00895-20). Results: Chuckran PF et al. 2021, *mSystems* 6:e00161-21, [10.1128/mSystems.00161-21](https://doi.org/10.1128/mSystems.00161-21).

| Sample | Run | | Sample | Run |
|---|---|---|---|---|
| C0R1 | SRR10849656 | | C8R1 | SRR10849655 |
| C0R2 | SRR10904363 | | C8R2 | SRR10849401 |
| C0R3 | SRR10849749 | | C8R3 | SRR10849649 |
| C0R4 | SRR12334071 | | C8R4 | SRR10849743 |

`ground_truth/all_16_metatranscriptome_samples.tsv` lists all 16 samples of the study (4 time points × 4 replicates).

## Reference and pass criterion

Direction and significance of the 14 genes/categories the source reports for t8 vs t0 (`ground_truth/chuckran2021_expected_direction_of_change.md`), under the source's criteria: features with < 60 summed reads removed, FDR < 0.01.

## Configuration

`config/config.yaml` + `config/samples.tsv`. Run with `--omit-from cat_setup eukulele_setup magma_mag_db`: CAT/BAT, EUKulele and the paired MAGMA MAG database were not run, because their databases were not installed on the compute node (CAT_pack's GTDB protein archive is ~123 GB and downloaded at ~100–170 KB/s from that cluster). None of them is on the path of this comparison (assembly → ORFs → eggNOG/NCycDB annotation → Salmon → DESeq2).

## Result — partially met, 12 of 14

Details, method and per-target table in [`results/README.md`](results/README.md). Met: amtB, glnA, gltB, gltD, gltS, glnD, glnB, glnK, NtrC family (up), nitrification, denitrification, rpoN (down). Not met: assimilatory nitrate reduction (0.32, padj 0.32) and crp (0.76, padj 0.016).

## Alpha test

The alpha test (September 2026) is kept unchanged in [`alpha_test/`](alpha_test/) (its `config/` and `results/`). It is superseded by the validation above.
