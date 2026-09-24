*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}          https://onix-systems.com
${CALCULATOR_URL}    ${BASE_URL}/dedicated-team-calculator
${BROWSER}           chrome
# Override from CI, e.g. robot -v CHROME_OPTIONS:add_argument("--headless=new")
${CHROME_OPTIONS}    add_argument("--window-size=1920,1080")
${TIMEOUT}           40s

*** Keywords ***
Scroll To Center
    [Documentation]    Sections reveal themselves on scroll, and SeleniumLibrary's
    ...    Scroll Element Into View aligns to the top edge, which is not always
    ...    enough to trigger that. Centring the element is.
    [Arguments]    ${locator}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].scrollIntoView({block: "center"});    ARGUMENTS    ${element}
