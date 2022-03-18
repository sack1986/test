*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           requests
Library           jsonpatch
Library           JSONLibrary
Library           Screenshot
Library           DatabaseLibrary
Library           HttpLibrary.HTTP
Library           imp
Library           importlib
Library           String
Library           OperatingSystem
Library           ExcelLibrary
Library           MyLibrary

*** Variables ***
${result}         ${EMPTY}

*** Test Cases ***
search
    &{headers}    Set Variable    Content-Type=application/json
    ${url}    Create Session    test    http://test.anaait.com    ${headers}
    ${data1}    Set Variable    {"id": "910","name": "test", "idCard": "530127198606092727"}
    ${data}    to json    ${data1}
    log    ${data}
    ${response}    POST On Session    test    /api/WorkOrderDevice/Order    data=${data}
    log    ${response.text}

jiben
    ${time}    get time
    log    ${time}
    ${a}    set variable    90
    RUN KEYWORD IF    ${a}>81    log    大于81
    ...    ELSE IF    ${a}<81    log    小于81
    ...    ELSE    log    其他
    FOR    ${i}    IN RANGE    5
        log    ${i}
    END
    Take Screenshot
    @{list}    Create List    001    002    003
    FOR    ${j}    IN    @{list}
        log    ${j}
    END
    FOR    ${index}    ${value}    IN ENUMERATE    @{list}
        log    ${index},${value}
    END
    &{dict}    Create Dictionary    name=张三    password=1234
    FOR    ${key}    ${value}    IN    &{dict}
        log    ${key},${value}
    END
    ${list1}    Create List    name    sex
    ${list2}    Create List    女    男
    log    ${list1}
    ${len}    Get Length    ${list1}
    ${list3}    Create List
    FOR    ${i}    IN RANGE    ${len}
        Append To List    ${list3}    ${list1[${i}-1]}
        log    ${list3}
    END

SqlServerPost
    Connect To Database Using Custom Params    pyodbc    "Driver={SQL Server};Server=DESKTOP-JF193G7;Port=1433;Database=Test;UID=sa;PWD=agk1234;"
    &{header_dic}=    Create Dictionary    Content-Type=application/json
    ${path}=    Set Variable    /api/WorkOrderDevice/Order
    ${host}=    Set Variable    http://test.anaait.com
    #创建session
    Create Session    AnGov_Api_Test    ${host}
    @{info2}    query    select * from info
    FOR    ${data}    IN    @{info2}
        Log    ${data[3]}
    #发起Post请求
        ${Resp}    POST On Session    AnGov_Api_Test    ${path}    data=${data[1]}    headers=&{header_dic}
        Log    ${Resp.content}
        ${seccess}=    Get Json Value    ${Resp.content}    /success
        Log    ${seccess}
        ${except_data}    Get Json Value    ${data[3]}    /success
        ${Result}=    Set Variable IF    '${seccess}'=='${except_data}'    ${1}    ${0}
        Log    ${Result}
        Run Keyword IF    ${Result}==${1}    Execute Sql String    update info set \ result='success' where id=${data[0]}
        ...    ELSE    Execute Sql String    update info set \ result='false' where id=${data[0]}
        Run Keyword And Continue On Failure    Should Be Equal    ${seccess}    ${except_data}
    END

Post
    #方法1
    ${data}    Create Dictionary    id=910    name=test    idCard=001
    Log    ${data}
    &{header_dic}=    Create Dictionary    Content-Type=application/json
    ${path}=    Set Variable    /api/WorkOrderDevice/Order
    ${host}=    Set Variable    http://test.anaait.com
    #创建session
    Create Session    AnGov_Api_Test    ${host}
    #发起Post请求
    ${Resp}    POST On Session    AnGov_Api_Test    ${path}    data=${data}    headers=&{header_dic}
    Log    ${Resp}
    #方法2
    ${data}    Create Dictionary    id=910    name=test    idCard=001
    Log    ${data}
    &{header_dic}=    Create Dictionary    Content-Type=application/json
    ${path}=    Set Variable    /api/WorkOrderDevice/Order
    ${host}=    Set Variable    http://test.anaait.com
    #创建session
    Create Session    AnGov_Api_Test    ${host}
    #发起Post请求
    ${Resp}    POST On Session    AnGov_Api_Test    ${path}    data=${data}    headers=&{header_dic}
    Log    ${Resp}
    #方法3
    ${data1}    Create Dictionary    id=910    name=test    idCard=001
    #字典转为json
    ${data}=    Stringify Json    ${data1}
    &{header_dic}=    Create Dictionary    Content-Type=application/json
    ${path}=    Set Variable    /api/WorkOrderDevice/Order
    ${host}=    Set Variable    http://test.anaait.com
    #创建session
    Create Session    AnGov_Api_Test    ${host}
    #发起Post请求
    ${Resp}    POST On Session    AnGov_Api_Test    ${path}    data=${data}    headers=&{header_dic}
    Log    ${Resp}

