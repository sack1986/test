*** Settings ***
Library           Selenium2Library
Library           NewLibrary

*** Variables ***
${url}            http://test.anaait.com/admin/index.html

*** Test Cases ***
Login
    Comment    Open Browser    ${url}    Edge
    Open Browser    ${url}    Chrome

MyLibrary
    Login Auth
