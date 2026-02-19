//
//  CoreDataStack.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//

import SwiftUI
internal import CoreData
final class CoreDataStack {

    static let shared = CoreDataStack()

    // MARK: - Preview Support
    static let preview: CoreDataStack = {
        let stack = CoreDataStack(inMemory: true)
        let context = stack.container.viewContext

        // Sample preview data
        for i in 0..<3 {
            let task = Task(context: context)
            task.id = UUID()
            task.title = "Preview Task \(i + 1)"
            task.createdAt = Date()
            task.isCompleted = i == 1
            task.expiresAt = Calendar.current.date(byAdding: .hour, value: i + 1, to: Date())
        }

        try? context.save()
        return stack
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TodayOnlyTodo")

        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

