*** Settings ***
Documentation    online
Library    Browser

Resource    ../resources/base.resource


*** Test Cases ***
Web app deve estar online
    Start Session
    ${title}=    Get Title
    Should Be Equal    ${title}    Mark85 by QAx
