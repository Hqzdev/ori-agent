# Инфраструктурные адаптеры Java

Реализации прикладных портов для SQLite, журналов событий, файлов, Git, гостевой macOS, Keychain, GigaChat и почты. Конкретные адаптеры выбирает конфигурация сервера.

[Папка исходников](../../backend/infrastructure) · [Блок-схемы проекта](../architecture/backend.md)

## С чего начать

- [SqliteWorkspaceStore](src/main/java/dev/ori/infrastructure/workspace/database/SqliteWorkspaceStore.java.md)
- [LocalArtifactStore](src/main/java/dev/ori/infrastructure/workspace/artifacts/LocalArtifactStore.java.md)
- [VirtualMachineProcessGateway](src/main/java/dev/ori/infrastructure/workspace/execution/VirtualMachineProcessGateway.java.md)
- [LocalGitGateway](src/main/java/dev/ori/infrastructure/workspace/git/LocalGitGateway.java.md)
- [GigaChatGateway](src/main/java/dev/ori/infrastructure/workspace/provider/GigaChatGateway.java.md)

## Разделы

| Путь в модуле | Ответственность |
| --- | --- |
| [`src/main/java/dev/ori/infrastructure/database`](src/main/java/dev/ori/infrastructure/database/index.md) | Транзакционный адаптер проектов, запусков, спецификаций и задач раннего API. |
| [`src/main/java/dev/ori/infrastructure/workspace`](src/main/java/dev/ori/infrastructure/workspace/index.md) | Кодирование JSON и блокировка установки. |
| [`src/main/java/dev/ori/infrastructure/workspace/artifacts`](src/main/java/dev/ori/infrastructure/workspace/artifacts/index.md) | Хранение бинарного содержимого в локальном каталоге. |
| [`src/main/java/dev/ori/infrastructure/workspace/configuration`](src/main/java/dev/ori/infrastructure/workspace/configuration/index.md) | Чтение параметров развёртывания. |
| [`src/main/java/dev/ori/infrastructure/workspace/database`](src/main/java/dev/ori/infrastructure/workspace/database/index.md) | Миграции, версии, квитанции команд, данные и события. |
| [`src/main/java/dev/ori/infrastructure/workspace/execution`](src/main/java/dev/ori/infrastructure/workspace/execution/index.md) | Связь с macOS и обмен файлами с гостевой средой выполнения. |
| [`src/main/java/dev/ori/infrastructure/workspace/git`](src/main/java/dev/ori/infrastructure/workspace/git/index.md) | Конкретные операции репозитория и уборка рабочих каталогов. |
| [`src/main/java/dev/ori/infrastructure/workspace/projects`](src/main/java/dev/ori/infrastructure/workspace/projects/index.md) | Разрешение путей и доступ к выбранной папке на macOS. |
| [`src/main/java/dev/ori/infrastructure/workspace/provider`](src/main/java/dev/ori/infrastructure/workspace/provider/index.md) | GigaChat, поток ответа, доверенные сертификаты и SMTP. |
| [`src/main/java/dev/ori/infrastructure/workspace/security`](src/main/java/dev/ori/infrastructure/workspace/security/index.md) | Реализации Keychain, конфигурации секретов и TLS-идентификации. |
| [`src/test/java/dev/ori/infrastructure`](src/test/java/dev/ori/infrastructure/index.md) | Атомарность данных и outbox. |
| [`src/test/java/dev/ori/infrastructure/workspace`](src/test/java/dev/ori/infrastructure/workspace/index.md) | Тесты Git, VM, истории, TLS, очередей и транзакций. |

## Файлы в корне модуля

- [README.md](README.md.md)
- [build.gradle.kts](build.gradle.kts.md)
- [gradle.lockfile](gradle.lockfile.md)
