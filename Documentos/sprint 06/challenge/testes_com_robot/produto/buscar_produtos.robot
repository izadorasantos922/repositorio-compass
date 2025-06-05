*** Settings ***
Documentation     Testes de consulta de produtos na API ServeRest
Library           RequestsLibrary
Library           Collections
Library           String

*** Variables ***
${BASE_URL}       https://compassuol.serverest.dev

*** Test Cases ***
Buscar Produtos Com Sucesso
    [Documentation]    Verifica se a API retorna a lista de produtos
    [Tags]    get    produtos
    Criar Sessao
    ${response}=    Buscar Todos Produtos
    Validar Status Code    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    produtos

Mostrar Lista De Produtos No Terminal
    Create Session    serverest    ${BASE_URL}
    ${response}=    GET On Session    serverest    /produtos
    Log To Console    \n=== Lista de Produtos ===
    Log To Console    ${response.json()}

*** Keywords ***
Criar Sessao
    [Documentation]    Cria uma sessão HTTP para a API
    Create Session    serverest    ${BASE_URL}    verify=True

Buscar Todos Produtos
    [Documentation]    Busca todos os produtos cadastrados
    ${response}=    GET On Session    serverest    /produtos    expected_status=any
    [RETURN]    ${response}

Validar Status Code
    [Documentation]    Valida se o código de status da resposta é o esperado
    [Arguments]    ${response}    ${esperado}
    Should Be Equal As Integers    ${response.status_code}    ${esperado}
