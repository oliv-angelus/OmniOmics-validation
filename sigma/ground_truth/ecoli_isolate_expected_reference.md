# SIGMA -- resultado esperado (ground truth), isolado ERR2935852

Fonte: Nicholls SM et al. 2019, GigaScience 8(5):giz043.
DOI: [10.1093/gigascience/giz043](https://doi.org/10.1093/gigascience/giz043)
(PMC6520541) -- mesmo paper usado pro dataset do MAGMA (ver
`../magma/zymo_even_theoretical_composition.tsv`), reaproveitando a
mesma justificativa/citação, sem accession nova.

## Identidade confirmada

`ERR2935852` = leitura Illumina do isolado individual de ***Escherichia
coli*** da coleção ZymoBIOMICS -- cepa NRRL B-1109, sequence type **ST10**
(Tabela 1 do paper). Não tem accession ATCC listado no paper pra essa
cepa especificamente.

## Genoma de referência pra comparar a montagem

Zymo distribui os genomas de referência ("true genomes") oficiais dos 10
organismos do padrão em:
`https://s3.amazonaws.com/zymo-files/BioPool/ZymoBIOMICS.STD.refseq.v2.zip`
(confirmado acessível via HEAD request, 2026-09-12 -- mesmo pacote usado
por outros grupos pra validação, ex. tutorial do próprio DADA2/benjjneb
pra PacBio). **Ainda não baixado** -- baixar no cluster (não localmente)
antes de rodar o SIGMA de verdade, extrair só o FASTA do *E. coli*
B-1109/ST10 do zip.

## O que checar contra a saída real do SIGMA

- **QUAST/metaQUAST** (ou equivalente do SIGMA) da montagem do isolado
  contra o genoma de referência do *E. coli* B-1109 extraído do zip
  acima -- esperado: cobertura de genoma alta (>95%), poucos
  misassemblies, N50 próximo do tamanho do cromossomo (*E. coli* ~4,6-5,0
  Mb tipicamente monta em 1-poucos contigs com dado Illumina de boa
  cobertura).
- **GTDB-Tk**: taxonomia classificada deveria bater com *Escherichia coli*
  no nível de espécie.
- **CheckM2**: completude alta (>95%), contaminação baixa (<5%) -- é
  isolado puro, não MAG ambiental.

## Pendências

- Confirmar se `ERR2935852` tem par ONT/PacBio pra montagem híbrida
  (o Tool Paper Plan já registrava isso como "não resolvido ainda") --
  por enquanto `v-sigma/config/samples.tsv` está configurado
  `read_type: short` (só Illumina, via unicycler).
- Baixar e extrair a referência real antes do primeiro run real (hoje é
  só a URL confirmada, arquivo ainda não está no cluster).

## Atualização 2026-09-12 — ground truth long-read encontrado (ONT + PacBio)

Fonte: McIntyre AB, Alexander N, Grigorev K, et al. "Single-molecule
sequencing detection of N6-methyladenine in microbial reference
materials." Nat Commun. 2019;10(1):579.
DOI: [10.1038/s41467-019-08289-9](https://doi.org/10.1038/s41467-019-08289-9)
(BioProject `PRJNA477598`) — sequenciou o mesmo material de referência
Zymo (8 das 10 espécies) em múltiplas plataformas (Illumina/ONT/PacBio),
especificamente como dataset ortogonal para validar os mesmos padrões
usados por Nicholls et al. 2019.

**Amostras reais baixadas** (mesma cepa/material de referência *E. coli*
do isolado Illumina ERR2935852 -- mesmo material certificado Zymo, embora
sequenciado por outro grupo/lab; assunção razoável dado que ambos citam o
mesmo material de referência comercial, não confirmado como o mesmo tubo
físico):
- **ONT GridION** `SRR7415634` (232MB, ~2018, pré-química Q20+/SUP →
  `long_read_platform: nano_raw`, não `nano_hq`).
- **PacBio RS II (CLR)** `SRR8154675` (1,4GB subreads, plataforma CLR
  antiga, não HiFi → `long_read_platform: pacbio_raw`).

**Projetos de validação criados**:
- `v-sigma`: `ECOLI_SHORT_ONLY` (baseline só-Illumina) +
  `ECOLI_HYBRID_ONT` (Illumina+ONT, `long_read_platform: nano_raw`).
- `v-sigma-pacbio` (novo, sibling dir): `ECOLI_HYBRID_PACBIO`
  (Illumina+PacBio, `long_read_platform: pacbio_raw`) -- projeto
  separado porque `long_read_platform` é config de nível de projeto no
  SIGMA, não por amostra, então ONT e PacBio não podem coexistir no
  mesmo `config.yaml`.

**Ground truth pra comparar**: montagem híbrida de cada projeto deveria
bater com o mesmo genoma de referência (`ZymoBIOMICS.STD.refseq.v2.zip`,
ver acima) E deveria ter qualidade de montagem **melhor** que o
`ECOLI_SHORT_ONLY` (menos contigs, N50 maior, menos misassemblies) --
essa comparação de 3 vias (short-only vs hybrid-ONT vs hybrid-PacBio) é
justamente o que demonstra o valor real do polimento com leitura longa
do SIGMA, não só "roda sem erro".
