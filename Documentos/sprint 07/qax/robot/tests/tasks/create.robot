*** Settings ***
Documentation            Cenários de cadastro de tarefas

Library                  JSONLibrary

Resource                 ../../resources/base.resource

Test Setup               Start Session
Test Teardown            Take Screenshot

*** Test Cases ***
Deve poder cadastrar uma nova tarefa
    ${data}    Get fixture    tasks    create

    Clean user from database       ${data}[user][email]
    Insert user into database      ${data}[user]
    Do login                       ${data}[user]

   
    Go to task Form
    Submit Task Form               ${data}[task]
    Task should be registered      ${data}[task][name]

Não deve cadastrar tarefa com nome duplicado
    [Tags]     duplicate
    ${data}    Get fixture    tasks    duplicate

    Reset user from database       ${data}[user]
    Create a new task from API     ${data}
    Do login                       ${data}[user]
   
    Go to task Form
    Submit Task Form               ${data}[task]

    Notice should be    Oops! Tarefa duplicada.

Não deve cadastrar uma nova tarefa quando atinge o limite de tags
    [Tags]     tags_limit
    ${data}    Get fixture    tasks    tags_limit

    Reset user from database    ${data}[user]
    
    Submit login form              ${data}[user]
    User should be logged in       ${data}[user][name]
   
    Go to task Form
    Submit Task Form               ${data}[task]

    Notice should be    Oops! Limite de tags atingido.