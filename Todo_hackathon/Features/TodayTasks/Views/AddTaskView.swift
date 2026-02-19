//
//  AddTaskView.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//


import SwiftUI
import Combine
internal import CoreData

struct AddTaskView: View {

    @ObservedObject var viewModel: TodayTasksViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var expiration: Date = Date()

    private var isAddDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task")) {
                    TextField("What needs to be done today?",
                              text: $title)
                        .textInputAutocapitalization(.sentences)
                        .submitLabel(.done)
                }

                Section(header: Text("Reminder (today only)")) {
                    let now = Date()
                    let endOfDay = now.endOfDay

                    DatePicker(
                        "Remind me at",
                        selection: $expiration,
                        in: now...endOfDay,
                        displayedComponents: .hourAndMinute
                    )
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addTask(title: title, expiresAt: expiration)
                        dismiss()
                    }
                    .disabled(isAddDisabled)
                }
            }
            .onAppear {
                let now = Date()
                let oneHourFromNow = Calendar.current.date(
                    byAdding: .hour,
                    value: 1,
                    to: now
                ) ?? now

                let endOfDay = now.endOfDay
                expiration = min(oneHourFromNow, endOfDay)
            }
        }
    }
}

#Preview {
    let context = CoreDataStack.preview.container.viewContext
    let viewModel = TodayTasksViewModel(context: context)

    return AddTaskView(viewModel: viewModel)
}
