*** Settings ***
Documentation     Testes da API ServeRest na funcionalidade usuario - Cadastro, Consulta, Atualização e Exclusão de Usuários
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
    [Documentation]    Valida o cadastro de um usuário com dados válidos
    [Tags]    cadastro valido
    Criar Sessao
    ${email}    ${nome}=    Gerar Email Aleatorio
    ${response}=    Cadastrar    ${email}    ${senha}    ${nome}    true
    Validar Status Code    ${response}    201
    Validar Se Contém ID    ${response}    _id
    Validar Se Contém Chave    ${response}    message
    Validar Mensagem De Sucesso No Cadastro    ${response}

Cadastro Com Senha Curta
    [Documentation]    Valida que não é possível cadastrar com senha muito curta
    [Tags]    cadastro com senha curta
    Criar Sessao
    ${email}    ${nome}=    Gerar Email Aleatorio
    ${response}=    Cadastrar    ${email}    ${senha_curta}    ${nome}    false
    Validar Status Code    ${response}    400
    Validar Mensagem De Erro Senha    ${response}

Cadastro Com Senha Longa
    [Documentation]    Valida que não é possível cadastrar com senha muito longa
    [Tags]    cadastro com senha longa
    Criar Sessao
    ${email}    ${nome}=    Gerar Email Aleatorio
    ${response}=    Cadastrar    ${email}    ${senha_longa}    ${nome}    false
    Validar Status Code    ${response}    400
    Validar Mensagem De Erro Senha    ${response}

Cadastro Com Gmail
    [Documentation]    Valida o cadastro com email do Gmail
    [Tags]    cadastro com gmail
    Criar Sessao
    ${nome_aleatorio}=    Generate Random String    5    [LETTERS]
    ${email_gmail}=    Set Variable    fulano${nome_aleatorio}@gmail.com
    ${response}=    Cadastrar    ${email_gmail}    ${senha}    ${nome_aleatorio}    true
    Validar Status Code    ${response}    400
    Validar Se Contém ID    ${response}    _id

Cadastro Com Hotmail
    [Documentation]    Valida o cadastro com email do Hotmail
    [Tags]    cadastro com hotmail
    Criar Sessao
    ${nome_aleatorio}=    Generate Random String    5    [LETTERS]
    ${email_hotmail}=    Set Variable    fulano${nome_aleatorio}@hotmail.com
    ${response}=    Cadastrar    ${email_hotmail}    ${senha}    ${nome_aleatorio}    true
    Validar Status Code    ${response}    400
    Validar Se Contém ID    ${response}    _id

Cadastro Com Email Já Utilizado
    [Documentation]    Valida que não é possível cadastrar com email já existente
    [Tags]    cadastro com email ja cadastrado
    Criar Sessao
    ${email_fixo}=    Set Variable    fulano_fixo@qa.com
    ${response1}=    Cadastrar    ${email_fixo}    ${senha}    Usuário Fixo    true
    ${response2}=    Cadastrar    ${email_fixo}    ${senha}    Usuário Duplicado    true
    Validar Status Code    ${response2}    400
    Validar Se Contém Chave    ${response2}    message
    Validar Mensagem De Erro Email Já Usado    ${response2}

Buscar Usuarios Com Sucesso
    [Documentation]    Valida a listagem de todos os usuários
    [Tags]    Buscar usuarios
    Criar Sessao
    ${response}=    Buscar Todos Usuarios
    Validar Status Code    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    usuarios
    ${usuarios}=    Get From Dictionary    ${response.json()}    usuarios
    ${quantidade}=    Get Length    ${usuarios}
    Should Be True    ${quantidade} > 0

