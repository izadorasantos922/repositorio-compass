*** Settings ***
Documentation    Cenários de autenticação do usuários
Resource    ../resources/base.resource
Library    Collections
Test Setup    Start Session
Test Teardown    Take Screenshot

*** Test Cases ***
Deve poder logar com o usuário pré-cadastrado
    ${user}    Create Dictionary
    ...    name=Iza
    ...    email=izda@gmail.com
    ...    password=izaiza

    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    Submit login form    ${user}
    User should be logged in    ${user}[name]

Não deve logar com senha inválida
        ${user}    Create Dictionary
    ...    name=Steve
    ...    email=stev@gmail.com
    ...    password=123456

    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    Set To Dictionary    ${user}    passsword=abc123
    User should be logged in    ${user}[name]
    Submit login form    ${user}
    Notice should be    Ocorreu um erro ao fazer login, verifique suas credenciais
