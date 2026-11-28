# Облачный Java-сервис

Отдельный Spring Boot-процесс обслуживает API v1: аккаунты, устройства, relay, модельные квоты, координацию исполнения, команды и публикации. Хранилище этого модуля использует SQLite.

[Папка исходников](../../backend/cloud) · [Блок-схемы проекта](../architecture/backend.md)

## С чего начать

- [CloudServer](src/main/java/dev/ori/cloud/CloudServer.java.md)
- [CloudConfiguration](src/main/java/dev/ori/cloud/CloudConfiguration.java.md)
- [CloudDatabase](src/main/java/dev/ori/cloud/storage/CloudDatabase.java.md)
- [CloudAuthController](src/main/java/dev/ori/cloud/web/CloudAuthController.java.md)
- [CloudRelayController](src/main/java/dev/ori/cloud/web/CloudRelayController.java.md)
- [CloudModelController](src/main/java/dev/ori/cloud/web/CloudModelController.java.md)

## Разделы

| Путь в модуле | Ответственность |
| --- | --- |
| [`deploy`](deploy/index.md) | Контейнер и HTTPS-прокси для облачного Java API. |
| [`src/main/java/dev/ori/cloud`](src/main/java/dev/ori/cloud/index.md) | Точка входа, конфигурация Spring, ошибки и секреты. |
| [`src/main/java/dev/ori/cloud/collaboration`](src/main/java/dev/ori/cloud/collaboration/index.md) | Команды, приглашения, боты и публикации по ссылке. |
| [`src/main/java/dev/ori/cloud/execution`](src/main/java/dev/ori/cloud/execution/index.md) | Назначения и аренда выполнения для доверенного устройства. |
| [`src/main/java/dev/ori/cloud/identity`](src/main/java/dev/ori/cloud/identity/index.md) | Аккаунты, токены, сессии, браузерный вход и доверие устройств. |
| [`src/main/java/dev/ori/cloud/model`](src/main/java/dev/ori/cloud/model/index.md) | Запрос модели, резервирование дневной квоты и учёт расхода. |
| [`src/main/java/dev/ori/cloud/relay`](src/main/java/dev/ori/cloud/relay/index.md) | Пакеты, вложения и снимки, доступные доверенным устройствам. |
| [`src/main/java/dev/ori/cloud/storage`](src/main/java/dev/ori/cloud/storage/index.md) | Транзакции, создание таблиц и хранение записей облака. |
| [`src/main/java/dev/ori/cloud/web`](src/main/java/dev/ori/cloud/web/index.md) | Контроллеры v1 и общий HTTP-слой. |
| [`src/main/resources`](src/main/resources/index.md) | Параметры Spring Boot, базы, квот и relay. |
| [`src/test/java/dev/ori/cloud`](src/test/java/dev/ori/cloud/index.md) | Тесты сервисов, авторизации, совместной работы и релизов. |

## Файлы в корне модуля

- [Dockerfile](Dockerfile.md)
- [Dockerfile.dockerignore](Dockerfile.dockerignore.md)
- [build.gradle.kts](build.gradle.kts.md)
- [gradle.lockfile](gradle.lockfile.md)
