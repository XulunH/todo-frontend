//
//  TodoTask.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import Foundation

/// A to-do item as returned by the API.
struct TodoTask: Identifiable, Codable, Equatable {
    let id: UUID
    var taskDescription: String
    let createdDate: Date
    var dueDate: Date
    var completed: Bool
}
