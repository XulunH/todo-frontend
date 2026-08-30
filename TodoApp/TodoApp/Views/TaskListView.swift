//
//  TaskListView.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import SwiftUI

/// The Main Page from the design: header with settings and add buttons, then the task cards.
struct TaskListView: View {
    @State private var viewModel = TaskListViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                Divider()
                content
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .alert("Something went wrong", isPresented: showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .task { await viewModel.load() }
    }

    private var header: some View {
        HStack {
            // Both buttons are wired up once the Settings and Create screens exist.
            Button {} label: {
                Image(systemName: "gearshape.fill")
            }
            .accessibilityLabel("Settings")

            Spacer()

            Text("Task List")
                .font(.title3.weight(.bold))

            Spacer()

            Button {} label: {
                Image(systemName: "plus.circle.fill")
            }
            .accessibilityLabel("Create task")
        }
        .font(.system(size: 20))
        .foregroundStyle(.primary)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.tasks.isEmpty {
            Spacer()
            ProgressView()
            Spacer()
        } else if viewModel.tasks.isEmpty {
            ContentUnavailableView(
                "No tasks yet",
                systemImage: "checklist",
                description: Text("Tap the plus button to add your first task.")
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.tasks) { task in
                        TaskRowView(
                            task: task,
                            onEdit: {},
                            onToggleCompletion: { Task { await viewModel.toggleCompletion(for: task) } },
                            onDelete: { Task { await viewModel.delete(task) } }
                        )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .refreshable { await viewModel.load() }
        }
    }

    private var showingError: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

#Preview {
    TaskListView()
}
