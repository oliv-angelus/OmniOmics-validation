# SIGMA validation

**Dataset**: the *E. coli* isolate of the ZymoBIOMICS standard (strain NRRL B-1109, ST10), sequenced on three platforms:

- Illumina: `ERR2935852` (Nicholls et al. 2019, [10.1093/gigascience/giz043](https://doi.org/10.1093/gigascience/giz043))
- Oxford Nanopore GridION, R9.5: `SRR7415634`
- PacBio RS II CLR subreads: `SRR7498041`

ONT/PacBio source: McIntyre ABR et al. 2019, *Nat Commun* 10:579, [10.1038/s41467-019-08289-9](https://doi.org/10.1038/s41467-019-08289-9) (BioProject `PRJNA477598`). The PacBio subreads share read IDs within a ZMW; they were renamed to unique IDs before use (`*_subreads.uniqnames.fastq.gz`), sequences unchanged.

Three assemblies of the same isolate:

1. `ECOLI_SHORT_ONLY` — Illumina only (`config/ont/`)
2. `ECOLI_HYBRID_ONT` — Illumina + ONT (`config/ont/`)
3. `ECOLI_HYBRID_PACBIO` — Illumina + PacBio (`config/pacbio/`; `long_read_platform` is a project-level setting, so ONT and PacBio need separate configs)

Hybrid assemblies: Unicycler, then Polypolish and Pypolca with the Illumina reads.

## Reference and pass criterion

Zymo's reference genome for the isolate (`ZymoBIOMICS.STD.refseq.v2`, *E. coli* complete genome, 4,875,441 bp; `ground_truth/ecoli_isolate_expected_reference.md`). QUAST: contigs, N50, NGA50, genome fraction, misassemblies, mismatches and indels per 100 kbp; hybrid vs. short-only.

## Result — met

Details in [`results/README.md`](results/README.md). Both hybrids: 2 circular contigs (chromosome + 110 kb plasmid), NGA50 4.77 Mb, 100.000% genome fraction, 0 misassemblies, ~11 mismatches per 100 kbp; short-only: 87 contigs, 97.78%, 0 misassemblies, 6.06 mismatches per 100 kbp. Read identity against the reference (median): ONT 88.1%, PacBio 85.0%.

## Alpha test

The alpha test (September 2026) is kept unchanged in [`alpha_test/`](alpha_test/) (its `config/` and `results/`). It is superseded by the validation above.
