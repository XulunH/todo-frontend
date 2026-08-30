//
//  TaskFormViewModel.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import Foundation

/// Backs both the Create and Edit screens: the design shows two screens, but they
/// differ only in their title and whether the fields start populated.
@MainActor
@Observable
final class TaskFormViewModel {
    enum Mode {
        case create
        case edit(TodoTask)
    }

    let mode: Mode
    var taskDescription: String
    var dueDate: Date
    private(set) var isSaving = false
    var errorMessage: String?

    private let client: APIClient

    init(mode: Mode, client: APIClient = .shared) {
        self.mode = mode
        self.client = client

        switch mode {
        case .create:
            self.taskDescription = ""
            self.dueDate = .now
        case .edit(let task):
            self.taskDescription = task.taskDescription
            self.dueDate = task.dueDate
        }
    }

    var title: String {
        switch mode {
        case .create: return "Create"
        case .edit: return "Edit"
        }
    }

    /// Mirrors the server's rule that a description cannot be blank, so the user
    /// gets immediate feedback instead of a round trip that ends in a 400.
    var canSave: Bool {
        !trimmedDescription.isEmpty && !isSaving
    }

    private var trimmedDescription: String {
        taskDescription.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func save() async -> TodoTask? {
        guard canSave else { return nil }

        isSaving = true
        defer { isSaving = false }

        do {
            switch mode {
            case .create:
                return try await client.createTask(
                    CreateTaskRequest(
                        taskDescription: trimmedDescription,
                        dueDate: dueDate,
                        completed: false
                    )
                )
            case .edit(let task):
                var edited = task
                edited.taskDescription = trimmedDescription
                edited.dueDate = dueDate
                return try await client.updateTask(UpdateTaskRequest(task: edited))
            }
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
