*** Settings ***
Library    SeleniumLibrary
Resource   ../common_data.resource

*** Keywords ***
Cooperation Model Tab
    [Documentation]    Collapsed panels are 80px wide strips holding the model name
    ...    as vertical text; this is the element that expands a panel when clicked.
    [Arguments]    ${title}
    RETURN    xpath=//p[normalize-space()='${title}']

Cooperation Model Heading
    [Arguments]    ${title}
    RETURN    xpath=//h3[normalize-space()='${title}']

Open Cooperation Model
    [Documentation]    Models live in a horizontal accordion: only the active panel
    ...    has width, so every other heading is clipped and reported as not visible
    ...    until its tab is clicked.
    [Arguments]    ${title}
    ${tab}=        Cooperation Model Tab    ${title}
    ${heading}=    Cooperation Model Heading    ${title}
    Wait Until Page Contains Element    ${tab}
    Scroll To Center    ${tab}
    Wait Until Element Is Visible    ${tab}
    Click Element    ${tab}
    Wait Until Element Is Visible    ${heading}

Verify Cooperation Model Has Description
    [Documentation]    Assert the expanded panel shows copy, without pinning the
    ...    marketing text itself, which changes often.
    [Arguments]    ${title}
    ${heading}=    Cooperation Model Heading    ${title}
    ${description}=    Get Text    ${heading}/../following-sibling::div[1]
    Should Not Be Empty    ${description}
    ...    msg=Cooperation model '${title}' was opened but shows no description
