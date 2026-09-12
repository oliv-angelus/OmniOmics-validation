# DEFINE validation

**Dataset**: *E. coli* exposed to low-dose ²³⁹Pu ionizing radiation vs. non-irradiated control, day-1 timepoint (the contrast with the strongest reported effect).

Source: GEO series [GSE208658](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE208658) (BioProject `PRJNA860569`). Paper: "Global Transcriptional Response of *Escherichia coli* Exposed In Situ to Different Low-Dose Ionizing Radiation Sources." *mSystems*. DOI: [10.1128/msystems.00718-22](https://doi.org/10.1128/msystems.00718-22).

**Samples used** (reduced from the paper's full 5-condition × 2-timepoint × 3-replicate design — see "Sample size" below): `CTRL_D1_R1/R2/R3` (non-irradiated control, day 1) + `PU239_D1_R1/R2/R3` (²³⁹Pu, day 1), 3 replicates each — exactly the paper's own headline contrast. `ground_truth/all_30_samples_ena.tsv` has the full 30-sample table (5 conditions × 2 timepoints × 3 replicates) for anyone who wants to extend this.

## Ground truth

`ground_truth/gse208658_expected_de_results.md` — 590 DEGs (13.8% of annotated CDSs) reported for this exact contrast in the paper; enriched functional categories (ABC transporters, siderophore biosynthesis, stress response regulons). The paper also deposited its own final count matrix as a GEO supplementary file (`GSE208658_Ec_count_matrix.txt.gz`) — a genuine gene-by-gene ground truth if an exact comparison is wanted later; not pulled into this repo yet.

## Sample size

3 replicates per condition (not the paper's full 5×2×3) follows field convention for this kind of demonstration — see [SARTools](https://doi.org/10.1101/021741)'s own validation design (3 replicates per condition). Also the paper's own reference genome/reference annotation for the *E. coli* strain used is required at run time; see `config/config.yaml`'s `databases.reference_genome`.

## Results (pending)

`results/observed_vs_expected.tsv`:

| column | meaning |
|---|---|
| `n_degs_padj0.05` | number of significant DEGs, Control vs. Pu-239 |
| `expected_n_degs` | 590 (paper's reported count, full replicate design) |
| `order_of_magnitude_match` | whether the real count lands in the same order of magnitude given the smaller replicate count here |
| `enriched_categories` | functional categories the real DESeq2 + downstream enrichment found |
| `categories_match_paper` | overlap with ABC transporters / siderophore biosynthesis / stress response |

Generated from the real pipeline output only. Run logs referenced alongside once available.
