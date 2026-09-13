# DEFINE -- resultado esperado (ground truth), GSE208658

Fonte: paper associado ao GEO `GSE208658` -- "Global Transcriptional
Response of Escherichia coli Exposed In Situ to Different Low-Dose
Ionizing Radiation Sources". mSystems.
DOI: [10.1128/msystems.00718-22](https://doi.org/10.1128/msystems.00718-22)
(PMID 36779725, PMC10134817)

*E. coli* DH10β exposto in situ a 3 fontes de radiação (²³⁹Pu, ³H, ⁵⁵Fe) +
controles, 2 durações de exposição (1 dia / 15 dias).

## Amostras baixadas pro projeto `v-define`

`CTRL_D1_R1/R2/R3` (controle não-irradiado, 1 dia) vs `PU239_D1_R1/R2/R3`
(exposto a ²³⁹Pu, 1 dia), 3 réplicas por condição -- corresponde exatamente
ao contraste "1 dia" reportado no paper (não o de 15 dias). (Nota: uma
versão anterior deste documento descrevia 1 réplica por condição -- a
decisão real, executada, foi 3 réplicas por condição, seguindo o
precedente de campo do SARTools citado abaixo.)

## Resultado esperado, contraste ²³⁹Pu vs controle em 1 dia

- **590 genes diferencialmente expressos** (13,8% do total de CDS
  anotadas) -- número absoluto reportado no paper pra esse contraste
  específico (1 dia). Pro contraste de 15 dias o efeito praticamente
  desaparece (11 DEGs, 0,3%) -- **não é o par baixado aqui**, mas serve
  de controle de sanidade caso expandamos a validação depois (esperar
  quase nenhuma DEG num contraste ²³⁹Pu D15 vs controle D15).
- **Categorias funcionais esperadas entre os DEGs** (não uma lista de
  genes exata, o paper reporta por categoria funcional/pathway):
  - Biossíntese: componentes do envelope nuclear (sic -- terminologia do
    paper), aminoácidos, sideróforos.
  - Sistemas de transporte: transportadores ABC, proteínas de secreção
    tipo II.
  - Resposta a estresse/regulação: choque térmico, regulon RpoS,
    estresse oxidativo.

## O que checar contra a saída real do DEFINE

Rodar `CTRL_D1_R1/R2/R3` como grupo controle e `PU239_D1_R1/R2/R3` como
grupo teste no DESeq2 (downstream do count matrix que o DEFINE gera --
o pipeline não roda DESeq2 internamente, ver `../results/README.md`) --
**conferir**: (1) ordem de grandeza do número de DEGs significativos
deveria ficar na faixa de centenas (não dezenas, não milhares) pra bater
com os ~590/13,8% reportados; (2) termos GO/pathway dos genes
upregulados deveriam concentrar em transporte ABC, sideróforos e
resposta a estresse -- não em processos aleatórios sem relação com
estresse/radiação.

**Limite real**: sem lista de genes DEG individual publicada de forma
acessível nesta pesquisa (ficaria na tabela suplementar do paper, não
extraída aqui) -- a comparação fica no nível de magnitude/categoria
funcional, não gene-a-gene. Se quisermos comparação exata, precisa
baixar a tabela suplementar do mSystems diretamente (não tentado ainda).

## Resultado real obtido

Ver `../results/README.md` -- (1) FALHOU: 2.720 DEGs reais (62,2% dos genes
testados) vs. ~590 esperados, causa técnica real identificada (uma das 3
réplicas do controle, `CTRL_D1_R1`, é um outlier real de qualidade de
biblioteca); (2) PASSOU: as categorias funcionais dos genes significativos
batem com as reportadas no paper (transportadores ABC, sideróforos,
resposta a estresse).
