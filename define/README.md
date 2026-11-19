# DEFINE validation

**Dataset**: *E. coli* DH10β exposed in situ to ²³⁹Pu vs. non-irradiated control, day 1, 3 biological replicates each — the source's day-1 ²³⁹Pu contrast. GEO [GSE208658](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE208658) (BioProject `PRJNA860569`); Wintenberg M et al. 2023, *mSystems* 8:e00718-22, [10.1128/msystems.00718-22](https://doi.org/10.1128/msystems.00718-22). `ground_truth/all_30_samples_ena.tsv` lists all 30 samples of the study.

Reference genome: RefSeq GCF_000005845.2 (*E. coli* K-12 MG1655), as in the source.

## Reference and pass criterion

The DEGs obtained with the source's criteria (|log2FC| > 2, padj < 0.05) from the authors' deposited count matrix (`GSE208658_Ec_count_matrix.txt.gz`), and the over-represented KEGG/GO terms of the source's Fig. 4 (`ground_truth/gse208658_expected_de_results.md`). Gene-level precision, recall, Jaccard, direction and log2FC correlation; term recovery.

## Configuration

`config/config.yaml` + `config/samples.tsv`. DEFINE stops at the annotated count table; DESeq2 and over-representation analysis ran in OmniOmics's pinned R environment.

## Result — partially met

Details in [`results/README.md`](results/README.md). 417 DEGs (10.0% of tested genes) vs. 590 reported; against the deposited matrix, precision 0.72, recall 0.53, Jaccard 0.44, 265 of 276 shared DEGs in the same direction; all 3 GO terms reported for this contrast recovered, none of the 3 KEGG pathways.

## Alpha test

The alpha test (September 2026) is kept unchanged in [`alpha_test/`](alpha_test/) (its `config/` and `results/`). It is superseded by the validation above.
