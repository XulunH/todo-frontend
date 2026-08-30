//
//  TaskRowView.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import SwiftUI

/// One card in the task list: pencil, title with dates, checkbox, trash.
struct TaskRowView: View {
    let task: TodoTask
    let onEdit: () -> Void
    let onToggleCompletion: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .font(.system(size: 15))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Edit \(task.taskDescription)")

            VStack(alignment: .leading, spacing: 1) {
                Text(task.taskDescription)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.primary)
                    .strikethrough(task.completed)

                Text("Due: \(task.dueDate.taskDisplayString)")
                Text("Created: \(task.createdDate.taskDisplayString)")
            }
            .font(.system(size: 9))
            .foregroundStyle(.secondary)

            Spacer(minLength: 8)

            Button(action: onToggleCompletion) {
                Image(systemName: task.completed ? "checkmark.square.fill" : "square")
                    .font(.system(size: 16))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(task.completed ? "Mark incomplete" : "Mark complete")

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 15))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Delete \(task.taskDescription)")
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemGray5), in: .rect(cornerRadius: 6))
    }
}

#Preview {
    VStack(spacing: 8) {
        TaskRowView(
            task: TodoTask(
                id: UUID(),
                taskDescription: "Grocery Shopping",
                createdDate: .now.addingTimeInterval(-86_400 * 7),
                dueDate: .now,
                completed: false
            ),
            onEdit: {}, onToggleCompletion: {}, onDelete: {}
        )
        TaskRowView(
            task: TodoTask(
                id: UUID(),
                taskDescription: "Clean House",
                createdDate: .now.addingTimeInterval(-86_400 * 3),
                dueDate: .now.addingTimeInterval(86_400 * 2),
                completed: true
            ),
            onEdit: {}, onToggleCompletion: {}, onDelete: {}
        )
    }
    .padding()
}
