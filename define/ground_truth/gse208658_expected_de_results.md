# DEFINE -- resultado esperado (ground truth), GSE208658

Fonte: paper associado ao GEO `GSE208658` -- "Global Transcriptional
Response of Escherichia coli Exposed In Situ to Different Low-Dose
Ionizing Radiation Sources". mSystems.
DOI: [10.1128/msystems.00718-22](https://doi.org/10.1128/msystems.00718-22)
(PMID 36779725, PMC10134817)

*E. coli* DH10β exposto in situ a 3 fontes de radiação (²³⁹Pu, ³H, ⁵⁵Fe) +
controles, 2 durações de exposição (1 dia / 15 dias).

## Amostras baixadas pro projeto `v-define`

`CTRL_D1_R1` (SRR20326901, controle não-irradiado, 1 dia) vs
`PU239_D1_R1` (SRR20326895, exposto a ²³⁹Pu, 1 dia) -- corresponde
exatamente ao contraste "1 dia" reportado no paper (não o de 15 dias).

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

Rodar `CTRL_D1_R1` como referência e `PU239_D1_R1` como grupo teste no
DESeq2 do DEFINE -- **conferir**: (1) ordem de grandeza do número de
DEGs significativos deveria ficar na faixa de centenas (não dezenas,
não milhares) pra bater com os ~590/13,8% reportados (composição
diferente da amostragem original limita comparação exata: paper usa
réplicas biológicas, aqui é 1 vs 1); (2) termos GO/pathway dos genes
upregulados deveriam concentrar em transporte ABC, sideróforos e
resposta a estresse -- não em processos aleatórios sem relação com
estresse/radiação.

**Limite real**: sem lista de genes DEG individual publicada de forma
acessível nesta pesquisa (ficaria na tabela suplementar do paper, não
extraída aqui) -- a comparação fica no nível de magnitude/categoria
funcional, não gene-a-gene. Se quisermos comparação exata, precisa
baixar a tabela suplementar do mSystems diretamente (não tentado ainda).
