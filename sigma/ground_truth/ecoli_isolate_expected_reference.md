# SIGMA -- expected result (ground truth), isolate ERR2935852

Source: Nicholls SM et al. 2019, GigaScience 8(5):giz043.
DOI: [10.1093/gigascience/giz043](https://doi.org/10.1093/gigascience/giz043)
(PMC6520541) -- same paper used for MAGMA's dataset (see
`../magma/zymo_even_theoretical_composition.tsv`), reusing the same
justification/citation, no new accession.

## Confirmed identity

`ERR2935852` = Illumina read of the individual ***Escherichia coli***
isolate from the ZymoBIOMICS collection -- strain NRRL B-1109, sequence
type **ST10** (paper's Table 1). No ATCC accession is listed in the paper
for this specific strain.

## Reference genome for comparing the assembly

Zymo distributes the official reference genomes ("true genomes") for the
10 organisms in the standard at:
`https://s3.amazonaws.com/zymo-files/BioPool/ZymoBIOMICS.STD.refseq.v2.zip`
(confirmed reachable via HEAD request, 2026-09-12 -- the same package
used by other groups for validation, e.g. DADA2/benjjneb's own PacBio
tutorial). **Not yet downloaded** -- download it on the cluster (not
locally) before running SIGMA for real, extract just the *E. coli*
B-1109/ST10 FASTA from the zip.

## What to check against SIGMA's real output

- **QUAST/metaQUAST** (or SIGMA's equivalent) of the isolate's assembly
  against the *E. coli* B-1109 reference genome extracted from the zip
  above -- expected: high genome coverage (>95%), few misassemblies, N50
  close to chromosome size (*E. coli* ~4.6-5.0 Mb typically assembles into
  1-few contigs with good-coverage Illumina data).
- **GTDB-Tk**: the classified taxonomy should match *Escherichia coli* at
  species level.
- **CheckM2**: high completeness (>95%), low contamination (<5%) -- this
  is a pure isolate, not an environmental MAG.

## Open items

- Confirm whether `ERR2935852` has an ONT/PacBio mate for hybrid assembly
  (the Tool Paper Plan already logged this as "not yet resolved") -- for
  now `v-sigma/config/samples.tsv` is configured with `read_type: short`
  (Illumina only, via Unicycler).
- Download and extract the real reference before the first real run
  (as of writing only the URL is confirmed, the file is not yet on the
  cluster).

## Update 2026-09-12 -- long-read ground truth found (ONT + PacBio)

Source: McIntyre AB, Alexander N, Grigorev K, et al. "Single-molecule
sequencing detection of N6-methyladenine in microbial reference
materials." Nat Commun. 2019;10(1):579.
DOI: [10.1038/s41467-019-08289-9](https://doi.org/10.1038/s41467-019-08289-9)
(BioProject `PRJNA477598`) -- sequenced the same Zymo reference material
(8 of the 10 species) on multiple platforms (Illumina/ONT/PacBio),
specifically as an orthogonal dataset to validate the same standard used
by Nicholls et al. 2019.

**Real samples downloaded** (same strain/reference material as the
Illumina isolate ERR2935852 -- same certified Zymo material, though
sequenced by a different group/lab; a reasonable assumption given both
cite the same commercial reference material, not confirmed to be the same
physical tube):
- **ONT GridION** `SRR7415634` (232MB, ~2018, pre-Q20+/SUP chemistry →
  `long_read_platform: nano_raw`, not `nano_hq`).
- **PacBio RS II (CLR)** `SRR8154675` (1.4GB subreads, older CLR platform,
  not HiFi → `long_read_platform: pacbio_raw`).

**Validation projects created**:
- `v-sigma`: `ECOLI_SHORT_ONLY` (Illumina-only baseline) +
  `ECOLI_HYBRID_ONT` (Illumina+ONT, `long_read_platform: nano_raw`).
- `v-sigma-pacbio` (new, sibling dir): `ECOLI_HYBRID_PACBIO`
  (Illumina+PacBio, `long_read_platform: pacbio_raw`) -- a separate
  project because `long_read_platform` is a project-level setting in
  SIGMA, not per-sample, so ONT and PacBio can't coexist in the same
  `config.yaml`.

**Ground truth for comparison**: each project's hybrid assembly should
match the same reference genome (`ZymoBIOMICS.STD.refseq.v2.zip`, see
above) AND should have **better** assembly quality than `ECOLI_SHORT_ONLY`
(fewer contigs, higher N50, fewer misassemblies) -- this three-way
comparison (short-only vs. hybrid-ONT vs. hybrid-PacBio) is exactly what
demonstrates SIGMA's real value from long-read polishing, not just
"runs without error."

## Update 2026-09-12 -- both "Open items" above resolved

The reference genome zip was downloaded and extracted on the cluster,
and all three real runs (`ECOLI_SHORT_ONLY`, `ECOLI_HYBRID_ONT`,
`ECOLI_HYBRID_PACBIO`) completed. See `../README.md`'s "Results"
section for the real QUAST/CheckM2/GTDB-Tk output and
`../results/observed_vs_expected.tsv` for the generated comparison
table. This note is left in place, rather than rewritten, as an honest
record of the validation's actual sequence (plan the check, then run
it for real), matching the rest of this repository's documentation
style.
