# Mapeamento de Elementos - Site The Internet

|   Nome do Elemento    |   Tipo de Elemento    |   Seletor    |    Texto visível   |   Observações     |
|-----------------------|-----------------------|--------------|--------------------|-------------------|
|BTN_AZUL               |Button                 |[class="button"]|N/A               |Texto dinâmico                |
|BTN_VERMELHO           |Button                 |[class="button alert"]|N/A         |Texto Dinâmico                |
|BTN_VERDE              |Button                 |[Class="button success"]|N/A       |Texto Dinâmico     |
|TABELA                 |Table                  |//div[contains(@class, "large-10")]|N/A|               |
|TBL_EDIT               |a                      |//table//tbody/tr[1]/td[last()]/a[1]|Edit|             |
|TBL_DELETE             |a                      |//table//tbody/tr[1]/td[last()]/a[2]|Delete|           |
|TBL_HEADER             |thead                  |table > thead|N/A                  |                   |
|TBL_BODY               |tbody                  |table > thead|N/A                  |                   |
|TBL_LINHA              |tr                     |//table//tbody//tr|N/A             |                   |

---

```
✅ Resumo da Estratégia de Mapeamento
A equipe utilizou uma abordagem colaborativa e sistemática para mapear os elementos da página Challenging DOM. O mapeamento foi feito com base em três critérios principais:

Identificação do Tipo de Elemento (ex: botão, tabela, linha, cabeçalho).

Seletores específicos para garantir precisão na automação, utilizando XPath e seletores CSS conforme a estrutura do HTML.

Divisão de tarefas entre os membros da equipe, permitindo foco e produtividade em cada grupo de elementos.

Estratégias específicas:
Para os botões, foram utilizados seletores CSS baseados em classes, observando que o texto visível nesses botões é dinâmico, o que exige cuidado na automação.

Os elementos da tabela foram mapeados com XPath e seletores diretos (ex: thead, tbody), visando facilitar ações como leitura, edição e exclusão de registros.

Foi considerada a estrutura hierárquica da tabela, separando cabeçalho (TBL_HEADER), corpo (TBL_BODY) e linhas (TBL_LINHA) para maior controle e clareza nos testes.

Divisão do trabalho:
Gabriel: mapeou os botões principais da página.

Izadora: cuidou da estrutura geral da tabela e das ações de edição/exclusão.

Raique: focou nos elementos de corpo e cabeçalho da tabela.

Thais: ficou responsável pelas linhas da tabela.

```