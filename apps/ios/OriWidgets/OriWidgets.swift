import SwiftUI
import WidgetKit

@main
struct OriWidgets: WidgetBundle {
    var body: some Widget {
        OriComposeWidget()
        OriDecisionsWidget()
        OriCurrentTaskWidget()
        OriTeamWidget()
        OriSchedulesWidget()
        OriOverviewWidget()
    }
}

enum OriWidgetKind: String {
    case compose, decisions, currentTask, team, schedules, overview
    var title: String {
        switch self {
        case .compose: "Новое поручение"
        case .decisions: "Твоё решение"
        case .currentTask: "Текущая задача"
        case .team: "Команда агентов"
        case .schedules: "Ближайшие запуски"
        case .overview: "Обзор работы"
        }
    }
    var summary: String {
        switch self {
        case .compose: "Начните новый чат с Ori одним касанием."
        case .decisions: "Задачи и действия, которым нужен ваш ответ."
        case .currentTask: "Вернитесь к текущей работе агента."
        case .team: "Ваши агенты и их последние состояния."
        case .schedules: "Следующие запуски ваших расписаний."
        case .overview: "Работа, решения и результаты в одном месте."
        }
    }
    var families: [WidgetFamily] {
        switch self {
        case .compose, .decisions: [.systemSmall]
        case .currentTask, .team, .schedules: [.systemMedium]
        case .overview: [.systemLarge]
        }
    }
}

@MainActor
private func configuration(_ kind: OriWidgetKind) -> some WidgetConfiguration {
    StaticConfiguration(kind: "dev.blot.widgets." + kind.rawValue, provider: OriWidgetProvider()) { entry in
        OriWidgetView(kind: kind, entry: entry)
            .containerBackground(.background, for: .widget)
    }
    .configurationDisplayName(Text(kind.title))
    .description(Text(kind.summary))
    .supportedFamilies(kind.families)
}

struct OriComposeWidget: Widget {
    var body: some WidgetConfiguration { configuration(.compose) }
}

struct OriDecisionsWidget: Widget {
    var body: some WidgetConfiguration { configuration(.decisions) }
}

struct OriCurrentTaskWidget: Widget {
    var body: some WidgetConfiguration { configuration(.currentTask) }
}

struct OriTeamWidget: Widget {
    var body: some WidgetConfiguration { configuration(.team) }
}

struct OriSchedulesWidget: Widget {
    var body: some WidgetConfiguration { configuration(.schedules) }
}

struct OriOverviewWidget: Widget {
    var body: some WidgetConfiguration { configuration(.overview) }
}
