*** Settings ***
Documentation     Testes de cadastro de usuários na API ServeRest
Library           RequestsLibrary
Library           Collections
Library           String

*** Variables ***
${BASE_URL}       https://compassuol.serverest.dev
${INVALID_EMAIL}  usuario.inexistente@gmail.com
${INVALID_SENHA}  senha5444
${senha}          teste
${senha_longa}    teste123546987456987
${senha_curta}    te

*** Test Cases ***
Cadastro Com Sucesso
    [Documentation]    Faz o cadastro com credenciais válidas
    [Tags]    positivo    cadastro
    Criar Sessao
    ${email}    ${nome}    Gerar Email Aleatorio
    ${response}=    Cadastrar    ${email}    ${senha}    ${email}   true
    Validar Status Code    ${response}    201
    Validar Se Contém ID    ${response}    _id
    Validar Se Contém Chave    ${response}    message
    Validar Mensagem De Sucesso No Cadastro    ${response}

Cadastro Com Senha Curta
    [Documentation]    Faz o cadastro com senha curta
    [Tags]    Cadastro    senha    curta
    Criar Sessao
    ${email}    ${nome}    Gerar Email Aleatorio
    ${response}=    Cadastrar    ${email}    ${senha_curta}    ${nome}   false
    Validar Status Code    ${response}    400

Cadastro Com Senha Longa
    [Documentation]    Faz o cadastro com senha longa
    [Tags]    Cadastro    senha    longa
    Criar Sessao
    ${email}    ${nome}    Gerar Email Aleatorio
    ${response}=    Cadastrar    ${email}    ${senha_longa}    ${nome}   false
    Validar Status Code    ${response}    400


Cadastro Com Gmail
    [Documentation]    Faz o cadastro com email Gmail
    [Tags]    Cadastro    gmail
    Criar Sessao
    ${nome_aleatorio}=    Generate Random String    5    [LETTERS]
    ${email_gmail}=    Set Variable    fulano${nome_aleatorio}@gmail.com
    ${response}=    Cadastrar    ${email_gmail}    ${senha}    ${nome_aleatorio}   true
    Validar Status Code    ${response}    400

Cadastro Com Hotmail
    [Documentation]    Faz o cadastro com email Hotmail
    [Tags]    Cadastro    hotmail
    Criar Sessao
    ${nome_aleatorio}=    Generate Random String    5    [LETTERS]
    ${email_hotmail}=    Set Variable    fulano${nome_aleatorio}@hotmail.com
    ${response}=    Cadastrar    ${email_hotmail}    ${senha}    ${nome_aleatorio}   true
    Validar Status Code    ${response}    400

Cadastro Com Email Já Utilizado
    [Documentation]    Tenta cadastrar com email já existente
    [Tags]    negativo    cadastro
    Criar Sessao
    # Primeiro cadastro para garantir que o email existe
    ${email_fixo}=    Set Variable    fulano_fixo@qa.com
    ${response1}=    Cadastrar    ${email_fixo}    teste    Usuário Fixo    true
    # Tentativa de cadastro com mesmo email
    ${response2}=    Cadastrar    ${email_fixo}    teste    Usuário Duplicado    true
    Validar Status Code    ${response2}    400
    Validar Se Contém Chave    ${response2}    message
    Validar Mensagem De Erro Email Já Usado    ${response2}

*** Keywords ***
Criar Sessao
    [Documentation]    Cria uma sessão HTTP para a API
    Create Session    serverest    ${BASE_URL}    verify=True
Gerar Email Aleatorio
    ${nome_aleatorio}=    Generate Random String    5    [LETTERS]
    ${email}=    Set Variable    fulano${nome_aleatorio}@qa.com
    [Return]    ${email}    ${nome_aleatorio}
Cadastrar
    [Documentation]    Realiza uma tentativa de cadastro na API
    [Arguments]    ${email}    ${senha}    ${nome}=Usuário Teste    ${admin}=true
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${senha}    administrador=${admin}
    ${response}=    POST On Session    serverest    /usuarios    json=${body}    expected_status=any
    RETURN    ${response}


Validar Status Code
    [Documentation]    Valida se o código de status da resposta é o esperado
    [Arguments]    ${response}    ${esperado}
    Should Be Equal As Integers    ${response.status_code}    ${esperado}

Validar Se Contém ID
    [Documentation]    Valida se a resposta contém uma chave específica
    [Arguments]    ${response}    ${chave}
    Dictionary Should Contain Key    ${response.json()}    ${chave}

Validar Se Contém Chave
    [Documentation]    Verifica se uma chave está presente na resposta JSON
    [Arguments]    ${response}    ${chave}
    Dictionary Should Contain Key    ${response.json()}    ${chave}

Validar Mensagem De Sucesso No Cadastro
    [Documentation]    Valida a mensagem de sucesso no cadastro
    [Arguments]    ${response}
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Be Equal    ${message}    Cadastro realizado com sucesso

Validar Mensagem De Erro Email Já Usado
    [Documentation]    Valida a mensagem de erro quando email já está em uso
    [Arguments]    ${response}
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Be Equal    ${message}    Este email já está sendo usado