PostTest
    ${data}    Set Variable    {"deleted": "0", "educationName": "xueli", "endTime": "2001-09-27", "id": "", "professionName": "zhuanye", "resumeId": "879321649776685065", "schoolExperience": "zaixiao", "schoolName": "xuexiao", "startTime": "2005-09-27", "userId": "879321649776685056"}
    Log    ${data}
    &{header_dic}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer 0f567bba-50c5-4c52-9e93-44adf50869de
    ${path}=    Set Variable    /talents/resume/writeEducateExperience
    ${host}=    Set Variable    http://52.130.80.202:12240
    #创建session
    Create Session    AnGov_Api_Test    ${host}
    #发起Post请求
    ${statue}    ${Resp}    Run Keyword And Ignore Error    POST On Session    AnGov_Api_Test    ${path}    data=${data}.encode('utf-8')    headers=&{header_dic}
    Comment    ${Resp}    POST On Session    AnGov_Api_Test    ${path}    data=${data}.encode('utf-8')    headers=&{header_dic}
    Comment    ${value}=    Get Json Value    ${Resp.content}    /code
    #    ${Resp[0]}
    Run Keyword IF    '${statue}'=='PASS'    Log    ${Resp.text}
    ...    ELSE IF    '${statue}'=='FAIL'    Log    ${Resp}
    Comment    \    Run Keyword And Ignore Error    Run Keyword And Continue On Failure    {"deleted": "0", "educationName": "xueli", "endTime": "2001-09-27", "id": "", "professionName": "zhuanye", "resumeId": "879321649776685065", "schoolExperience": "zaixiao", "schoolName": "xuexiao", "startTime": "2005-09-27", "userId": "879321649776685056"}

test
    ${header_dic1}    Set Variable    a=b
    Run keyWord If    '${header_dic1}'=='${None}'    Log    没有添加header
    ...    ELSE    Log    存在header
    ${header_dic2}    Set Variable
    Run keyWord If    '${header_dic2}'=='${None}'    Log    没有添加header
    ...    ELSE    Log    存在header

SqlServer
    #查询数据库内容
    Connect To Database Using Custom Params    pyodbc    "Driver={SQL Server};Server=DESKTOP-JF193G7;Port=1433;Database=Test;UID=sa;PWD=agk1234;"
    @{info1}    query    select * from info
    Log Many    @{info1}
    #获取数据库字段名称
    @{info2}    Description    select * from info
    FOR    ${col}    IN    @{info2}
        Log    ${col}[0]
    END
    #修改数据库内容
    Comment    Execute Sql String    update info set \ result='true' where id=1

string拼接
    ${string}    Set Variable    "123456"
    ${string}    Remove String Using Regexp    ${string}    "
    ${token_info}    Set Variable    Bearer
    ${api_token}    BuiltIn.Catenate    SEPARATOR= \    ${token_info}    ${string}
    Log    ${api_token}

test2
    ${is_cookie}    Set Variable    0
    Run Keyword IF    ${is_cookie}==${1}    Log    bu
    ...    ELSE    Log    zhix

test3
    ${call_resp}    Set Variable    True
    ${arrive_sucess}    Set Variable    True
    ${expect_seccess}    Set Variable    True
    ${result}    Set Variable If    ${call_resp}==True \ & ${arrive_sucess}==True    1    0
    Log    ${result}
    &{dict}    Create Dictionary    success=True
    ${json}    Evaluate    json.dumps(&{dict})
    ${result}    Get Json Value    ${json}    /success
    ${result}    Remove String Using Regexp    ${result}    "
    Log    ${result}
    ${result2}    Set Variable If    "${result}"=="True"    1    0
    Log    ${result2}

