# Документация Ori

Это путеводитель по документам. Он отвечает на три вопроса: с чего начать, где что лежит и чему можно верить.

## С чего начать

Чтобы разобраться в текущем коде, начните с [блок-схем проекта](https://github.com/Hqzdev/ori-agent/blob/main/docs/architecture/backend.md) и [разбора бэкенда по файлам](#бэкенд-по-файлам).

Для защиты используйте [ТЗ демонстрационной версии Ori](product/ori-defense-specification.md). Материалы по развитию продукта:

1. [План объединения Ori, Pilot Agent и Lumia](product/ori-unification-plan.md) — шесть приложений, общие PostgreSQL, аккаунт и GigaChat; карта переноса и порядок реализации.
2. [Исходное техническое задание Ori](product/ori-technical-specification.md) — план четырёх платформ и матрица ori-01…30.
3. [План разработки](product/ori-product-plan.md) — исходные этапы и оценки до расширения объёма.
4. [Карта модулей](architecture/module-map.md) — существующее разделение кода и ответственности.

Подключение общей авторизации веба: [реализация, настройки и проверки](status/web-ori-auth.md).
Общая PostgreSQL и переход с сайта: [веб-выпуск](status/web-postgres-release.md).
Обмен чатами веба, Mac и iPhone: [общая история](status/shared-chat-history.md).

**Решения от 15 ноября имеют приоритет в вопросах веба, терминала и общего PostgreSQL. Остальные требования определяет ТЗ от 1 ноября 2026.** Октябрьские документы описывают прежнюю версию продукта и могли устареть. План не подтверждает реализацию: состояние проверок смотрите в отчётах.

## Что где лежит

| Папка | Что внутри | Можно ли верить |
| --- | --- | --- |
| `product/` | ТЗ, план разработки и план объединения | Решения от 15 ноября уточняют ТЗ от 1 ноября |
| `architecture/` | Как устроен код: слои Java, пакеты Swift, сборка, контракты, карта модулей | Карта модулей — да. Остальное написано в октябре, сверяйте с ТЗ |
| `rules/` | Правила продукта: разрешения, роли, границы инструментов, хранение данных, словарь понятий | Октябрь. Смысл правил в целом остаётся, детали сверяйте с ТЗ |
| `agents/` | Как работают агенты и оркестратор (тот, кто раздаёт им задачи) | Октябрь |
| `integrations/` | Подключения: MCP-серверы и Google Workspace | MCP и Google — реализованы; настройка описана в workflow guide |
| `design/` | Логотип, персонажи, макеты сайта, правила интерфейса | Персонажи — актуально, остальное октябрь |
| `status/` | Отчёты и доказательства проверок. Текущий блок: [Apple v3](status/apple-v3-implementation.md) | Дата и границы проверки указаны в каждом отчёте |
| `archive/` | Устаревшее: первая версия продукта и старый список из 405 задач | Нет, только для истории |

Макеты экранов лежат не здесь, а в папке `screens/` рядом с `docs/` и в файле `agent.pen`.

## Бэкенд по файлам

Папки ниже повторяют структуру `backend/`. Например, описание `backend/cloud/src/main/java/dev/ori/cloud/storage/CloudDatabase.java` лежит в [`docs/cloud/src/main/java/dev/ori/cloud/storage/CloudDatabase.java.md`](https://github.com/Hqzdev/ori-agent/blob/main/docs/cloud/src/main/java/dev/ori/cloud/storage/CloudDatabase.java.md). На каждой странице есть назначение файла и ссылка на исходник.

| Папка | За что отвечает |
| --- | --- |
| [`api/`](https://github.com/Hqzdev/ori-agent/blob/main/docs/api/README.md) | Локальный HTTP API v2, команды, чтение записей и SSE |
| [`application/`](https://github.com/Hqzdev/ori-agent/blob/main/docs/application/README.md) | Сценарии чата, планирования, задач, подтверждений и работы агентов |
| [`cloud/`](https://github.com/Hqzdev/ori-agent/blob/main/docs/cloud/README.md) | Облачный Java API v1, устройства, relay, квоты и совместная работа |
| [`core/`](https://github.com/Hqzdev/ori-agent/blob/main/docs/core/README.md) | Доменные модели Java v2 и сгенерированные типы общего контракта v3 |
| [`infrastructure/`](https://github.com/Hqzdev/ori-agent/blob/main/docs/infrastructure/README.md) | Адаптеры SQLite, Git, файлов, macOS, GigaChat и почты |
| [`gradle/`](https://github.com/Hqzdev/ori-agent/blob/main/docs/gradle/README.md) | Версии библиотек, проверка зависимостей и Gradle Wrapper |
| [`plans/`](https://github.com/Hqzdev/ori-agent/blob/main/docs/plans/README.md) | Планы и отчёты Apple v1 |

### Файлы в корне `backend/`

- [`README.md`](https://github.com/Hqzdev/ori-agent/blob/main/docs/backend-README.md)
- [`build.gradle.kts`](https://github.com/Hqzdev/ori-agent/blob/main/docs/build.gradle.kts.md)
- [`settings.gradle.kts`](https://github.com/Hqzdev/ori-agent/blob/main/docs/settings.gradle.kts.md)
- [`settings-gradle.lockfile`](https://github.com/Hqzdev/ori-agent/blob/main/docs/settings-gradle.lockfile.md)
- [`gradlew`](https://github.com/Hqzdev/ori-agent/blob/main/docs/gradlew.md)
- [`gradlew.bat`](https://github.com/Hqzdev/ori-agent/blob/main/docs/gradlew.bat.md)

## Как отличить новое от старого

В начале каждого октябрьского документа есть строка «Статус». Если её нет, документ либо новый (1 ноября), либо служебный.

## Простыми словами

- **Ядро** — программа на компьютере, которая делает работу: читает файлы, запускает команды, пишет код.
- **Клиент** — приложение Ori: Mac, iPhone, Android, Windows, веб или терминал. У терминала отдельный кодовый режим без списка чатов.
- **Облако** — наш сервер и общий PostgreSQL. По новому плану он хранит пользовательские данные и выдаёт их клиентам через API; переход от нынешних локальных баз и облачных снимков ещё предстоит выполнить.
- **CEO** — главный агент. Вы говорите с ним, он раздаёт работу остальным и собирает результат.
- **Агент** — помощник с именем, ролью и памятью: дизайнер, исследователь, разработчик.
- **Mote** — маленький помощник на одну узкую задачу. Живёт, пока задача не выполнена.
- **Разрешение** — ваше «да» на конкретное действие. Отправить письмо или запушить код без него нельзя.
- **Relay** — посредник, который передаёт зашифрованные сообщения между телефоном и компьютером. Содержимое он не видит.
- **Шлюз моделей** — сервис, через который все получают ответы GigaChat без своего ключа.

## Где искать ответ

| Вопрос | Куда смотреть |
| --- | --- |
| Что показываем на защите? | [ТЗ демонстрационной версии Ori](product/ori-defense-specification.md), раздел «Сценарий защиты» |
| Какие экраны нужны? | [ТЗ](product/ori-technical-specification.md), раздел «Интерфейс и дизайн», и папка `screens/` |
| Кто за что отвечает в коде? | [Карта модулей](architecture/module-map.md) |
| Какие бывают сущности и состояния задачи? | [Сущности и состояния](architecture/domain-model.md) |
| Когда Ori спрашивает разрешение? | [Разрешения](rules/permission-policy.md) и раздел «Режимы и разрешения» в ТЗ |
| Как агенты передают работу друг другу? | [Оркестратор](agents/orchestrator.md) |
| Как подключить свой MCP-сервер? | [Руководство по MCP](integrations/mcp-developer-guide.md) |
| Как настроить Routines, Teach, Vault, Pages и Team Bots? | [Реализация сценариев и подключений](implementation/workspace-workflows.md) |
| Как хранятся и удаляются данные? | [Данные](rules/data-lifecycle.md) |
| Что уже написано в backend? | `status/backend-implementation-progress.md` |

## Куда переехали файлы

Если в старой ссылке или в коде встретился путь из левого столбца, его нужно искать по новому адресу.

| Было | Стало |
| --- | --- |
| `ori-technical-specification.md`, `ori-product-plan.md` | `product/` |
| `chat-to-run.md`, `roles-and-gates.md`, `permission-policy.md`, `tool-boundaries.md`, `data-lifecycle.md`, `domain-glossary.md`, `platform-matrix.md`, `supported-projects.md`, `optimization.md` | `rules/` |
| `backend-implementation-progress.md`, `installation-environment.md`, `documentation-review.md`, `verification/` | `status/` |
| `product-scope.md`, `acceptance-matrix.md`, `implementation-plan.md` | `archive/` |
| прежний `README.md` (указатель за октябрь) | `archive/october-readme.md` |

Папки `architecture/`, `agents/`, `integrations/` и `design/` остались на месте.

## Правила для новых документов

1. Один документ — одна тема. Положите его в подходящую папку. Если подходящей нет, сначала решите, нужна ли новая, и только потом создавайте.
2. Сразу после заголовка в одной фразе объясните простыми словами, зачем нужен документ.
3. Если новый документ заменяет старый, добавьте в старый строку «Статус: устарело» со ссылкой на новый.
4. Не копируйте текст ТЗ, а ссылайтесь на него. Иначе через неделю будет два разных текста.
5. Пишите так, чтобы понял человек, который не видел код: короткие предложения, без лишних английских слов.

Системные приложения Apple: [подключение, архитектура доступа и проверка](integrations/apple-apps.md).
