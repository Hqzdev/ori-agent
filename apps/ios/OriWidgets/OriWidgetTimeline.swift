import OriWidgetSupport
import Foundation
import WidgetKit

struct OriWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetSnapshot
    var unavailable = false

    var decisions: [WidgetDecision] { snapshot.decisions.filter { ($0.expiresAt ?? .distantFuture) > date } }
    var schedules: [WidgetSchedule] { snapshot.schedules.filter { $0.nextRun > date } }
    var isStale: Bool { date.timeIntervalSince(snapshot.updatedAt) > 15 * 60 }
}

struct OriWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> OriWidgetEntry {
        .init(date: .now, snapshot: .init())
    }
    func getSnapshot(in context: Context, completion: @escaping (OriWidgetEntry) -> Void) { completion(read()) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<OriWidgetEntry>) -> Void) {
        let entry = read()
        let boundary = (entry.snapshot.decisions.compactMap(\.expiresAt) + entry.snapshot.schedules.map(\.nextRun))
            .filter { $0 > entry.date }.min()
        let next = min(boundary ?? .distantFuture, entry.date.addingTimeInterval(5 * 60))
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
    private func read() -> OriWidgetEntry {
        do { return .init(date: .now, snapshot: try WidgetSnapshotStore().read() ?? .init()) }
        catch { return .init(date: .now, snapshot: .init(), unavailable: true) }
    }
}