Cadastro E Atualizacao De Usuario
    [Documentation]    Valida o fluxo de cadastro e atualização de um usuário
    [Tags]    cadastro atualizacao
    Criar Sessao
    ${email}    ${nome}=    Gerar Email Aleatorio
    ${response}=    Cadastrar    ${email}    ${senha}    ${nome}    true
    Validar Status Code    ${response}    201
    ${id}=    Get From Dictionary    ${response.json()}    _id
    ${novo_nome}=    Set Variable    ${nome}_Atualizado
    ${response_update}=    Atualizar Usuario    ${id}    ${novo_nome}    ${email}    ${senha}    true
    Validar Status Code    ${response_update}    200
    Validar Mensagem De Sucesso No Update    ${id}    ${novo_nome}

Cadastro E Exclusao De Usuario
    [Documentation]    Valida o fluxo de cadastro e exclusão de um usuário
    [Tags]    cadastro e exclusao
    Criar Sessao
    ${email}    ${nome}=    Gerar Email Aleatorio
    ${response}=    Cadastrar    ${email}    ${senha}    ${nome}    true
    Validar Status Code    ${response}    201
    ${id}=    Get From Dictionary    ${response.json()}    _id
    ${response_delete}=    Deletar Usuario    ${id}
    Validar Status Code    ${response_delete}    200
    Validar Usuario Foi Excluido    ${id}

*** Keywords ***
Criar Sessao
    Create Session    serverest    ${BASE_URL}    verify=True

Gerar Email Aleatorio
    ${nome_aleatorio}=    Generate Random String    5    [LETTERS]
    ${email}=    Set Variable    fulano${nome_aleatorio}@qa.com
    RETURN    ${email}    ${nome_aleatorio}

Cadastrar
    [Arguments]    ${email}    ${senha}    ${nome}=Usuário Teste    ${admin}=true
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${senha}    administrador=${admin}
    ${response}=    POST On Session    serverest    /usuarios    json=${body}    expected_status=any
    RETURN    ${response}

Buscar Todos Usuarios
    ${response}=    GET On Session    serverest    /usuarios    expected_status=any
    RETURN    ${response}

Atualizar Usuario
    [Arguments]    ${id}    ${nome}    ${email}    ${senha}    ${admin}
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${senha}    administrador=${admin}
    ${response}=    PUT On Session    serverest    /usuarios/${id}    json=${body}    expected_status=any
    RETURN    ${response}

Deletar Usuario
    [Arguments]    ${id_usuario}
    ${response}=    DELETE On Session    serverest    /usuarios/${id_usuario}    expected_status=any
    RETURN    ${response}

Validar Status Code
    [Arguments]    ${response}    ${esperado}
    Should Be Equal As Integers    ${response.status_code}    ${esperado}

Validar Se Contém ID
    [Arguments]    ${response}    ${chave}
    Dictionary Should Contain Key    ${response.json()}    ${chave}

Validar Se Contém Chave
    [Arguments]    ${response}    ${chave}
    Dictionary Should Contain Key    ${response.json()}    ${chave}

Validar Mensagem De Sucesso No Cadastro
    [Arguments]    ${response}
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Be Equal    ${message}    Cadastro realizado com sucesso

Validar Mensagem De Erro Email Já Usado
    [Arguments]    ${response}
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Be Equal    ${message}    Este email já está sendo usado

Validar Mensagem De Erro Senha
    [Arguments]    ${response}
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Contain    ${message}    password

Validar Mensagem De Sucesso No Update
    [Arguments]    ${id_usuario}    ${nome_esperado}
    ${response}=    GET On Session    serverest    /usuarios/${id_usuario}
    Validar Status Code    ${response}    200
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    nome
    ${nome_atual}=    Get From Dictionary    ${json}    nome
    Should Be Equal    ${nome_atual}    ${nome_esperado}

Validar Usuario Foi Excluido
    [Arguments]    ${id_usuario}
    ${response}=    GET On Session    serverest    /usuarios/${id_usuario}    expected_status=any
    Validar Status Code    ${response}    400
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Be Equal    ${message}    Usuário não encontrado