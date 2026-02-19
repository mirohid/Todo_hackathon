//
//  TaskRowView.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//

import SwiftUI
internal import CoreData

struct TaskRowView: View {

    let task: Task
    let onToggle: () -> Void

    private var expirationText: String? {
        guard let expiresAt = task.expiresAt else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: expiresAt)
    }

    var body: some View {
        HStack(spacing: 12) {

            Button {
                withAnimation(.spring(response: 0.4,
                                      dampingFraction: 0.7,
                                      blendDuration: 0.2)) {
                    onToggle()
                }
            } label: {
                Image(systemName:
                        task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .scaleEffect(task.isCompleted ? 1.05 : 1.0)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title ?? "")
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .strikethrough(task.isCompleted, pattern: .solid, color: .secondary)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)

                if let expirationText {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(expirationText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

#Preview {
    // Create an in-memory Core Data stack for previewing
    let container = NSPersistentContainer(name: "Todo_hackathon")
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Failed to load in-memory store: \(error)")
        }
    }

    let context = container.viewContext

    let task = Task(context: context)
    task.id = UUID()
    task.title = "Design MVVM architecture"
    task.createdAt = Date()
    task.isCompleted = false
    task.expiresAt = Calendar.current.date(byAdding: .hour, value: 2, to: Date())

    return TaskRowView(task: task) {
        print("Toggle tapped")
    }
    .padding()
}
