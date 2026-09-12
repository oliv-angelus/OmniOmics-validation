# DOGMA -- resultado esperado (ground truth), Chuckran et al. 2021

Fonte: Chuckran PF, Reibold R, Throckmorton HM, Meredith LK, Dijkstra P (2021).
"Rapid Response of Nitrogen Cycling Gene Transcription to Labile Carbon
Amendments in a Soil Microbial Community." mSystems 6(3):e00161-21.
DOI: [10.1128/mSystems.00161-21](https://doi.org/10.1128/mSystems.00161-21)
(PMID 33975966, PMC8125072)

Verdade de referência aqui = **direção do efeito** reportada no texto do
paper (t0 = antes da adição de glicose, t8 = 8h depois), não uma
composição/contagem exata -- é o mesmo enquadramento já registrado em
`OmniOmics Tool Paper Plan.md`. As amostras baixadas pro projeto
`v-dogma` (`C0R1`=SRR10849656, `C8R2`=SRR10849401) correspondem
exatamente a t0 e t8.

## O que deveria subir (upregulated) em t8 vs t0

- **`amtB` (transportador de amônio)**: FDR<0.01, pico em t8, **16x maior**
  que t0 (41.366 transcritos em t8 vs 2.539 em t0).
- **Via GS-GOGAT de assimilação de N** (`glnA`, `gltS`, `gltD`, `gltB`):
  upregulados (FDR<0.01), pico em 8h.
- **Rede regulatória de N**: `glnD` (uridililtransferase, LFC 2.18-4.31,
  FDR<0.01); `glnB`/`glnK` (proteínas PII) e genes da família NtrC
  (LFC>2.9 e >3.9, FDR<0.01).
- **Redução assimilatória de nitrato**: fortemente upregulada em t8,
  mantendo-se assim até 48h.

## O que deveria cair (downregulated) em t8 vs t0

- **Todos os genes de nitrificação**: downregulados em resposta à glicose.
- **Maioria dos genes de desnitrificação**: downregulados ao longo da
  incubação inteira.
- **`crp` e `rpoN`** (reguladores transcricionais): levemente
  downregulados (LFC<-1) em t8 e t24 (FDR<0.01).

## Padrão geral a conferir contra a saída real do DOGMA

Glicose deveria disparar rapidamente a maquinaria de aquisição/assimilação
de N inorgânico, ao mesmo tempo suprimindo o ciclo dissimilatório de N
(nitrificação/desnitrificação). **Checar**: nos resultados do DOGMA
(`results/.../deseq2` ou equivalente, comparação C8R2 vs C0R1), os genes
de transporte de amônio/nitrato e via GS-GOGAT devem aparecer com
log2FoldChange positivo e significativo; genes de nitrificação/
desnitrificação com log2FoldChange negativo.

**Limite real desta validação**: só 1 réplica por timepoint foi baixada
(C0R1/C8R2), não o desenho completo de 4 réplicas x 4 timepoints do
paper -- suficiente pra checar a *direção* do efeito, não pra reproduzir
a magnitude estatística exata do paper (que usa réplicas de verdade).
Ver `OmniOmics Tool Paper Plan.md`, linha do DOGMA, pra tabela completa
de amostras se quisermos expandir depois.
