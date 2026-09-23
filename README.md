# Onix Systems — UI Test Automation

UI-автотесты для публичного сайта [onix-systems.com](https://onix-systems.com),
написанные на Robot Framework + SeleniumLibrary.

## Структура

```
common_data.resource        # общие переменные (BASE_URL)
pages/                      # page objects: локаторы и keywords
  homePage.resource
  accordion_services.robot
tests/                      # тест-кейсы
  HomePageInteractions.robot
  openCalculator.robot
```

## Требования

- Python 3.12+
- Google Chrome (ChromeDriver подтягивается Selenium Manager автоматически)

## Установка

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Запуск

Все тесты:

```bash
robot tests/
```

Один набор:

```bash
robot tests/openCalculator.robot
```

Отчёты (`log.html`, `report.html`, `output.xml`) и скриншоты падений
генерируются в рабочей директории и намеренно не версионируются.
