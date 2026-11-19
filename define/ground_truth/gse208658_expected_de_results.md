# DEFINE -- expected result (ground truth), GSE208658

Source: paper associated with GEO `GSE208658` -- "Global Transcriptional
Response of Escherichia coli Exposed In Situ to Different Low-Dose
Ionizing Radiation Sources". mSystems.
DOI: [10.1128/msystems.00718-22](https://doi.org/10.1128/msystems.00718-22)
(PMID 36779725, PMC10134817)

*E. coli* DH10β exposed in situ to 3 radiation sources (²³⁹Pu, ³H, ⁵⁵Fe) +
controls, 2 exposure durations (1 day / 15 days).

## Samples used

`CTRL_D1_R1/R2/R3` (non-irradiated control, day 1) vs. `PU239_D1_R1/R2/R3`
(²³⁹Pu-exposed, day 1), 3 replicates per condition -- the "day 1"
contrast reported in the paper.

## Expected result, ²³⁹Pu vs. control contrast at day 1

- **590 differentially expressed genes** (13.8% of annotated CDSs) --
  the absolute number reported in the paper for this specific (day 1)
  contrast. For the day-15 contrast the effect nearly disappears (11
  DEGs, 0.3%) -- **not the pair downloaded here**, but a useful sanity
  check if this validation is expanded later (expect almost no DEGs in a
  ²³⁹Pu D15 vs. control D15 contrast).
- **The paper's exact DEG criterion** (confirmed in the article's text,
  Wintenberg et al. 2023): DESeq2 v1.35.0, HISAT2 alignment + StringTie/
  tximport quantification (a different pipeline from DEFINE's
  bowtie2+featureCounts), a gene is called differentially expressed with
  **log2FoldChange > 2 (4x) AND adjusted p-value (Wald) < 0.05** -- not
  padj<0.05 alone. This matters: applying padj<0.05 only (without the
  fold-change cutoff) is not the same criterion as the paper's and should
  not be compared directly to the 590 figure.
- **Expected functional categories among the DEGs** (not an exact gene
  list, the paper reports by functional category/pathway):
  - Biosynthesis: envelope components (sic -- the paper's own
    terminology), amino acids, siderophores.
  - Transport systems: ABC transporters, type II secretion proteins.
  - Stress response/regulation: heat shock, the RpoS regulon, oxidative
    stress.

## Gene-level reference

The authors deposited their count matrix as a GEO supplementary file
(`GSE208658_Ec_count_matrix.txt.gz`). The validation applies the source's
criterion (DESeq2, |log2FC| > 2 and padj < 0.05) to that matrix and
compares DEFINE's DEGs with the result gene by gene (precision, recall,
Jaccard, direction, log2FC correlation). Over-represented terms are
compared with the source's Fig. 4 (GO: respiratory chain complex I,
respirasome, NADH dehydrogenase (quinone) activity; three KEGG
pathways). See `../results/README.md`.
