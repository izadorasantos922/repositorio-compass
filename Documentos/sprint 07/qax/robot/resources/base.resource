*** Settings ***
Library    libs/database.py
Library    Browser
Resource    pages/components/Header.resource
Resource    env.resource
Resource    pages/SignupPage.resource
Resource    pages/LoginPage.resource
Resource    pages/components/Notice.resource

*** Variables ***
${BASE_URL}    http://localhost:3000

*** Keywords ***
Start Session

    New Browser    browser=chromium    headless=False
    New Page    ${BASE_URL}


*** Keywords ***
Short password
    [Arguments]    ${short_pass}    
    ${user}    Create Dictionary
    ...    name=Iza
    ...    email=Izad@gamil.com
    ...    password=${short_pass}
    Go to signup page
    Submit signup form    ${user}
    Alert Should Be    Informe com pelo menos 6 digitos