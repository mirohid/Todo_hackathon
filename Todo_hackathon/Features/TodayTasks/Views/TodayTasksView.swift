//
//  TodayTasksView.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//


import SwiftUI
internal import CoreData

struct TodayTasksView: View {

    @StateObject var viewModel: TodayTasksViewModel
    @State private var showAddSheet = false
    @AppStorage("appearance") private var appearance: String = "system"

    private var todayHeaderText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }

    var body: some View {

        NavigationStack {
            ZStack(alignment: .bottomTrailing) {

                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.secondarySystemBackground)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 8) {
                    header

                    if viewModel.tasks.isEmpty {
                        Spacer()
                        emptyState
                        Spacer()
                    } else {
                        List {
                            Section {
                                ForEach(viewModel.tasks) { task in
                                    TaskRowView(task: task) {
                                        viewModel.toggle(task: task)
                                    }
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                    }
                }
                .padding(.horizontal)

                addTaskButton
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Picker("Appearance", selection: $appearance) {
                            Label("System", systemImage: "gearshape")
                                .tag("system")
                            Label("Light", systemImage: "sun.max")
                                .tag("light")
                            Label("Dark", systemImage: "moon")
                                .tag("dark")
                        }
                    } label: {
                        Image(systemName: "circle.lefthalf.filled")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddTaskView(viewModel: viewModel)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Today only")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(todayHeaderText)
                .font(.title2)
                .fontWeight(.bold)

            Text("Tasks reset automatically at midnight. Stay focused on just today.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(.top, 12)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "sun.max.fill")
                .font(.system(size: 56))
                .foregroundColor(.orange)

            Text("Nothing for today")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Start fresh by adding the one thing that really matters.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Button {
                showAddSheet = true
            } label: {
                Text("Add your first task")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 40)
        }
    }

    private var addTaskButton: some View {
        Button {
            showAddSheet = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                Text("New Task")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(.thinMaterial)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
    }
}