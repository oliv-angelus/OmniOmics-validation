# PRISM -- reference data, MSPlus (ONT, kit SQK-MAB114.24), replicates 1-3

Source: Oxford Nanopore Technologies, official release `zymo_16s_2025.09`
(EPI2ME blog: https://epi2me.nanoporetech.com/zymo_16s_2025.09/,
public bucket `s3://ont-open-data/zymo_16s_2025.09`, no-sign-request).

## Identity confirmation of the downloaded file

Each replicate's BAM (`basecalls/MSPlus/MAB114/sup/rep{1,2,3}/`) was
checked byte-for-byte against the official bucket (rep1:
`FBB32095_bam_pass_15aa3986_bbffde72_0.bam`, 67,598,261 bytes). BAM
header: dorado 1.1.1, model `sup@v5.2.0`, kit `SQK-MAB114-24`. Converted
to FASTQ with `samtools fastq` (rep1: 53,011 reads, 0 discarded).

**"MSPlus"** = ZymoBIOMICS Microbial Community DNA Standard "even" (the
same 10 species as MAGMA's, see `../magma/`) **supplemented with 4 extra
species** (*Bifidobacterium adolescentis*, *Borrelia burgdorferi*,
*Chlamydia trachomatis*, *Gardnerella vaginalis*) -- a new community,
released by ONT itself in 2025 specifically to demonstrate the new kit's
(MAB114) resolution of previously poorly-resolved species.

## Reference used

1. **Expected composition of the standard.** The 8 bacteria of the
   ZymoBIOMICS standard have a manufacturer's theoretical 16S
   composition; the 4 added species are checked for presence.
2. **The vendor's own Emu classification of the same reads**, published
   in the same release (`analysis/emu/MSPlus/MAB114/rep{1,2,3}/`), saved
   here as `ONT_official_emu_MSPlus_MAB114_rep{1,2,3}_{rel-abundance,classification}.tsv`.
   It is a **reference classification**, not a ground truth: agreement
   with it measures agreement between classifications, not accuracy.
   The between-replicate Bray-Curtis of the vendor's own results is used
   as the scale for that agreement.

The vendor's classification uses GTDB-style names: *Gardnerella
vaginalis* appears as *Bifidobacterium vaginale*, *Borrelia burgdorferi*
as *Borreliella*/*Borrelia bissettiae*, *B. subtilis* as *Bacillus_P
spizizenii*. Comparisons are made per target organism, not per name.
