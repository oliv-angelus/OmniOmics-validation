# DOGMA -- expected result (ground truth), Chuckran et al. 2021

Source: Chuckran PF, Reibold R, Throckmorton HM, Meredith LK, Dijkstra P (2021).
"Rapid Response of Nitrogen Cycling Gene Transcription to Labile Carbon
Amendments in a Soil Microbial Community." mSystems 6(3):e00161-21.
DOI: [10.1128/mSystems.00161-21](https://doi.org/10.1128/mSystems.00161-21)
(PMID 33975966, PMC8125072)

Ground truth here = the **direction of the effect** reported in the
paper's text (t0 = before glucose addition, t8 = 8h after), not an exact
composition/count -- the same framing already logged in
`OmniOmics Tool Paper Plan.md`. The samples downloaded for the `v-dogma`
project (`C0R1`=SRR10849656, `C0R2`=SRR10904363, `C8R1`=SRR10849655,
`C8R2`=SRR10849401) correspond exactly to t0 and t8, 2 replicates each
(see `../README.md`'s "Sample size" section for why 2, not the paper's
full 4).

## What should go up (upregulated) at t8 vs t0

- **`amtB` (ammonium transporter)**: FDR<0.01, peaks at t8, **16x higher**
  than t0 (41,366 transcripts at t8 vs. 2,539 at t0).
- **GS-GOGAT N-assimilation pathway** (`glnA`, `gltS`, `gltD`, `gltB`):
  upregulated (FDR<0.01), peaking at 8h.
- **N regulatory network**: `glnD` (uridylyltransferase, LFC 2.18-4.31,
  FDR<0.01); `glnB`/`glnK` (PII proteins) and NtrC-family genes
  (LFC>2.9 and >3.9, FDR<0.01).
- **Assimilatory nitrate reduction**: strongly upregulated at t8,
  remaining so through 48h.

## What should go down (downregulated) at t8 vs t0

- **All nitrification genes**: downregulated in response to glucose.
- **Most denitrification genes**: downregulated throughout the
  incubation.
- **`crp` and `rpoN`** (transcriptional regulators): slightly
  downregulated (LFC<-1) at t8 and t24 (FDR<0.01).

## General pattern to check against DOGMA's real output

Glucose should rapidly trigger inorganic-N acquisition/assimilation
machinery while suppressing the dissimilatory N cycle
(nitrification/denitrification). **Check**: in DOGMA's results
(`results/.../deseq2` or equivalent, C8 vs. C0 comparison), ammonium/
nitrate transport and GS-GOGAT pathway genes should show a positive,
significant log2FoldChange; nitrification/denitrification genes should
show a negative one.

**Real limit of this validation**: only 2 replicates per timepoint were
downloaded (not the paper's full 4 replicates x 4 timepoints design) --
enough to check the *direction* of the effect, not to reproduce the
paper's exact statistical magnitude (which uses the full replicate
design). See `OmniOmics Tool Paper Plan.md`, DOGMA's row, for the full
sample table if this is expanded later.
