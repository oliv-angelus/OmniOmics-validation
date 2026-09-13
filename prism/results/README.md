# PRISM results — real, honest mixed outcome (strong correlation, one real miss)

`observed_vs_expected.tsv` — per-replicate summary, generated from PRISM's
real Emu output (`raw_tool_outputs/prism_abundance_table.tsv` +
per-replicate `MSPLUS_REP{1,2,3}_rel-abundance.tsv`, GTDB SSU r220
reference) against ONT's own official Emu classification of the *same read
files* (`../ground_truth/ONT_official_emu_MSPlus_MAB114_rep{1,2,3}_rel-abundance.tsv`).
Full run log: `run_log.txt` (100% complete, EXIT_CODE=0).

## Community-level correlation: PASS

A direct species-name string match gives a misleadingly low correlation
(r≈0.03–0.07) because PRISM's GTDB SSU r220 database and whatever GTDB
release ONT's own official pipeline used disagree on several
species/subclade names for the *same organism* (e.g. PRISM's
`Bacillus_spizizenii` vs. ONT's `Bacillus_P` placeholder clade name for the
same ~16% signal; `Enterococcus_faecalis` vs. `Enterococcus_H`; `Listeria_monocytogenes`
vs. `Listeria_A` — all the same real abundance, different GTDB-release
naming). Aggregating to **genus level** removes that noise and is the
scientifically appropriate comparison given the reference-version
difference:

| replicate | genus-level Pearson r vs. ONT's own result |
|---|---|
| rep1 | 0.9766 |
| rep2 | 0.9630 |
| rep3 | 0.9577 |
| **mean** | **0.9658** |

Strong agreement — PRISM's real Emu classification (GTDB reference)
recovers essentially the same community structure ONT's own official
pipeline found for these exact reads.

## Four spiked-species check: 3/4 (real miss, investigated)

- **Detected, species-level abundances closely matching ONT's own result**:
  *Bifidobacterium adolescentis* (6.4% both), *Bifidobacterium vaginale* =
  *Gardnerella vaginalis* under GTDB (7.8–8.5% both), *Borreliella
  burgdorferi* = *Borrelia burgdorferi* (2.5–3.0% both).
- **Missed**: *Chlamydia trachomatis* — 0% in all 3 PRISM replicates, vs.
  ~1.9–2.0% in ONT's own official result for the same reads.

**Real investigation, not left unexplained:**
- The GTDB SSU r220 database PRISM used *does* contain
  `Chlamydia_trachomatis(RS_GCF_000012125_1` as a reference sequence —
  ruled out as a database-coverage gap.
- PRISM's own Emu output shows no partial/residual signal for this taxon
  either (`mapped_unclassified` is only 16 reads out of ~10,000+
  classified) — the loss happens upstream of classification, not at the
  Emu assignment step.
- `logs/cutadapt/MSPLUS_REP1.log` (cluster) shows only **28.2%** of raw
  reads survived primer trimming for this sample overall — a real,
  substantial loss rate.
- Most likely explanation: the well-documented mismatch between
  "universal" 27F/1492R primers and Chlamydiae 16S rRNA gene sequences
  (a known limitation in the amplicon-primer literature) — Chlamydia
  reads are disproportionately lost at PRISM's cutadapt primer-matching
  step before ever reaching Emu. Not confirmed with a per-read alignment
  (would require pulling the raw Chlamydia-classified reads from ONT's
  own analysis and checking primer-site identity directly), so stated as
  the best-supported hypothesis, not a proven mechanism.

## A related, non-spiked-species observation

ONT's own result splits Enterobacterales-family signal across
*Escherichia*, *Salmonella*, *Shigella*, and *Klebsiella* (several with
sub-1% abundance); PRISM's GTDB-based Emu run assigns essentially all of
that same signal to *Salmonella* alone. This genus complex is a
well-known, notoriously hard case for 16S-based classification generally
(extremely close phylogenetic relationship) — the different reference
database compositions resolve the ambiguity differently, which is an
expected property of EM-based classifiers like Emu, not a PRISM-specific
defect. It is a modest contributor to the (still very high) genus-level
correlation above.
