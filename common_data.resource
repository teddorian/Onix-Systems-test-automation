*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}          https://onix-systems.com
${CALCULATOR_URL}    ${BASE_URL}/dedicated-team-calculator
${BROWSER}           chrome
# Override from CI, e.g. robot -v CHROME_OPTIONS:add_argument("--headless=new")
${CHROME_OPTIONS}    add_argument("--window-size=1920,1080")
${TIMEOUT}           40s
