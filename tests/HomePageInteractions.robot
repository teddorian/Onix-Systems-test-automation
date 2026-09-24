*** Settings ***
Library     SeleniumLibrary
Library     Collections
Resource    ../common_data.resource
Resource    ../pages/homePage.resource
Resource    ../pages/cooperation_models.resource
Resource    ../pages/contactForm.resource
Resource    ../pages/testimonials.resource
Resource    ../pages/faq.resource
Test Setup       Open Home Page
Test Teardown    Close Browsers

*** Variables ***
@{COOPERATION_MODELS}    Staff augmentation    Dedicated team    Time & materials
...                      Fixed price    Full-process development
@{NAVIGATION_SECTIONS}   Solutions    Industries    Services    How We Work    Partnership
...                      Case Studies    Company    Blog
${EXPECTED_HEADING}      Custom IT Services
${CASE_STUDIES_URL}      ${BASE_URL}/case-studies

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

TC3 Verify Home Page Metadata
    [Documentation]    Guards the SEO essentials: exactly one H1, a non-empty
    ...    description and a canonical pointing at the homepage itself.
    ${headings}=    Get Element Count    ${PAGE_HEADING}
    Should Be Equal As Integers    ${headings}    1
    ...    msg=Home page must expose exactly one H1
    Element Text Should Be    ${PAGE_HEADING}    ${EXPECTED_HEADING}
    ${description}=    Get Element Attribute    ${META_DESCRIPTION}    content
    Should Not Be Empty    ${description}    msg=Meta description is missing
    ${canonical}=    Get Element Attribute    ${CANONICAL_LINK}    href
    Should Be Equal    ${canonical}    ${BASE_URL}/

TC4 Verify Main Navigation Sections
    [Documentation]    Every top-level section is offered in the header.
    FOR    ${section}    IN    @{NAVIGATION_SECTIONS}
        Verify Navigation Section Is Present    ${section}
    END

TC5 Verify Hero Call To Action Opens Case Studies
    Wait Until Element Is Visible    ${SEE_OUR_CASES}
    Click Element    ${SEE_OUR_CASES}
    Wait Until Location Is    ${CASE_STUDIES_URL}
    Wait Until Element Is Visible    ${PAGE_HEADING}

TC6 Verify Contact Form Exposes All Required Fields
    [Documentation]    Structure only. The form posts to a real sales inbox, so the
    ...    suite never submits it; asserting the contract is the safe equivalent.
    Open Contact Form
    FOR    ${field}    IN    @{REQUIRED_FIELDS}
        Verify Required Field Is Present    ${field}
    END
    Element Should Be Visible    xpath=//textarea[@name='message']
    Element Should Be Visible    ${SUBMIT_BUTTON}

TC7 Verify Testimonials Slider Previous Button Disabled On First Slide
    [Documentation]    The slider opens on its first slide, so stepping back is
    ...    not possible until the visitor has moved forward at least once.
    Open Testimonials Slider
    Previous Slide Button Should Be Disabled
    Click Next Slide
    Previous Slide Button Should Be Enabled

TC8 Verify FAQ Items Expand Independently And Toggle
    [Documentation]    Unlike the cooperation models, FAQ items are independent: opening
    ...    one leaves the others as they are, and clicking an open item closes it.
    Open FAQ Section
    All FAQ Items Should Be Collapsed
    Toggle FAQ Item    1
    FAQ Item Should Be Expanded    1
    Toggle FAQ Item    2
    FAQ Item Should Be Expanded    2
    FAQ Item Should Be Expanded    1
    Toggle FAQ Item    2
    FAQ Item Should Be Collapsed    2
    FAQ Item Should Be Expanded    1
