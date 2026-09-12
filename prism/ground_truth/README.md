# PRISM -- resultado esperado (ground truth), MSPlus rep1 (ONT, kit MAB114)

Fonte: Oxford Nanopore Technologies, release oficial `zymo_16s_2025.09`
(EPI2ME blog: https://epi2me.nanoporetech.com/zymo_16s_2025.09/,
bucket público `s3://ont-open-data/zymo_16s_2025.09`, sem sign-request).

## Confirmação de identidade do arquivo baixado

`MSPlus_rep1_sup.bam` (baixado em `validacao/v-prism/raw_reads/MSPLUS_REP1/`)
bate **byte-a-byte** (67.598.261 bytes) com
`zymo_16s_2025.09/basecalls/MSPlus/MAB114/sup/rep1/FBB32095_bam_pass_15aa3986_bbffde72_0.bam`
do bucket oficial -- confirmado via listagem S3 real, 2026-09-12. Header do
BAM confirma: dorado 1.1.1, modelo `sup@v5.2.0`, kit `SQK-MAB114-24`,
biblioteca `Zymo`. Convertido pra fastq.gz (`samtools fastq`, 53.011 reads,
0 descartados) e já wireado em `v-prism/config/samples.tsv`.

**"MSPlus"** = ZymoBIOMICS Microbial Community DNA Standard "even"
(mesmas 10 espécies do MAGMA, ver `../magma/`) **suplementada com 4
espécies extras** (*Bifidobacterium adolescentis*, *Borrelia burgdorferi*,
*Chlamydia trachomatis*, *Gardnerella vaginalis*) -- comunidade nova,
lançada pela própria ONT em 2025 especificamente pra demonstrar a
resolução do kit novo (MAB114) contra espécies antes mal-resolvidas.

## Ground truth usado

**Não existe uma composição teórica certificada publicada pra essa
comunidade específica (14 espécies)** -- diferente da "even" de 10
espécies do MAGMA, que tem % certificada pelo fabricante. Em vez disso,
o ground truth aqui é o **resultado oficial de Emu que a própria ONT
publicou pra essa mesma amostra exata** (mesmo arquivo BAM, mesma
réplica): `zymo_16s_2025.09/analysis/emu/MSPlus/MAB114/rep1/`.

Arquivos salvos localmente nesta pasta:
- `ONT_official_emu_MSPlus_MAB114_rep1_rel-abundance.tsv` -- tabela de
  abundância relativa por espécie (Emu), taxonomia GTDB-style.
- `ONT_official_emu_MSPlus_MAB114_rep1_classification.tsv` -- mesma
  classificação em formato de linhagem `k__;p__;c__;o__;f__;g__;s__`.

## O que checar contra a saída real do PRISM

Comparar `results/04_DENOISE/emu/.../rel-abundance.tsv` (ou a tabela
final `prism_abundance_table.tsv`) do run real do PRISM contra os TSVs
salvos aqui -- **mesma amostra, mesmo método (Emu)**, então a expectativa
é abundância relativa **muito próxima** (não idêntica -- o PRISM usa o
banco GTDB SSU pra classificar, ONT usa o banco próprio deles pro
workflow `wf16s`/emu deles, taxonomias podem divergir em nomenclatura de
espécie mesmo quando o gênero/família batem). Species dominantes
esperadas no top (conferir contra o TSV salvo): *Limosilactobacillus
fermentum* (~13,5%), *Bacillus_P spizizenii* (~14,7%), *Staphylococcus
argenteus* (~14,5%), *Enterococcus_H faecalis* (~9,5%) -- e presença
real (não ausência) das 4 espécies suplementadas (*Bifidobacterium
adolescentis* ~6,4%, *Chlamydia trachomatis* ~1,9%, *Borrelia bissettiae*
~2,7%, *Bifidobacterium vaginale*/antiga *Gardnerella vaginalis* ~8,5%)
-- é justamente a resolução dessas 4 que o dataset foi desenhado pra
demonstrar.

**Nota de nomenclatura**: a taxonomia GTDB usada pelo Emu da ONT já
renomeou *Gardnerella vaginalis* -> *Bifidobacterium vaginale* -- então
não estranhar se o nome não bater literalmente com o que o fabricante
anuncia como "4 espécies extras"; é a mesma espécie biológica.
