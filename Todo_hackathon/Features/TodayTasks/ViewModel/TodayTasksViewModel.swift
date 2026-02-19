//
//  TodayTasksViewModel.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//


import Foundation
internal import CoreData
import Combine

@MainActor
final class TodayTasksViewModel: ObservableObject {

    @Published private(set) var tasks: [Task] = []

    private let context: NSManagedObjectContext
    private let dateProvider: DateProviding

    init(context: NSManagedObjectContext,
         dateProvider: DateProviding = SystemDateProvider()) {

        self.context = context
        self.dateProvider = dateProvider

        NotificationManager.shared.requestPermission()
        deleteOldTasks()
        fetchTodayTasks()
        scheduleMidnightReset()
    }

    // MARK: - Public

    func addTask(title: String, expiresAt: Date) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let now = dateProvider.now
        let endOfToday = now.endOfDay

        // Ensure expiration stays within "today only"
        var clampedExpiration = expiresAt
        if clampedExpiration < now {
            clampedExpiration = now
        }
        if clampedExpiration > endOfToday {
            clampedExpiration = endOfToday
        }

        let task = Task(context: context)
        task.id = UUID()
        task.title = trimmed
        task.createdAt = now
        task.isCompleted = false
        task.expiresAt = clampedExpiration

        save()
        NotificationManager.shared.scheduleReminder(for: trimmed, at: clampedExpiration)
        HapticManager.shared.success()

        fetchTodayTasks()
    }

    func toggle(task: Task) {
        task.isCompleted.toggle()
        save()
        HapticManager.shared.impact()
        fetchTodayTasks()
    }

    // MARK: - Private

    private func fetchTodayTasks() {

        let request: NSFetchRequest<Task> = Task.fetchRequest()

        let start = dateProvider.now.startOfDay
        let end = dateProvider.now.endOfDay

        request.predicate = NSPredicate(
            format: "createdAt >= %@ AND createdAt <= %@",
            start as NSDate,
            end as NSDate
        )

        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]

        tasks = (try? context.fetch(request)) ?? []
    }

    private func deleteOldTasks() {

        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(
            format: "createdAt < %@",
            dateProvider.now.startOfDay as NSDate
        )

        if let oldTasks = try? context.fetch(request) {
            oldTasks.forEach { context.delete($0) }
            save()
        }
    }

    private func save() {
        try? context.save()
    }

    private func scheduleMidnightReset() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.deleteOldTasks()
            self.fetchTodayTasks()
        }
    }
}
