
*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${SERVICES}    //div[contains(@class, 'navLink_link__IeqdD') and contains(text(), 'SERVICES')]
${SPEAK_TO_EXPERT}    //span[text()='Speak to our expert']

*** Keywords ***
Verify User Can Send Contact Form
    Click Element    ${SPEAK_TO_EXPERT}
    Input Text    //input[@name='name' and @type='text' and @required and @value='']   testName
    Input Text    //input[@name="company"][@type="text"][@required][@value]   testCompany
    Input Text    (//textarea[@name="message"][@required])[1]   testDetails
    Input Text    (//input[@name='email'][@type="text"])[1]   test@test.com
    Click Element    //div[contains(@class, 'contactForm_btnWrapper')]//span[text()='Get in touch']

#User Open links from Menu
User Click Services In Menu
    Click Element    ${SERVICES}
User Open Dedicated Team Calculator
    Click Element    //a[contains(text(), 'Dedicated Team Calculator')]
