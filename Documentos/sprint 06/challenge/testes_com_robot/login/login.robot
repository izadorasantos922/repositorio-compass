*** Settings ***
Documentation     Testes de autenticação na API ServeRest
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://compassuol.serverest.dev
${VALID_EMAIL}    fulano@qa.com
${VALID_SENHA}    teste
${INVALID_EMAIL}  usuario.inexistente@gmail.com
${INVALID_SENHA}  senha5444

*** Test Cases ***
Login Com Sucesso
    [Documentation]    Valida o login com credenciais válidas
    [Tags]    positivo    autenticacao
    Criar Sessao
    ${response}=    Fazer Login    ${VALID_EMAIL}    ${VALID_SENHA}
    Validar Status Code    ${response}    200
    Validar Se Contém Chave    ${response}    authorization
    Validar Se Contém Chave    ${response}    message
    Validar Mensagem De Sucesso    ${response}

Login Com Credenciais Inválidas
    [Documentation]    Valida o comportamento com credenciais inválidas
    [Tags]    negativo    autenticacao
    Criar Sessao
    ${response}=    Fazer Login    ${INVALID_EMAIL}    ${INVALID_SENHA}
    Validar Status Code    ${response}    401
    Validar Se Contém Chave    ${response}    message
    Validar Mensagem De Erro    ${response}

*** Keywords ***
Criar Sessao
    [Documentation]    Cria uma sessão HTTP para a API
    Create Session    serverest    ${BASE_URL}    verify=True

Fazer Login
    [Documentation]    Realiza uma tentativa de login na API
    [Arguments]    ${email}    ${senha}
    ${body}=    Create Dictionary    email=${email}    password=${senha}
    ${response}=    POST On Session    serverest    /login    json=${body}    expected_status=any
    RETURN    ${response}

Validar Status Code
    [Documentation]    Valida se o código de status da resposta é o esperado
    [Arguments]    ${response}    ${esperado}
    Should Be Equal As Integers    ${response.status_code}    ${esperado}

Validar Se Contém Chave
    [Documentation]    Valida se a resposta contém uma chave específica
    [Arguments]    ${response}    ${chave}
    Dictionary Should Contain Key    ${response.json()}    ${chave}

Validar Mensagem De Sucesso
    [Documentation]    Valida a mensagem de sucesso no login
    [Arguments]    ${response}
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Be Equal    ${message}    Login realizado com sucesso

Validar Mensagem De Erro
    [Documentation]    Valida a mensagem de erro no login
    [Arguments]    ${response}
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Be Equal    ${message}    Email e/ou senha inválidos