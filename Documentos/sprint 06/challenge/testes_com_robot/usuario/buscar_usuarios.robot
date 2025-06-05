*** Settings ***
Documentation     Testes para a Api serverest retornar a lista de usuários
Library           RequestsLibrary
Library           Collections
Library           String

*** Variables ***
${BASE_URL}       https://compassuol.serverest.dev

*** Test Cases ***
Buscar Usuarios Com Sucesso
    [Documentation]    Verifica se a API retorna a lista de usuários
    [Tags]    get    usuarios
    Criar Sessao
    ${response}=    Buscar Todos Usuarios
    Validar Status Code    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    usuarios


*** Keywords ***
Criar Sessao
    [Documentation]    Cria uma sessão HTTP para a API
    Create Session    serverest    ${BASE_URL}    verify=True

Buscar Todos Usuarios
    [Documentation]    Busca todos os usuários cadastrados
    ${response}=    GET On Session    serverest    /usuarios    expected_status=any
    [RETURN]    ${response}

Validar Status Code
    [Documentation]    Valida se o código de status da resposta é o esperado
    [Arguments]    ${response}    ${esperado}
    Should Be Equal As Integers    ${response.status_code}    ${esperado}