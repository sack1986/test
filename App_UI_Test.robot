*** Settings ***
Library           AppiumLibrary
Library           Selenium2Library

*** Test Cases ***
Ding_Login
    Open Application    http://localhost:4723/wd/hub    platformName=Android    platformVersion=7.1.2    deviceName=127.0.0.1:21503    appPackage=com.alibaba.android.rimet    appActivity=com.alibaba.android.user.login.NewUserLoginActivity
    Wait Until Element Is Visible    id=com.alibaba.android.rimet:id/et_pwd_login
    Input Text    id=com.alibaba.android.rimet:id/et_pwd_login    123456
    Click Element    id=com.alibaba.android.rimet:id/cb_privacy
    Click Element    id=com.alibaba.android.rimet:id/tv
