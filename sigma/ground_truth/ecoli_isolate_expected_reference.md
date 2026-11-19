# SIGMA -- expected result (ground truth), E. coli NRRL B-1109

## Isolate

The *Escherichia coli* isolate of the ZymoBIOMICS Microbial Community
Standard: strain NRRL B-1109, sequence type ST10 (Nicholls SM et al.
2019, *GigaScience* 8:giz043, Table 1,
[10.1093/gigascience/giz043](https://doi.org/10.1093/gigascience/giz043)).

Reads of this isolate:

- Illumina `ERR2935852` (Nicholls et al. 2019)
- Oxford Nanopore GridION R9.5 `SRR7415634` and PacBio RS II CLR
  `SRR7498041` (McIntyre ABR et al. 2019, *Nat Commun* 10:579,
  [10.1038/s41467-019-08289-9](https://doi.org/10.1038/s41467-019-08289-9);
  BioProject PRJNA477598)

## Reference genome

Zymo's reference genomes for the standard:
`https://s3.amazonaws.com/zymo-files/BioPool/ZymoBIOMICS.STD.refseq.v2.zip`,
file `Genomes/Escherichia_coli_complete_genome.fasta` (4,875,441 bp:
chromosome + plasmid).

## What is checked

- **QUAST** of each assembly against this reference: contigs, N50,
  NGA50, genome fraction, extensive and local misassemblies, mismatches
  and indels per 100 kbp. Hybrid assemblies (Illumina + ONT, Illumina +
  PacBio) compared with the short-only assembly.
- **Read identity** of the ONT and PacBio reads against the reference,
  (L - NM)/L of primary minimap2 alignments, as in Nicholls et al. 2019.
- **GTDB-Tk** species call (*Escherichia coli*) and **CheckM2**
  completeness/contamination of each assembly.
