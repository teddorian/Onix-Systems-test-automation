# Onix Systems — UI Test Automation

[![UI Tests](https://github.com/teddorian/Onix-Systems-test-automation/actions/workflows/ui-tests.yml/badge.svg)](https://github.com/teddorian/Onix-Systems-test-automation/actions/workflows/ui-tests.yml)

UI-автотесты для публичного сайта [onix-systems.com](https://onix-systems.com),
написанные на Robot Framework + SeleniumLibrary.

## Структура

```
common_data.resource        # общие переменные (BASE_URL)
pages/                      # page objects: локаторы и keywords
  homePage.resource
  cooperation_models.resource
  contactForm.resource
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

Headless (так же, как в CI):

```bash
robot -v 'CHROME_OPTIONS:add_argument("--headless=new"); add_argument("--window-size=1920,1080")' tests/
```

Сайт верстается utility-классами, которые меняются при каждом деплое, поэтому
локаторы привязаны только к видимому тексту и устойчивым data-атрибутам.
Размер окна задаётся явно: секция моделей сотрудничества — горизонтальная
«гармошка», и при узком окне её панели схлопываются.

Отчёты (`log.html`, `report.html`, `output.xml`) и скриншоты падений
генерируются в рабочей директории и намеренно не версионируются.

## CI

Тесты запускаются в GitHub Actions при каждом push и pull request в `main`,
а также вручную через **Actions → UI Tests → Run workflow**.

Раннер (`ubuntu-latest`) ставит зависимости из `requirements.txt`, Chrome
с совместимым ChromeDriver, и гоняет набор под виртуальным дисплеем Xvfb —
поэтому `.robot`-файлы не требуют headless-флага и локальный запуск ничем
не отличается от CI.

Отчёты Robot Framework (`log.html`, `report.html`, `output.xml`) публикуются
как артефакт сборки `robot-framework-results` — в том числе для упавших
прогонов.

## Покрытие

Главная страница:

| Тест | Что проверяет |
|------|---------------|
| TC1 | Смоук: hero-блок и шапка отрисованы, заголовок вкладки |
| TC2 | Гармошка моделей сотрудничества: все пять раскрываются и показывают описание |
| TC3 | Метаданные: ровно один H1, непустой description, канонический URL |
| TC4 | Все разделы главного меню присутствуют |
| TC5 | Hero-кнопка «See our cases» ведёт на `/case-studies` |
| TC6 | Контактная форма отдаёт все обязательные поля |

Калькулятор выделенной команды: шаги расчёта и форма заявки отрисованы.

### Осознанные пробелы

- **Форма не отправляется.** Она уходит в реальный отдел продаж, поэтому
  проверяется только контракт полей. Полный сценарий отправки требует стенда
  или мок-эндпоинта.
- **Мобильное меню не покрыто.** Бургер не имеет устойчивого хука, а привязка
  к utility-классам дала бы флакающий тест.
- **Консольные ошибки не проверяются.** Страница стабильно логирует ошибки
  сторонних скриптов (GTM, DoubleClick), на этом фоне проверка бессмысленна.
- **Битые ссылки не проверяются.** Требует HTTP-слоя поверх UI-набора.

### Найденные дефекты

- 2 из 65 изображений главной страницы без атрибута `alt` — нарушение
  доступности. Тест намеренно не добавлен, чтобы набор оставался зелёным;
  это заявка на баг, а не на автотест.
