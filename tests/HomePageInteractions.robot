*** Settings ***
Library     SeleniumLibrary
Library     Collections
Resource    ../common_data.resource
Resource    ../pages/homePage.resource
Resource    ../pages/cooperation_models.resource
Test Setup       Open Home Page
Test Teardown    Close Browsers

*** Variables ***
@{COOPERATION_MODELS}    Staff augmentation    Dedicated team    Time & materials
...                      Fixed price    Full-process development

*** Test Cases ***
TC1 Verify User Can Open Home Page
    [Documentation]    The hero section and the main navigation are rendered.
    Wait Until Element Is Visible    ${TALK_TO_EXPERT}
    Wait Until Element Is Visible    ${SEE_OUR_CASES}
    Wait Until Element Is Visible    ${SERVICES_MENU}
    ${title}=    Get Title
    Should Contain    ${title}    Onix

TC2 Verify Cooperation Models Accordion
    [Documentation]    Every cooperation model is listed and expands into a description.
    FOR    ${model}    IN    @{COOPERATION_MODELS}
        Open Cooperation Model    ${model}
        Verify Cooperation Model Has Description    ${model}
    END
