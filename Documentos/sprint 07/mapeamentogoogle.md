## 🔍 Mapeamento de Elementos da Página de Pesquisa do Google

| Nome do Elemento    | Seletor CSS ou XPath                                                                 | Observações                                                                                       |
|---------------------|---------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| **CAMPO_PESQUISA**  | `textarea[name="q"]`              | Campo de busca principal. Atualmente é um `<textarea>` com `name="q"`.            |
| **BOTAO_PESQUISA**  | `input[name="btnK"]`                                | Botão com texto “Pesquisa Google”. Só fica visível após digitar no campo.                        |
| **LINKS_RESULTADO** |  `//div[@id="search"]//div[contains(@class,"g")]//a`         | Links dos resultados orgânicos da pesquisa. Estão dentro do bloco `div#search`.                  |
