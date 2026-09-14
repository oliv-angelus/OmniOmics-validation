# PRISM -- expected result (ground truth), MSPlus rep1 (ONT, kit MAB114)

Source: Oxford Nanopore Technologies, official release `zymo_16s_2025.09`
(EPI2ME blog: https://epi2me.nanoporetech.com/zymo_16s_2025.09/,
public bucket `s3://ont-open-data/zymo_16s_2025.09`, no-sign-request).

## Identity confirmation of the downloaded file

`MSPlus_rep1_sup.bam` (downloaded to `validacao/v-prism/raw_reads/MSPLUS_REP1/`)
matches **byte-for-byte** (67,598,261 bytes) with
`zymo_16s_2025.09/basecalls/MSPlus/MAB114/sup/rep1/FBB32095_bam_pass_15aa3986_bbffde72_0.bam`
from the official bucket -- confirmed via a real S3 listing, 2026-09-12.
The BAM header confirms: dorado 1.1.1, model `sup@v5.2.0`, kit
`SQK-MAB114-24`, library `Zymo`. Converted to fastq.gz (`samtools fastq`,
53,011 reads, 0 discarded) and already wired into
`v-prism/config/samples.tsv`.

**"MSPlus"** = ZymoBIOMICS Microbial Community DNA Standard "even" (the
same 10 species as MAGMA's, see `../magma/`) **supplemented with 4 extra
species** (*Bifidobacterium adolescentis*, *Borrelia burgdorferi*,
*Chlamydia trachomatis*, *Gardnerella vaginalis*) -- a new community,
released by ONT itself in 2025 specifically to demonstrate the new kit's
(MAB114) resolution of previously poorly-resolved species.

## Ground truth used

**No certified theoretical composition has been published for this
specific 14-species community** -- unlike MAGMA's 10-species "even"
standard, which has manufacturer-certified percentages. Instead, the
ground truth here is the **official Emu result ONT itself published for
this exact same sample** (same BAM file, same replicate):
`zymo_16s_2025.09/analysis/emu/MSPlus/MAB114/rep1/`.

Files saved locally in this folder:
- `ONT_official_emu_MSPlus_MAB114_rep1_rel-abundance.tsv` -- relative
  abundance table per species (Emu), GTDB-style taxonomy.
- `ONT_official_emu_MSPlus_MAB114_rep1_classification.tsv` -- the same
  classification in `k__;p__;c__;o__;f__;g__;s__` lineage format.

## What to check against PRISM's real output

Compare `results/04_DENOISE/emu/.../rel-abundance.tsv` (or the final
`prism_abundance_table.tsv` table) from PRISM's real run against the TSVs
saved here -- **same sample, same method (Emu)**, so the expectation is
**very close** relative abundance (not identical -- PRISM uses the GTDB
SSU database for classification, ONT uses their own database for their
`wf16s`/emu workflow, so taxonomies can diverge in species nomenclature
even when genus/family match). Dominant species expected at the top
(check against the saved TSV): *Limosilactobacillus fermentum* (~13.5%),
*Bacillus_P spizizenii* (~14.7%), *Staphylococcus argenteus* (~14.5%),
*Enterococcus_H faecalis* (~9.5%) -- and real presence (not absence) of
the 4 supplemented species (*Bifidobacterium adolescentis* ~6.4%,
*Chlamydia trachomatis* ~1.9%, *Borrelia bissettiae* ~2.7%,
*Bifidobacterium vaginale*/formerly *Gardnerella vaginalis* ~8.5%) -- the
resolution of exactly these 4 is what the dataset was designed to
demonstrate.

**Nomenclature note**: the GTDB taxonomy ONT's own Emu run uses has
already renamed *Gardnerella vaginalis* -> *Bifidobacterium vaginale* --
so don't be surprised if the name doesn't literally match what the
manufacturer advertises as the "4 extra species"; it's the same
biological species.
