## Mapeamento dos Elementos: ecommerce https://books.toscrape.com/

| Nome do Elemento      | Seletor                             | Observação                         | Estratégia                       | Justificativa da Estratégia                                                                 |
|----------------------|-------------------------------------|----------------------------------|---------------------------------|---------------------------------------------------------------------------------------------|
| Título do livro      | `a[title="A Light in the Attic"]`   | Procurar o título pelo nome      | CSS Selector (por atributo `title`) | Usar o atributo `title` é confiável porque identifica o link do livro de forma única.       |
| Botão de compra      | `//button[text()="Add to basket"]`  | Botão presente na página de detalhes | XPath                          | Usar `text()` com XPath garante que o botão será identificado pelo texto visível ao usuário.|
| Preço do livro       | `//div[@class="product_price"]//p`  | Parágrafo que contém o preço     | XPath                           | A estrutura hierárquica do XPath garante que estamos pegando o preço dentro do local certo. |
| Estoque disponível   | `.instock`                          | Verifica se o item está em estoque | CSS Selector por classe         | Classe `instock` indica disponibilidade e é reutilizável em várias partes da página.        |