SqlServerPost2
    Connect To Database Using Custom Params    pyodbc    "Driver={SQL Server};Server=DESKTOP-JF193G7;Port=1433;Database=Test;UID=sa;PWD=agk1234;"
    &{header_dic}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjQ4IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6Im9rVXJjdHdRbTFIb0dqOGNEM0JXbXJ4VFZhYWciLCJBc3BOZXQuSWRlbnRpdHkuU2VjdXJpdHlTdGFtcCI6IkZDT0JIMkdWS1lTVkQ0WTRMRkxKRkc1NkxSQlJEVjczIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVXNlciIsImh0dHA6Ly93d3cuYXNwbmV0Ym9pbGVycGxhdGUuY29tL2lkZW50aXR5L2NsYWltcy90ZW5hbnRJZCI6IjEiLCJzdWIiOiI0OCIsImp0aSI6ImMwM2Y1MjNlLTBjNDItNGU0Ny1hZjIxLTE0ZjYxNzVhMDdiNCIsImlhdCI6MTYyNTA0NDExNiwibmJmIjoxNjI1MDQ0MTE2LCJleHAiOjE2MjUxMzA1MTYsImlzcyI6IkFOR1MiLCJhdWQiOiJBTkdTIn0.E6UNfprDr8QyJk3LGu_2oFYJFC8oPx4ei9H4TFdW3oM
    ${path}=    Set Variable    /api/WorkOrder/List
    ${host}=    Set Variable    http://test.anaait.com
    ${data}    Set Variable    {"type":0}
    #创建session
    Create Session    AnGov_Api_Test    ${host}
    #发起Post请求
    ${Resp}    POST On Session    AnGov_Api_Test    ${path}    data=${data}    headers=${header_dic}
    ${result}    Get Json Value    ${Resp.content}    /result
    ${result}    Replace String    ${result}    false    "false"
    ${result}    Replace String    ${result}    true    "true"
    ${result}    Replace String    ${result}    null    "null"
    @{result_list}    Evaluate    list(${result})
    ${result_len}    Evaluate    len(@{result_list})
    Log    ${result_len}

GetLength
    ${lilst}    Set Variable    {"result":[{"id": "517", "userId": "48", "name": "代绍丽", "idCard": "530127199901010101", "phone": "15096699864", "workDeptName": "安宁市林业和草原局", "workDeptItemName": "林木种子（含园林绿化草种）生产经营许可证核发", "workDeptId": "58", "workDeptItemId": "906", "handler": null, "handlerId": "0", "workOrderStatus": 0, "visitStatus": 0, "orderTime": "2021-06-30 17:09:10", "signInTime": "", "callTime": "", "collectTime": "", "finishTime": "", "orderSpan": "13:30:00-16:00:00", "evaluateTime": "", "remindTime": "", "deliveryTime": "", "isEvaluate": false, "isRemind": false, "isDelivery": false, "score": 0, "window": "7,8,9,10,11,12", "floor": "1", "code": "LY"}, {"id": "516", "userId": "48", "name": "代绍丽", "idCard": "530127199901010101", "phone": "15096699864", "workDeptName": "昆明市道路运输管理局安宁分局", "workDeptItemName": "道路货物运输经营许可证（损坏、遗失补发）", "workDeptId": "70", "workDeptItemId": "1104", "handler": null, "handlerId": "0", "workOrderStatus": 1, "visitStatus": 0, "orderTime": "2021-06-08 09:14:35", "signInTime": "2021-06-30 17:08:50", "callTime": "", "collectTime": "", "finishTime": "", "orderSpan": "09:14:35-09:14:35", "evaluateTime": "", "remindTime": "2021-06-30 10:30:51", "deliveryTime": "", "isEvaluate": false, "isRemind": true, "isDelivery": false, "score": 0, "window": "1,2,3,4,5", "floor": "1", "code": "YG"}]}
    ${lilst_re}    Get Json Value    ${lilst}    /result
    ${lilst_re}    Replace String    ${lilst_re}    false    "false"
    Log    ${lilst_re}
    @{lilst_re2}    Evaluate    list(${lilst_re})
    ${lilst_len}    Evaluate    len(@{lilst_re2})
    Log    ${lilst_len}

random
    ${random_num}    Evaluate    random.randint(0,5)    random
    FOR    ${num}    IN RANGE    ${random_num}
        Log    ${num}
    END

