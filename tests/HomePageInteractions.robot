*** Settings ***
Library  SeleniumLibrary
Library    Collections
Resource  ../common_data.resource
Resource  ../pages/homePage.resource
Resource  ../pages/accordion_services.robot
Test Setup  Precondition Steps Before Each Test
Test Teardown  Teardown Steps After All Tests

*** Variables ***
${VIEW_CASE_BUTTON}    //span[text()="View case studies"]
${START_LOCATOR}    //span[@class="accordionData_numberBlock__xDA15"][text()="01"]
${NUM_ELEMENTS}    14
*** Test Cases ***
TC1 Verify User Can Open Home Page
   Wait until Element is visible    ${SPEAK_TO_EXPERT}
   Scroll Element Into View  ${VIEW_CASE_BUTTON}
   Wait Until Element Is Visible    ${VIEW_CASE_BUTTON}
   Wait until Element is visible    //p[contains(text(),'Kropyvnytskyi')]

TC2 Loop Through Accordion and Verify
   Wait Until Element Is Visible    xpath=//span[@class="accordionData_numberBlock__xDA15"]    timeout=1s
   @{expected_titles}=    Create List    Web development    Mobile development    UI/UX design    Title 4    Title 5    Title 6    Title 7    Title 8    Title 9    Title 10    Title 11    Title 12    Title 13    Title 14
   @{expected_texts}=    Create List    Text 1    Text 2    Text 3    Text 4    Text 5    Text 6    Text 7    Text 8    Text 9    Text 10    Text 11    Text 12    Text 13    Text 14
   FOR    ${index}    IN RANGE    1    15
   Click Accordion Item    ${index}
   Verify Accordion Title And Text    ${index}    ${expected_titles}[${index-1}]    ${expected_texts}[${index-1}]
   END
*** Keywords ***
Precondition Steps Before Each Test
    Open Browser    ${BASE_URL}    chrome
    Click Element    //button[@aria-label='Accept All' and @class='cky-btn cky-btn-accept' and @data-cky-tag='detail-accept-button' and text()='Accept All']
Teardown Steps After All Tests
    Close All Browsers
