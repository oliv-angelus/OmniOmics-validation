# DOGMA -- expected result (ground truth), Chuckran et al. 2021

Source: Chuckran PF, Reibold R, Throckmorton HM, Meredith LK, Dijkstra P (2021).
"Rapid Response of Nitrogen Cycling Gene Transcription to Labile Carbon
Amendments in a Soil Microbial Community." mSystems 6(3):e00161-21.
DOI: [10.1128/mSystems.00161-21](https://doi.org/10.1128/mSystems.00161-21)
(PMID 33975966, PMC8125072)

Ground truth here = the **direction and significance of the effect**
reported in the paper's text (t0 = before glucose addition, t8 = 8 h
after; FDR < 0.01 after removing features with < 60 summed reads), not
an exact composition or count. The validation uses the study's 4
replicates per time point (see `../README.md` for the run accessions).
The 14 targets checked are the items listed below: amtB, glnA, gltS,
gltD, gltB, glnD, glnB, glnK, the NtrC family, assimilatory nitrate
reduction, nitrification, denitrification, crp and rpoN.

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
(t8 vs. t0; see `../results/README.md`), ammonium/
nitrate transport and GS-GOGAT pathway genes should show a positive,
significant log2FoldChange; nitrification/denitrification genes should
show a negative one.