split
    ${test}    Set Variable    共 3 条
    ${test1}    Split String    ${test}    共
    ${test2}    Split String    ${test1[1]}    条
    Log    ${test2}[0]
    ${result}    Convert To Integer    ${test2[0]}
    ${result2}    Evaluate    ${result}+1
    Log    ${result2}
    ${dat}    Set Variable    a,b,c
    ${dat}    split string    ${dat}
    log    ${dat}

test_sql_json
    @{info}    Select_Sql    system_manage_ui_case    UserAdd
    #从数据库中获取测试数据进行请求
    FOR    ${data}    IN    @{info}
    #${table_info}在配置文件中进行配置
    #获取请求path
        ${content_data_num}    Get From Dictionary    ${table_info}    content_data
        ${content_data}    Set variable    ${data[${content_data_num}]}
        ${content_data}    Evaluate    json.dumps(${content_data})
        ${user_name}    Get Json Value    ${content_data}    /user_name
        ${phone}    Get Json Value    ${content_data}    /phone
        ${mail}    Get Json Value    ${content_data}    /mail
        ${login_name}    Get Json Value    ${content_data}    /login_name
        ${password}    Get Json Value    ${content_data}    /password
        ${remarks}    Get Json Value    ${content_data}    /remarks
    END

test_sql_dic
    @{info}    Select_Sql    system_manage_ui_case    UserAdd
    #从数据库中获取测试数据进行请求
    FOR    ${data}    IN    @{info}
    #${table_info}在配置文件中进行配置
    #获取请求path
        ${content_data_num}    Get From Dictionary    ${table_info}    content_data
        ${content_data}    Set variable    ${data[${content_data_num}]}
        ${content_data}    Evaluate    json.dumps(${content_data})
        ${user_name}    Get Json Value    ${content_data}    /user_name
        ${phone}    Get Json Value    ${content_data}    /phone
        ${mail}    Get Json Value    ${content_data}    /mail
        ${login_name}    Get Json Value    ${content_data}    /login_name
        ${password}    Get Json Value    ${content_data}    /password
        ${remarks}    Get Json Value    ${content_data}    /remarks
    END

FileOperate
    [Documentation]    导入库OperatingSystem
    #读取指定文件夹下的全部文件
    ${files2}    List Files In Directory    E:\\2021\\20210908政务-语音识别\\jmeter\\file
    Comment    Log    ${files2[1]}
    Log    ${files2}
    #移动文件
    Comment    Move File    ${export_path}\\${files2[1]}    C:\\Users\\agk\\Downloads\\dowload

ExcelOperate
    ${export_path}    Set Variable    C://Users//agk//Downloads//
    #读取指定文件夹下的全部文件
    ${files}    List Files In Directory    ${export_path}
    Log    ${files[1]}
    Open Excel    ${export_path}//${files[1]}
    Comment    Open Excel    C://Users//agk//Downloads//user_1629184396413.xls
    ${row_count}    Get Row Count    用户数据

IFSet Variable
    ${Result}    Run Keyword IF    'name'=='nameq'    Set Variable    'test1'
    ...    ELSE    Set Variable    'test2'
    Log    ${Result}

upload
    ${data}    Set Variable    updateSupport=0
    Log    ${data}
    &{header_dic}=    Create Dictionary    Content-Type=multipart/form-data; boundary=----WebKitFormBoundary7Ky8AVjfvHRVFWh7    Authorization=Bearer 333955b2-9066-46a0-a7e7-214947cd0d4c    Fiddler-Encoding=base6    Cookie=jenkins-timestamper-offset=-28800000; openId=BDrw/MVTIj3MXxJhTvE6q93M9Ekd0nu6fVitwwdbbbX12r4IKF0dz9vadrYF6DiH2ajKyEqiamrrDhTs/4g9vQ==; Admin-Token=333955b2-9066-46a0-a7e7-214947cd0d4c; Admin-Expires-In=43200
    ${path}=    Set Variable    /stage-api/system/user/importData?updateSupport=0
    ${host}=    Set Variable    http://52.130.80.202:12020
    ${user_upload}    Set Variable    E://2021//RIDE//ManageSystem_Api_Test//upload//user_upload.xlsx
    ${file}    Evaluate    (open('${user_upload}','rb'))
    ${file_param}    Create Dictionary    file=${file}
    #创建session
    Create Session    AnGov_Api_Test    ${host}
    #发起Post请求
    ${Resp}    POST On Session    AnGov_Api_Test    ${path}    files=${file_param}    headers=&{header_dic}

