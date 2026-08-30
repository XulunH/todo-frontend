//
//  TaskRequests.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import Foundation

/// Body for `POST /tasks`. Omits `id` and `createdDate` because the server owns them.
struct CreateTaskRequest: Encodable {
    let taskDescription: String
    let dueDate: Date
    let completed: Bool
}

/// Body for `PUT /tasks/{id}`. Includes the immutable fields to match the API spec,
/// even though the server ignores them in favour of the values it already holds.
struct UpdateTaskRequest: Encodable {
    let id: UUID
    let taskDescription: String
    let createdDate: Date
    let dueDate: Date
    let completed: Bool

    init(task: TodoTask) {
        self.id = task.id
        self.taskDescription = task.taskDescription
        self.createdDate = task.createdDate
        self.dueDate = task.dueDate
        self.completed = task.completed
    }
}
