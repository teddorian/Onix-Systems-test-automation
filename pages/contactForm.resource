*** Settings ***
Library    SeleniumLibrary
Resource   ../common_data.resource

*** Variables ***
${FORM_HEADING}      xpath=//*[contains(normalize-space(), 'Tell us about your product idea')]
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
