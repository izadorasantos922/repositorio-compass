*** Settings ***
Documentation    Eleentos e ações de página de cadastro

Library    Browser
Resource    ../env.resource

*** Keywords ***
Go to signup page
    Go To    ${BASE_URL}/signup
    
    Wait For Elements State    css=h1    visible    5
    Get Text    css=h1    Equal    Faça seu cadastro
Submit signup form
    [Arguments]    ${user}

    Fill Text    css=input[name=name]    ${user}[name]
    Fill Text    css=input[email=email]    ${user}[email]
    Fill Text    css=input[password=password]    ${user}[password]
    Click    css=button[type=submit] >> test=Cadastrar



Alert Should Be
    [Arguments]    ${expected_text}

    Wait For Elements State    css=.alert-error >> text=${expected_text}    
    ...    visible    5

