*** Settings ***
Library    SeleniumLibrary
Resource   ../common_data.resource

*** Variables ***
# The site is built with utility CSS classes that change on every deploy,
# so locators are anchored to visible text and stable data attributes only.
${COOKIE_ACCEPT}      xpath=//button[contains(@class, 'cky-btn-accept')]
${TALK_TO_EXPERT}     xpath=//button[normalize-space()='Talk to an expert']
${SEE_OUR_CASES}      xpath=//button[normalize-space()='See our cases']
${CASE_STUDIES_LINK}  xpath=//a[normalize-space()='View case studies']
${SERVICES_MENU}      xpath=//header//button[.//span[normalize-space()='Services']]

*** Keywords ***
Open Home Page
    Open Page    ${BASE_URL}

Open Calculator Page
    Open Page    ${CALCULATOR_URL}

Open Page
    [Arguments]    ${url}
    Open Browser    ${url}    ${BROWSER}    options=${CHROME_OPTIONS}
    Set Selenium Timeout    ${TIMEOUT}
    Wait For Document Ready
    Accept Cookies If Present

Wait For Document Ready
    [Documentation]    CI runners are slower than a laptop, so give the bundle time
    ...    to finish before asserting on anything it renders.
    Wait Until Keyword Succeeds    ${TIMEOUT}    1s    Document Should Be Complete

Document Should Be Complete
    ${state}=    Execute Javascript    return document.readyState;
    Should Be Equal    ${state}    complete

Accept Cookies If Present
    [Documentation]    The CookieYes banner is injected asynchronously and does not
    ...    always appear (it depends on a previously stored consent cookie), so its
    ...    absence must not fail the test.
    ${shown}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${COOKIE_ACCEPT}    timeout=10s
    IF    ${shown}
        Click Element    ${COOKIE_ACCEPT}
        Wait Until Element Is Not Visible    ${COOKIE_ACCEPT}    timeout=10s
    END

Close Browsers
    Close All Browsers
