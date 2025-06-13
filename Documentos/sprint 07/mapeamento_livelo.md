| Nome do Elemento       | Seletor                                   | Justificativa da Estratégia                                      |
|-----------------------|-------------------------------------------|-----------------------------------------------------------------|
| Botão de Login        | `//*[@id="l-header__button_login"]`       | Uso de ID único para selecionar diretamente o botão, seletor simples e rápido. IDs são únicos na página, garantindo precisão. |
| Botão do Carrinho (XPath) | `//button[@id="l-cart__button"]`           | Seleção pelo ID via XPath, que é único e confiável para localizar o botão exato. Pode ser útil em testes que preferem XPath.  |
| Botão do Carrinho (CSS) | `button[data-testid="button_l-cart__button"]` | Seleção por atributo customizado `data-testid`, ideal para testes automatizados; menos sujeito a mudanças visuais, focado na testabilidade.|
