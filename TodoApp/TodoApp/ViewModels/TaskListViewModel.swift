//
//  TaskListViewModel.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import Foundation

@MainActor
@Observable
final class TaskListViewModel {
    private(set) var tasks: [TodoTask] = []
    private(set) var isLoading = false
    var errorMessage: String?

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            tasks = try await client.fetchTasks()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleCompletion(for task: TodoTask) async {
        var edited = task
        edited.completed.toggle()

        do {
            let saved = try await client.updateTask(UpdateTaskRequest(task: edited))
            replace(saved)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(_ task: TodoTask) async {
        do {
            try await client.deleteTask(id: task.id)
            tasks.removeAll { $0.id == task.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func replace(_ task: TodoTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index] = task
    }
}
