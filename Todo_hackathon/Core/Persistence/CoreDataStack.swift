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

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "TodayOnlyTodo")

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
