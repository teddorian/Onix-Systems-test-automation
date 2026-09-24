*** Settings ***
Library    SeleniumLibrary
Resource   ../common_data.resource

*** Variables ***
# The page carries three sliders that share the same aria-labels, so the
# controls are scoped to the section wrapper that holds the Testimonials
# heading rather than matched globally.
${TESTIMONIALS_HEADING}    xpath=//h2[normalize-space()='Testimonials']
${TESTIMONIALS_SLIDER}
...    ${TESTIMONIALS_HEADING}/ancestor::div[.//button[@aria-label='Previous slide']][1]
${PREVIOUS_SLIDE}          ${TESTIMONIALS_SLIDER}//button[@aria-label='Previous slide']
${NEXT_SLIDE}              ${TESTIMONIALS_SLIDER}//button[@aria-label='Next slide']

*** Keywords ***
Open Testimonials Slider
    Wait Until Page Contains Element    ${TESTIMONIALS_HEADING}
    Scroll To Center    ${TESTIMONIALS_HEADING}
    Wait Until Element Is Visible    ${PREVIOUS_SLIDE}
    Wait Until Element Is Visible    ${NEXT_SLIDE}

Previous Slide Button Should Be Disabled
    [Documentation]    Asserts the disabled attribute, not mere visibility: the
    ...    control stays on screen and only greys out on the first slide.
    Element Should Be Disabled    ${PREVIOUS_SLIDE}

Previous Slide Button Should Be Enabled
    Element Should Be Enabled    ${PREVIOUS_SLIDE}

Click Next Slide
    Element Should Be Enabled    ${NEXT_SLIDE}
    Click Element    ${NEXT_SLIDE}
