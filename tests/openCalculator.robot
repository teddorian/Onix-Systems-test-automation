*** Settings ***
Library  SeleniumLibrary
Resource  ../common_data.resource
Resource  ../pages/homePage.resource
Test Setup  Precondition Steps Before Each Test
Test Teardown  Teardown Steps After All Tests

*** Test Cases ***
TC1 Verify User Can Open Dedicated Team Calculator
   User Click Services In Menu
   User Open Dedicated Team Calculator
   Wait Until Element Is Visible    //h3[contains(@class, 'mainTitle_default')][contains(@class, 'DTCCalculator_sectionTitle')][text()='4. Specify project duration']
   Wait Until Element Is Visible    //h4[contains(@class, 'mainTitle_default')][contains(@class, 'DTCContactForm_formTitle')]

*** Keywords ***
Precondition Steps Before Each Test
    Open Browser    ${BASE_URL}    chrome

Teardown Steps After All Tests
    Close All Browsers
