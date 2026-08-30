//
//  TaskRowView.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import SwiftUI

/// One card in the task list: pencil, title with dates, checkbox, trash.
/// Laid out to the Figma card spec: 358 x 90, #D9D9D9, radius 8.
struct TaskRowView: View {
    let task: TodoTask
    let onEdit: () -> Void
    let onToggleCompletion: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .themedIcon(Theme.Icon.card)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Edit \(task.taskDescription)")

            Spacer().frame(width: Theme.Card.pencilToText)

            VStack(alignment: .leading, spacing: 0) {
                Text(task.taskDescription)
                    .font(Theme.Typography.cardTitle)
                    .lineLimit(1)

                Spacer().frame(height: Theme.Card.titleToDueSpacing)

                Text("Due: \(task.dueDate.taskDisplayString)")
                    .font(Theme.Typography.cardMeta)

                Spacer().frame(height: Theme.Card.dueToCreatedSpacing)

                Text("Created: \(task.createdDate.taskDisplayString)")
                    .font(Theme.Typography.cardMeta)
            }

            Spacer(minLength: 8)

            Button(action: onToggleCompletion) {
                Image(systemName: task.completed ? "checkmark.square.fill" : "square")
                    .themedIcon(Theme.Icon.card)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(task.completed ? "Mark incomplete" : "Mark complete")

            Spacer().frame(width: Theme.Card.checkboxToTrash)

            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .themedIcon(Theme.Icon.delete)
                    .foregroundStyle(Theme.Palette.deleteIcon)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Delete \(task.taskDescription)")
        }
        .foregroundStyle(Theme.Palette.content)
        .padding(.leading, Theme.Card.leadingPadding)
        .padding(.trailing, Theme.Card.trailingPadding)
        .frame(height: Theme.Card.height)
        .background(
            Theme.Palette.surface,
            in: .rect(cornerRadius: Theme.Card.cornerRadius)
        )
    }
}

#Preview {
    VStack(spacing: Theme.Card.spacing) {
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
    .padding(.horizontal, Theme.Card.horizontalMargin)
}
