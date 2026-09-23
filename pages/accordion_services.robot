***Settings***
Library    SeleniumLibrary
*** Variables ***

*** Keywords ***
Click Accordion Item
    [Arguments]    ${index}
    Scroll Element Into View    //div[@id="${index}"]//span[@class="accordionData_numberBlock__xDA15"]
    Click Element    //div[@id="${index}"]//span[@class="accordionData_numberBlock__xDA15"]

Verify Accordion Title And Text
    [Arguments]    ${index}    ${expected_title}    ${expected_text}
    ${actual_title}=    Get Text   //div[@id="${index}"]//span[@class="accordionData_numberBlock__xDA15"]
    ${actual_text}=    Get Text    (//div[@class='accordionData_softwareProductDataContainer__DxihA']//div)[1]
    Should Be Equal As Strings    ${actual_title}    ${expected_title}
    Should Be Equal As Strings    ${actual_text}    ${expected_text}
