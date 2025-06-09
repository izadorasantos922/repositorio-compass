*** Settings ***
Documentation     Teste de login e cadastro de produto na API ServeRest
Library           RequestsLibrary
Library           Collections
Library           String

*** Variables ***
${BASE_URL}           https://compassuol.serverest.dev
${EMAIL}              fulano@qa.com
${SENHA}              teste
${PRODUTO_PRECO}      99
${PRODUTO_DESCRICAO}  Descrição do produto
${QUANTIDADE}         10

*** Test Cases ***
Login E Cadastro De Produto
    [Documentation]    Faz login com um usuário e cadastra um produto autenticado
    [Tags]    Autenticação e cadastrar produto
    Criar Sessao
    ${random_string}=    Generate Random String    5    [LETTERS]
    ${produto_nome}=     Set Variable    Produto Teste ${random_string}
    ${token}=            Fazer Login E Obter Token    ${EMAIL}    ${SENHA}
    ${response}=         Cadastrar Produto    ${token}    ${produto_nome}    ${PRODUTO_PRECO}    ${PRODUTO_DESCRICAO}    ${QUANTIDADE}
    Validar Status Code        ${response}    201
    Validar Se Contém Chave    ${response}    _id
    Validar Se Contém Chave    ${response}    message

#buscar produto

# atualizar produto

#deletar produto

*** Keywords ***
Criar Sessao
    [Documentation]    Cria uma sessão HTTP para a API
    Create Session    serverest    ${BASE_URL}    verify=True

Fazer Login E Obter Token
    [Documentation]    Realiza login e retorna o token de autorização
    [Arguments]    ${email}    ${senha}
    ${body}=       Create Dictionary    email=${email}    password=${senha}
    ${response}=   POST On Session    serverest    /login    json=${body}    expected_status=any
    Validar Status Code    ${response}    200
    ${token}=      Get From Dictionary    ${response.json()}    authorization
    RETURN         ${token}

Cadastrar Produto
    [Documentation]    Realiza o cadastro de um produto na API
    [Arguments]    ${token}    ${nome}    ${preco}    ${descricao}    ${quantidade}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${body}=       Create Dictionary
    ...            nome=${nome}
    ...            preco=${preco}
    ...            descricao=${descricao}
    ...            quantidade=${quantidade}
    ${response}=   POST On Session    serverest    /produtos    headers=${headers}    json=${body}    expected_status=any
    RETURN         ${response}

Validar Status Code
    [Documentation]    Valida se o código de status da resposta é o esperado
    [Arguments]    ${response}    ${esperado}
    Should Be Equal As Integers    ${response.status_code}    ${esperado}

Validar Se Contém Chave
    [Documentation]    Verifica se uma chave está presente na resposta JSON
    [Arguments]    ${response}    ${chave}
    Dictionary Should Contain Key    ${response.json()}    ${chave}
