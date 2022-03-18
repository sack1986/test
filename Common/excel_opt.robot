*** Settings ***
Library           ExcelLibrary
Library           NewLibrary

*** Keywords ***
Excel_Opt
    [Arguments]    ${sheet_name}    ${file_path}
    Open Excel    ${file_path}
    @{case_name_value}    get column values    ${sheet_name}    0
    @{request_type_value}    get column values    ${sheet_name}    1
    @{api_value}    get column values    ${sheet_name}    2
    @{request_data_value}    get column values    ${sheet_name}    3
    @{expect_data_value}    get column values    ${sheet_name}    4
    @{expect_path_value}    get column values    ${sheet_name}    5
    @{response_path_value}    get column values    ${sheet_name}    6
    @{api_name_value}    get column values    ${sheet_name}    7
    @{table_name_value}    get column values    ${sheet_name}    8
    ${count_row}    get row count    ${sheet_name}
    FOR    ${i}    IN RANGE    1    ${count_row}
        ${case_name}    Set Variable    ${case_name_value}[${i}][1]
        ${request_type}    Set Variable    ${request_type_value}[${i}][1]
        ${api}    Set Variable    ${api_value}[${i}][1]
        ${request_data}    Set Variable    ${request_data_value}[${i}][1]
        ${expect_data}    Set Variable    ${expect_data_value}[${i}][1]
        ${expect_path}    Set Variable    ${expect_path_value}[${i}][1]
        ${response_path}    Set Variable    ${response_path_value}[${i}][1]
        ${api_name}    Set Variable    ${api_name_value}[${i}][1]
        ${table_name}    Set Variable    ${table_name_value}[${i}][1]
        ExecNonQuery    ${case_name}    ${request_type}    ${api}    ${request_data}    ${expect_data}    ${expect_path}    ${response_path}    ${api_name}    ${table_name}
    END
