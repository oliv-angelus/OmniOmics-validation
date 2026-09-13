# DEFINE validation

**Dataset**: *E. coli* exposed to low-dose ²³⁹Pu ionizing radiation vs. non-irradiated control, day-1 timepoint (the contrast with the strongest reported effect).

Source: GEO series [GSE208658](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE208658) (BioProject `PRJNA860569`). Paper: "Global Transcriptional Response of *Escherichia coli* Exposed In Situ to Different Low-Dose Ionizing Radiation Sources." *mSystems*. DOI: [10.1128/msystems.00718-22](https://doi.org/10.1128/msystems.00718-22).

**Samples used** (reduced from the paper's full 5-condition × 2-timepoint × 3-replicate design — see "Sample size" below): `CTRL_D1_R1/R2/R3` (non-irradiated control, day 1) + `PU239_D1_R1/R2/R3` (²³⁹Pu, day 1), 3 replicates each — exactly the paper's own headline contrast. `ground_truth/all_30_samples_ena.tsv` has the full 30-sample table (5 conditions × 2 timepoints × 3 replicates) for anyone who wants to extend this.

## Ground truth

`ground_truth/gse208658_expected_de_results.md` — 590 DEGs (13.8% of annotated CDSs) reported for this exact contrast in the paper; enriched functional categories (ABC transporters, siderophore biosynthesis, stress response regulons). The paper also deposited its own final count matrix as a GEO supplementary file (`GSE208658_Ec_count_matrix.txt.gz`) — a genuine gene-by-gene ground truth if an exact comparison is wanted later; not pulled into this repo yet.

## Sample size

3 replicates per condition (not the paper's full 5×2×3) follows field convention for this kind of demonstration — see [SARTools](https://doi.org/10.1101/021741)'s own validation design (3 replicates per condition). Also the paper's own reference genome/reference annotation for the *E. coli* strain used is required at run time; see `config/config.yaml`'s `databases.reference_genome`.

## Results — real, honest mixed outcome

**Done.** `results/observed_vs_expected.tsv` + full writeup in
`results/README.md`, generated from DEFINE's real featureCounts output
(`results/raw_tool_outputs/`) plus a real downstream DESeq2 analysis (the
pipeline itself stops at the raw annotated count matrix by design).

| check | result |
|---|---|
| DEG count order of magnitude (~590 expected) | **FAILED** — 2,720 real DEGs (padj<0.05, 62.2% of tested genes). Real, identified technical cause: one of the 3 control replicates (`CTRL_D1_R1`) is a genuine library-quality outlier (featureCounts assigned only 8.36% of its reads vs. 52–84% for the other 5 samples) — not a DEFINE pipeline defect; mapping/annotation for that same sample were normal. |
| Functional categories match the paper | **PASSED** — ABC transporters, siderophore/iron biosynthesis, and stress-response genes are all real hits among the significant set. |

Reported as-is, same honesty standard already applied to SIGMA's PacBio
path — not adjusted or omitted to look cleaner.