setvriable_IF
    ${Result}    Set Variable IF    'name'=='nam2e'    'test1'    'test2'
    Log    ${Result}

IF参数
    @{list}    Create List    1    2    3
    FOR    ${i}    IN    @{list}
        ${info}    Run Keyword IF    ${i}==1 or ${i}==3    set variable    11
        ...    ELSE    Continue For Loop
        Log    ${info}
    END

List
    @{list}    Create List    1    2    3
    FOR    ${i}    IN    @{list}
        Log    ${i}
    END

range
    FOR    ${i}    IN RANGE    1    117
        Log    ${i}
    END

create_http_content
    ${data}    Set Variable    {"deleted": "0", "educationName": "xueli", "endTime": "2001-09-27", "id": "", "professionName": "zhuanye", "resumeId": "879321649776685065", "schoolExperience": "zaixiao", "schoolName": "xuexiao", "startTime": "2005-09-27", "userId": "879321649776685056"}
    Log    ${data}
    &{header_dic}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer 0f567bba-50c5-4c52-9e93-44adf50869de
    ${path}=    Set Variable    /talents/resume/writeEducateExperience
    ${host}=    Set Variable    http://52.130.80.202:12240
    Create Http Context    ${host}    scheme=http
    Set Request Header    Content-Type    application/json
    Set Request Header    Authorization    Bearer 0f567bba-50c5-4c52-9e93-44adf50869de
    Set Request Body    ${data}
    POST    ${path}
    ${status}    Get Response Status
    ${body}    Get Response Body
    Log    ${status}
    Log    ${body}

create_http_content2
    ${data}    Set Variable    {"deleted": "0", "educationName": "xueli", "endTime": "2001-09-27", "id": "", "professionName": "zhuanye", "resumeId": "879321649776685065", "schoolExperience": "zaixiao", "schoolName": "xuexiao", "startTime": "2005-09-27", "userId": "879321649776685056"}
    Log    ${data}
    &{header_dic}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer 0f567bba-50c5-4c52-9e93-44adf50869de
    ${path}=    Set Variable    /talents/resume/writeEducateExperience
    ${host}=    Set Variable    http://52.130.80.202:12240
    Create Http Context    host=52.130.80.202:12821    scheme=http
    GET    /talents/job/search/all
    ${status}    Get Response Status
    ${body}    Get Response Body
    Log    ${status}
    Log    ${body}

jsonvalue
    ${data}    Set Variable    {"code":200,"msg":"户籍详情查询成功","data":{"address":"云南省曲靖市会泽县钟屁街道红石岩社区","houseName":"李测试","peopelNum":"1","familyStatus":null,"queryMemberInfoVos":[{"id":30,"name":"李测试","sex":0,"idCard":"530127198101012020","nameFamily":null,"political":1,"relation":1,"mainPhone":"13000000001","secondPhone":"13000000002","createTime":null,"householdId":6,"memberId":"2107d887-dc3a-4cda-a537-399260e6856d","delFlg":0,"infoStatus":1,"politicalStr":"中共党员","relationStr":"户主","infoStatusStr":"正常","address":"云南省曲靖市会泽县钟屁街道红石岩社区","age":"40","sexStr":"男"}],"listSign":["建档立卡"]},"success":true}
    ${data1}    to json    ${data}
    #获取response比较值
    ${response_value}    Get Json Value    ${data}    /data/listSign
    Log    ${response_value}

string包括子字符串
    ${info}    Set Variable    HTTPError: 500 Server Error: Internal Server Error for url: http://10.10.13.171:8300/street/census/add
    ${value}    Set Variable    HTTPError: 500 Server Error
    ${result}    Find Substring    ${value}    ${info}
    log    ${result}

string_strip
    ${value}    Set Variable    "[残疾家庭]"
    #去除双引号
    ${value}    Evaluate    ${value}.strip()
    Log    ${value}

modify_dictvalue
    ${request_data}    Create Dictionary    a=1    b=2
    Modify Dict    ${request_data}    b    3
    Log    ${request_data}

set_to_dictionary
    ${request_data}    Create Dictionary    a=1    b=2
    Set To Dictionary     ${request_data}    c=3
    Log    ${request_data}

CURDIR
    log    ${CURDIR}
