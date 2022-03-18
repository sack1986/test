*** Settings ***
Library           Collections
Library           requests
Library           RequestsLibrary

*** Test Cases ***
login
    ${mytest}    Set Variable    http://test.anaait.com/api/WorkOrderDevice/Order
    Log    ${mytest}
