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
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${CHROME_OPTIONS}
    Set Selenium Timeout    ${TIMEOUT}
    Accept Cookies If Present

Open Calculator Page
    Open Browser    ${CALCULATOR_URL}    ${BROWSER}    options=${CHROME_OPTIONS}
    Set Selenium Timeout    ${TIMEOUT}
    Accept Cookies If Present

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
