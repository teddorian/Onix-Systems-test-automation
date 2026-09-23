*** Settings ***
Library    SeleniumLibrary
Resource   ../common_data.resource
# The form is reached through the home page hero button, so that locator's
# owner is imported explicitly instead of relying on the suite to load it.
Resource   homePage.resource

*** Variables ***
${SUBMIT_BUTTON}     xpath=//button[normalize-space()='Get in touch']
@{REQUIRED_FIELDS}   name    email    company    country

*** Keywords ***
Contact Field
    [Arguments]    ${name}
    RETURN    xpath=//input[@name='${name}']

Open Contact Form
    Wait Until Element Is Visible    ${TALK_TO_EXPERT}
    Click Element    ${TALK_TO_EXPERT}
    Wait Until Element Is Visible    ${SUBMIT_BUTTON}

Verify Required Field Is Present
    [Arguments]    ${name}
    ${locator}=    Contact Field    ${name}
    Wait Until Element Is Visible    ${locator}
    Element Attribute Value Should Be    ${locator}    required    true
    ...    msg=Field '${name}' is no longer marked as required
