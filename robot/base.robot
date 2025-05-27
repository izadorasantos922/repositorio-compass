*** Settings ***
Documentation     Arquivo para testar requisições em uma API REST
Library           RequestsLibrary
Library           Collections
Library           BuiltIn
Library    JsonLibrary

*** Variables ***
${BASE_URL}         https://reqres.in
${API_KEY}          reqres-free-v1
${email}            eve.holt@reqres.in
${senha}            pistol
${id}               4
${email_atualizado}    iza.holt@reqres.in  
${senha_atualizada}    123456pistol

*** Test Cases ***
Cenário: POST Cadastrar usuário 200
    [Tags]    POST
    Criar Sessao
    POST Cadastrar Usuario
    Validar Status Code    200
    Validar Se Contém Chave    token

Cenário: GET Todos os usuários 200
    [Tags]    GET
    Criar Sessao
    GET Listar Usuarios
    Validar Usuarios Na Response
    Validar Status Code    200

Cenário: PUT Atualizar usuário 200
    [Tags]    PUT
    Criar Sessao
    PUT Atualizar Usuario
    Validar Status Code    200

Cenário: DELETE Deletar usuário
    [Tags]    DELETE
    Criar Sessao
    DELETE Remover Usuario
    Validar Status Code    204

*** Keywords ***
Criar Sessao
    Create Session    APIReqRes    ${BASE_URL}

POST Cadastrar Usuario
    &{payload}=    Create Dictionary    email=${email}    password=${senha}
    ${headers}=    Create Dictionary    Content-Type=application/json    x-api-key=${API_KEY}
    ${response}=    POST On Session    APIReqRes    /api/register    headers=${headers}    json=${payload}    expected_status=any

    Log    Status Code: ${response.status_code}
    Log    Response: ${response.json()}
    Set Test Variable    ${response}

Validar Status Code
    [Arguments]    ${esperado}
    Should Be Equal As Integers    ${response.status_code}    ${esperado}

Validar Se Contém Chave
    [Arguments]    ${chave}
    Dictionary Should Contain Key    ${response.json()}    ${chave}

GET Listar Usuarios
    ${headers}=    Create Dictionary    x-api-key=${API_KEY}
    ${response}=    GET On Session    APIReqRes    /api/users    headers=${headers}    expected_status=any
    Set Test Variable    ${response}

Validar Usuarios Na Response
    ${json}=    Convert To Dictionary    ${response.json()}
    Dictionary Should Contain Key    ${json}    data
    ${length}=    Get Length    ${json["data"]}
    Should Be True    ${length} > 0
        
PUT Atualizar Usuario
    &{payload}=    Create Dictionary    email=${email}    password=${senha_atualizada}
    ${headers}=    Create Dictionary    Content-Type=application/json    x-api-key=${API_KEY}
    ${response}=    PUT On Session    APIReqRes    /api/users/${id}    headers=${headers}    json=${payload}    expected_status=any

    Log    Status Code: ${response.status_code}
    Log    Response: ${response.json()}
    Set Test Variable    ${response}

DELETE Remover Usuario
    ${headers}=    Create Dictionary    Content-Type=application/json    x-api-key=${API_KEY}
    ${response}=    DELETE On Session    APIReqRes    /api/users/${id}    headers=${headers}    expected_status=any

    Log    Status Code: ${response.status_code}
    Set Test Variable    ${response}
    

# Este projeto foi ajustado com orientação do ChatGPT,
# que sugeriu incluir os cabeçalhos' em todas as requisições HTTP.
