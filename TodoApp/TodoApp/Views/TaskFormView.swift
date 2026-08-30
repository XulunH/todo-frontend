//
//  TaskFormView.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import SwiftUI

/// The Create and Edit screens from the design.
struct TaskFormView: View {
    @State private var viewModel: TaskFormViewModel
    @Environment(\.dismiss) private var dismiss

    private let onSaved: (TodoTask) -> Void

    init(mode: TaskFormViewModel.Mode, onSaved: @escaping (TodoTask) -> Void) {
        _viewModel = State(initialValue: TaskFormViewModel(mode: mode))
        self.onSaved = onSaved
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.title)
                .font(.title3.weight(.bold))
                .padding(.vertical, 16)

            VStack(alignment: .leading, spacing: 18) {
                field("To-Do Item Name") {
                    TextField("", text: $viewModel.taskDescription)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 7)
                        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 4))
                }

                field("Select Due Date") {
                    DatePicker(
                        "Due date",
                        selection: $viewModel.dueDate,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                }

                saveButton
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .alert("Something went wrong", isPresented: showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private func field<Content: View>(
        _ label: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
            content()
        }
    }

    private var saveButton: some View {
        HStack {
            Spacer()
            Button {
                Task {
                    if let saved = await viewModel.save() {
                        onSaved(saved)
                        dismiss()
                    }
                }
            } label: {
                Text("Save")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 7)
                    .background(viewModel.canSave ? Color.black : Color.gray, in: .rect(cornerRadius: 3))
            }
            .disabled(!viewModel.canSave)
            Spacer()
        }
        .padding(.top, 6)
    }

    private var showingError: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

#Preview("Create") {
    TaskFormView(mode: .create) { _ in }
}

#Preview("Edit") {
    TaskFormView(
        mode: .edit(
            TodoTask(
                id: UUID(),
                taskDescription: "Grocery Shopping",
                createdDate: .now,
                dueDate: .now,
                completed: false
            )
        )
    ) { _ in }
}
