*** Settings ***
Library     SeleniumLibrary
Resource    ../common_data.resource
Resource    ../pages/homePage.resource
Test Setup       Open Calculator Page
Test Teardown    Close Browsers

*** Variables ***
${DURATION_STEP}    xpath=//h3[normalize-space()='4. Specify project duration']
${CONTACT_FORM}     xpath=//h4[normalize-space()='Start your project with Onix']
${STACK_STEP}       xpath=//h3[normalize-space()='2. Choose required technology stack']

*** Test Cases ***
TC1 Verify User Can Open Dedicated Team Calculator
    [Documentation]    All calculator steps and the contact form are rendered.
    Wait Until Element Is Visible    ${STACK_STEP}
    Wait Until Element Is Visible    ${DURATION_STEP}
    Wait Until Element Is Visible    ${CONTACT_FORM}
