*** Keywords ***
Post_Requst
    [Arguments]    ${host}    ${path}    ${datas}    ${params}=${EMPTY}    ${headers}=None    ${cookies}=None    ${timeoust}=30
    #设置编码
    BuiltIn.Evaluate    reload(sys)    sys
    BuiltIn.Evaluate    sys.setdefaultencoding("utf-8")    sys
    #处理header请求
    ${header_dic}    Create Dictionary    Content-Type=application/json
    Run keyWord If    ${header_dic}==${None}}    Log    没有添加header
    Run Keyword    add_header    ${headers}    ${header_dic}
    #处理cookie请求
    ${cookie_dic}    Create Dictionary
    Run keyWord If    ${cookie_dic}==${None}}    Log    没有设置cookie
    Run Keyword    add_cookie    ${cookies}    ${cookie_dic}
    #创建session
    Create Session    AnGov_Api_Test    ${host}    timeout=${timeout}    cookies=${${cookie_dic}}
    #发起Post请求
    ${Resp}    POST On Session    AnGov_Api_Test    ${path}    data=${data}    headers=${header_dic}    params=${params}
    {Return}    ${Resp}

add_cookie
    [Arguments]    ${cookies}    ${cookiedict}
    @{cookielist}    Split Spring    ${cookies}    ;
    FOR    ${cookie}    IN    @{cookielist}
        Run Keyword If    ${cookie}==${None}    Exit For Loop
        ${cookie_split}=    Split Spring    ${cookie}    =
        Set To Dictionary    ${cookiedict}    ${cookie_split[0]}=${cookie_split[1]}
    END

add_header
    [Arguments]    ${headers}    ${headerdict}
    @{headerlist}    Split Spring    ${headers}    ;
    FOR    ${header}    IN    @{headerlist}
        Run Keyword If    ${header}==${None}    Exit For Loop
        ${header_split}=    Split Spring    ${header}    =
        Set To Dictionary    ${headerdict}    ${header_split[0]}=${header_split[1]}
    END
