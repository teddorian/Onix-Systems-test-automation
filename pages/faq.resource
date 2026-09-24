*** Settings ***
Library    SeleniumLibrary
Resource   ../common_data.resource

*** Variables ***
# The FAQ is a custom accordion with no <details>, buttons or aria-expanded,
# so items are addressed through the section heading and question order.
# An answer is mounted only while its item is open and removed once closed.
${FAQ_HEADING}    xpath=//h2[normalize-space()='FAQs']
${FAQ_SECTION}    //h2[normalize-space()='FAQs']/ancestor::div[count(.//h3) > 3][1]
${FAQ_ANSWERS}    xpath=${FAQ_SECTION}//h3/../following-sibling::*

*** Keywords ***
FAQ Question
    [Arguments]    ${index}
    RETURN    xpath=(${FAQ_SECTION}//h3)[${index}]

FAQ Answer
    [Arguments]    ${index}
    RETURN    xpath=(${FAQ_SECTION}//h3)[${index}]/../following-sibling::*[1]

Open FAQ Section
    Wait Until Page Contains Element    ${FAQ_HEADING}
    Scroll To Center    ${FAQ_HEADING}
    # Guards the collapsed-state check below against passing on an empty match.
    ${questions}=    Get Element Count    xpath=${FAQ_SECTION}//h3
    Should Be True    ${questions} >= 2
    ...    msg=FAQ section is missing or lists fewer than two questions

FAQ Should Have No Running Animations
    ${section}=    Get WebElement    xpath=${FAQ_SECTION}
    ${running}=    Execute Javascript    return arguments[0].getAnimations({subtree: true}).filter(a => a.playState === 'running').length;    ARGUMENTS    ${section}
    Should Be Equal As Integers    ${running}    0

Wait For FAQ Animations To Finish
    [Documentation]    Items open and close through Web Animations, so wait for the
    ...    section to have none running rather than sleeping for a fixed time.
    Wait Until Keyword Succeeds    ${TIMEOUT}    100ms    FAQ Should Have No Running Animations

All FAQ Items Should Be Collapsed
    Wait For FAQ Animations To Finish
    Page Should Not Contain Element    ${FAQ_ANSWERS}
    ...    message=FAQ should load with every item collapsed

Toggle FAQ Item
    [Documentation]    Waits for the clicked item's own state to flip before waiting
    ...    for animations: checking for "no animations" straight after the click can
    ...    run before they start and let a neighbour's collapse go unnoticed.
    [Arguments]    ${index}
    ${question}=    FAQ Question    ${index}
    ${answer}=      FAQ Answer    ${index}
    ${was_open}=    Run Keyword And Return Status    Element Should Be Visible    ${answer}
    Scroll To Center    ${question}
    Wait Until Element Is Visible    ${question}
    Click Element    ${question}
    IF    ${was_open}
        Wait Until Page Does Not Contain Element    ${answer}
        ...    error=FAQ item ${index} did not collapse after clicking its question
    ELSE
        Wait Until Element Is Visible    ${answer}
        ...    error=FAQ item ${index} did not expand after clicking its question
    END
    Wait For FAQ Animations To Finish

FAQ Item Should Be Expanded
    [Arguments]    ${index}
    ${answer}=    FAQ Answer    ${index}
    # A collapsed answer is unmounted, and Element Should Be Visible ignores its
    # message for a missing element, so presence is asserted separately first.
    Page Should Contain Element    ${answer}
    ...    message=FAQ item ${index} should be expanded, but its answer is not rendered
    Element Should Be Visible    ${answer}
    ...    message=FAQ item ${index} should be expanded
    ${text}=    Get Text    ${answer}
    Should Not Be Empty    ${text}
    ...    msg=FAQ item ${index} is expanded but shows no answer

FAQ Item Should Be Collapsed
    [Arguments]    ${index}
    ${answer}=    FAQ Answer    ${index}
    Element Should Not Be Visible    ${answer}
    ...    message=FAQ item ${index} should be collapsed
