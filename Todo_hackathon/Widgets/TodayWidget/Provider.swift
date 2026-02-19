//
//  Provider.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//


import WidgetKit
import SwiftUI
internal import CoreData

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> TodayWidgetEntry {
        TodayWidgetEntry(date: Date(), count: 0)
    }

    func getSnapshot(in context: Context,
                     completion: @escaping (TodayWidgetEntry) -> Void) {
        completion(fetchEntry())
    }

    func getTimeline(in context: Context,
                     completion: @escaping (Timeline<TodayWidgetEntry>) -> Void) {

        let entry = fetchEntry()
        let timeline = Timeline(entries: [entry],
                                policy: .after(Date().endOfDay))
        completion(timeline)
    }

    private func fetchEntry() -> TodayWidgetEntry {

        let context = CoreDataStack.shared.container.viewContext
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(
            format: "createdAt >= %@",
            Date().startOfDay as NSDate
        )

        let count = (try? context.count(for: request)) ?? 0
        return TodayWidgetEntry(date: Date(), count: count)
    }
}
