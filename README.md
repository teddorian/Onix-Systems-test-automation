# Onix Systems — UI Test Automation

[![UI Tests](https://github.com/teddorian/Onix-Systems-test-automation/actions/workflows/ui-tests.yml/badge.svg)](https://github.com/teddorian/Onix-Systems-test-automation/actions/workflows/ui-tests.yml)

UI test automation for the public [onix-systems.com](https://onix-systems.com) website,
written with Robot Framework + SeleniumLibrary.

## Structure

```
common_data.resource        # shared variables (BASE_URL, etc.)
pages/                      # page objects: locators and keywords
  homePage.resource
  cooperation_models.resource
  contactForm.resource
tests/                      # test cases
  HomePageInteractions.robot
  openCalculator.robot
```

## Requirements

- Python 3.12+
- Google Chrome (ChromeDriver is resolved automatically by Selenium Manager)

## Installation

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Running

All tests:

```bash
robot tests/
```

A single suite:

```bash
robot tests/openCalculator.robot
```

Headless (same as CI):

```bash
robot -v 'CHROME_OPTIONS:add_argument("--headless=new"); add_argument("--window-size=1920,1080")' tests/
```

The site is built with utility CSS classes that change on every deploy, so
locators are anchored only to visible text and stable data attributes. The
window size is set explicitly: the cooperation-models section is a
horizontal accordion, and its panels collapse at narrow widths.

Reports (`log.html`, `report.html`, `output.xml`) and failure screenshots
are generated in the working directory and are deliberately not versioned.

## CI

Tests run in GitHub Actions on every push and pull request to `main`, and
can also be triggered manually via **Actions → UI Tests → Run workflow**.

The runner (`ubuntu-latest`) installs dependencies from `requirements.txt`,
Chrome with a matching ChromeDriver, and runs the suite under a virtual
display (Xvfb) — so the `.robot` files don't need a headless flag, and a
local run behaves exactly like CI.

Robot Framework's reports (`log.html`, `report.html`, `output.xml`) are
published as the `robot-framework-results` build artifact, including for
failed runs.

## Coverage

Home page:

| Test | What it checks |
|------|-----------------|
| TC1 | Smoke: the hero block and header render, the tab title is set |
| TC2 | Cooperation-models accordion: all five expand and show a description |
| TC3 | Metadata: exactly one H1, a non-empty description, a canonical URL |
| TC4 | All main-menu sections are present |
| TC5 | The hero "See our cases" button navigates to `/case-studies` |
| TC6 | The contact form exposes all required fields |
| TC7 | Testimonials slider: "Previous" is disabled on the first slide and enabled after stepping forward |
| TC8 | FAQ accordion: all items start collapsed, open independently of each other, and a second click collapses an item |

Dedicated Team Calculator: the calculator steps and the request form render.

### Deliberate gaps

- **The form is not submitted.** It posts to a real sales inbox, so only the
  field contract is checked. A full submission scenario would need a test
  environment or a mock endpoint.
- **The mobile menu is not covered.** The burger button has no stable hook,
  and anchoring to utility classes would produce a flaky test.
- **Console errors are not checked.** The page consistently logs errors from
  third-party scripts (GTM, DoubleClick), which would make such a check
  meaningless.
- **Broken links are not checked.** This would require an HTTP layer on top
  of the UI suite.

### Defects found

- 2 of 65 images on the home page have no `alt` attribute — an
  accessibility violation. No test was added for this deliberately, to keep
  the suite green; it's a bug report, not a test case.
- The contact-form modal has neither `role="dialog"` nor `aria-modal`, so
  assistive technology is not told that a dialog has opened.
- An invalid email (e.g. `not-an-email`) gets no visual feedback: no inline
  message and no `aria-invalid`. The submit button stays disabled behind the
  reCAPTCHA exactly as it does for a valid address, so the error is hidden
  from the user.
