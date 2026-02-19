//
//  AddTaskIntent.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//


internal import AppIntents
internal import CoreData

struct AddTaskIntent: AppIntent {

    static var title: LocalizedStringResource = "Add Task For Today"

    @Parameter(title: "Task Title")
    var taskTitle: String

    func perform() async throws -> some IntentResult {

        let context = CoreDataStack.shared.container.viewContext
        let now = Date()

        let task = Task(context: context)
        task.id = UUID()
        task.title = taskTitle
        task.createdAt = now
        task.isCompleted = false
        task.expiresAt = await now.endOfDay

        try context.save()

        await NotificationManager.shared.scheduleReminder(for: taskTitle,
                                                    at: now.endOfDay)

        return .result(dialog: "Task added.")
    }
}

