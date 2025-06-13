*** Settings ***
Documentation    Cenários de testes do cadastro de usuários
Resource    ../resources/base.resource

Suite Setup    Log    setup
Suite Teardown    Log    teardown

Test Setup    Start Session
Test Teardown    Take Screenshot

*** Variables ***
${name}        iza
${email}       iza@gmail.com
${password}    pwd123


*** Test Cases ***
Deve poder cadastrar novos usuários
    [Tags]    cadastro
    
     ${user}    Create Dictionary    name=iza    email=iza@gmail.com    password=pwd111
    Remove user from database    ${user}[email]

    Go to signup page
    Submit signup form    ${user}
    Notice should be    Boas vindas ao Mark85, o seu gerenciador de tarefas.
    

Não deve permitir o cadastrar com email duplicado
    [Tags]    email duplicado

    ${user}    Create Dictionary    name=iza    email=iza@gmail.com    password=pwd111
    Remove user from database    ${user}[email]
    
    Insert user from database    ${user}[name]    ${user}[email]    ${user}[password]

    Go to signup page
    Submit signup form    ${user}
    Notice should be    Boas vindas ao Mark85, o seu gerenciador de tarefas.
Campos Obrigatórios
    [Tags]    required
    ${user}    Create Dictionary
    ...    name=${EMPTY}
    ...    email=${EMPTY}
    ...    password=${EMPTY}
    Go to signup page
    Submit signup form    ${user}
    Alert Should Be    Informe seu nome completo
    Alert Should Be    Informe seu email
    Alert Should Be    Informe com pelo menos 6 digitos

Não deve cadastrar com email incorreto
    [Tags]    email incorreto
    ${user}    Create Dictionary
    ...    nome=Charles X
    ...    email=carlesxavi.com.br
    ...    password=123456
    Go to signup page
    Submit signup form    ${user}
    Alert Should Be    Digite um email válido

Não deve cadastrar com senha muito curta
    [Tags]    temp
    ${password_list}    Create List    1    12    123    1234    12345

    FOR     ${password}    IN    @{password_list}
                ${user}    Create Dictionary
        ...    name=Iza
        ...    email=Izad@gamil.com
        ...    password=${password}
        Go to signup page
        Submit signup form    ${user}
        Alert Should Be    Informe com pelo menos 6 digitos
        
    END

Não deve cadastrar senha de um digito
    [Tags]    short pass
    [Template]    
    Short password    1

Não deve cadastrar senha de dois digito
    [Tags]    short pass
    [Template]    
    Short password    12

Não deve cadastrar senha de três digito
    [Tags]    short pass
    [Template]    
    Short password    123

Não deve cadastrar senha de quatro digito
    [Tags]    short pass
    [Template]    
    Short password    1234

Não deve cadastrar senha de cinco digito
    [Tags]    short pass
    [Template]    
    Short password    12345
    


# *** Keywords ***
# Short password
#     [Arguments]    ${short_pass}    
#     ${user}    Create Dictionary
#     ...    name=Iza
#     ...    email=Izad@gamil.com
#     ...    password=${short_pass}
#     Go to signup page
#     Submit signup form    ${user}
#     Alert Should Be    Informe com pelo menos 6 digitos
