# DEFINE -- expected result (ground truth), GSE208658

Source: paper associated with GEO `GSE208658` -- "Global Transcriptional
Response of Escherichia coli Exposed In Situ to Different Low-Dose
Ionizing Radiation Sources". mSystems.
DOI: [10.1128/msystems.00718-22](https://doi.org/10.1128/msystems.00718-22)
(PMID 36779725, PMC10134817)

*E. coli* DH10β exposed in situ to 3 radiation sources (²³⁹Pu, ³H, ⁵⁵Fe) +
controls, 2 exposure durations (1 day / 15 days).

## Samples downloaded for the `v-define` project

`CTRL_D1_R1/R2/R3` (non-irradiated control, day 1) vs. `PU239_D1_R1/R2/R3`
(²³⁹Pu-exposed, day 1), 3 replicates per condition -- corresponds exactly
to the "day 1" contrast reported in the paper (not the day-15 one). (Note:
an earlier version of this document described 1 replicate per condition
-- the real, executed decision was 3 replicates per condition, following
the SARTools field precedent cited below.)

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

## What to check against DEFINE's real output

Run `CTRL_D1_R1/R2/R3` as the control group and `PU239_D1_R1/R2/R3` as
the test group in DESeq2 (downstream of the count matrix DEFINE
generates -- the pipeline does not run DESeq2 internally, see
`../results/README.md`) -- **check**: (1) the order of magnitude of the
significant-DEG count should land in the hundreds (not tens, not
thousands) to match the ~590/13.8% reported; (2) GO/pathway terms of the
upregulated genes should concentrate on ABC transport, siderophores, and
stress response -- not random processes unrelated to stress/radiation.

**Real limitation**: no individually published, accessible DEG gene list
exists for this study (it would be in the paper's supplementary table,
not extracted here) -- the comparison stays at the magnitude/functional-
category level, not gene-by-gene. For an exact comparison, the mSystems
supplementary table would need to be downloaded directly (not attempted
yet).

## Real result obtained

See `../results/README.md` for the full analysis, including a real
correction made mid-process: the first attempt (padj<0.05 only) gave
2,720 DEGs -- far above expected -- and the first explanatory hypothesis
(one control replicate with a low featureCounts assignment rate) was
**tested and disproven** (removing it increased the DEG count, not
decreased it). The real cause, confirmed against the paper's exact
method: the correct criterion is padj<0.05 **AND** log2FC>2, not padj
alone. Applying the correct criterion: **(1) PASSED: 433 real DEGs (9.9%
of tested genes) vs. ~590/13.8% expected, same order of magnitude; (2)
PASSED: the significant genes' functional categories match those
reported in the paper (ABC transporters, siderophores, stress response,
amino acid biosynthesis).**
