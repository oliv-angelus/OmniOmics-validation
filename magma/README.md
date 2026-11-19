# MAGMA validation

**Dataset**: ZymoBIOMICS Microbial Community Standard, hybrid Illumina + Nanopore GridION, two distributions (Nicholls SM et al. 2019, *GigaScience* 8:giz043, [10.1093/gigascience/giz043](https://doi.org/10.1093/gigascience/giz043)):

- `ZYMO_EVEN` — 8 bacteria at 12% and 2 yeasts at 2% (theoretical, genomic DNA)
- `ZYMO_LOG` — the same 10 species from 89.1% down to 0.000089%

Accessions (public, not re-hosted): Illumina `ERR2984773` (Even) / `ERR2935805` (Log); Nanopore `ERR3152364` (Even) / `ERR3152366` (Log).

## Reference and pass criterion

The manufacturer's theoretical composition is for genomic DNA and does not separate extraction, library and sequencing biases from classification error. The reference is therefore the composition obtained by aligning the **same clean Illumina pairs** to the 10 reference genomes (Bowtie2, uniquely placed pairs, MAPQ ≥ 10), as Nicholls et al. (2019) did for their Nanopore reads; the manufacturer's theoretical composition is reported alongside: Even, 12% per bacterium and 2% per yeast (`ground_truth/zymo_even_theoretical_composition.tsv`); Log, cell numbers from 89.1% to 0.000089% (ZymoBIOMICS CSII instruction manual, as given by Nicholls et al. 2019; values in `results/compare.py`).

- Read-based abundance (Kraken2 + Bracken) within ±10% (relative) of the reference, per species; detection threshold 0.02% of classified reads.
- MAG recovery per community before dereplication, out of the 8 bacteria, and species of the dereplicated MAGs (GTDB-Tk).

## Configuration

`config/config.yaml` + `config/samples.tsv` — the files used (`read_type: hybrid`, Kraken2 PlusPFP with `--confidence 0.05`, GTDB-Tk, CheckM2).

## Result — partially met

Details in [`results/README.md`](results/README.md).

- Read-based abundance within ±10%: 8 of 10 species (Even; *S. enterica* +22%, *E. coli* −21%) and 6 of 10 (Log; the 4 below the 0.02% threshold fall under it).
- MAGs: Even, 8 (one per bacterium); Log, 3 (the three bacteria above 0.8% of reads). After dereplication, 8 MAGs, all the expected species; 7 MIMAG high quality, *E. faecalis* medium (no 23S rRNA gene).

## Alpha test

The alpha test (September 2026) is kept unchanged in [`alpha_test/`](alpha_test/) (its `config/` and `results/`). It is superseded by the validation above.
