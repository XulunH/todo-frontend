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
    @State private var isShowingDatePicker = false
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
                        .inputBar()
                }

                field("Select Due Date") {
                    dueDateBar
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var dueDateBar: some View {
        Button {
            isShowingDatePicker = true
        } label: {
            HStack(spacing: 8) {
                Text(viewModel.dueDate.taskDisplayString)
                Spacer()
                Image(systemName: "calendar")
            }
            .foregroundStyle(.primary)
            .inputBar()
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isShowingDatePicker) {
            DatePicker(
                "Due date",
                selection: $viewModel.dueDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            // The graphical picker has no intrinsic width, so without an explicit
            // frame the popover collapses to a sliver and clips the calendar.
            .frame(width: 320, height: 350)
            .padding(.vertical, 8)
            .presentationCompactAdaptation(.popover)
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

/// Shared so the name field and the due date bar cannot drift apart visually.
private struct InputBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 8)
            .padding(.vertical, 7)
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 4))
    }
}

private extension View {
    func inputBar() -> some View {
        modifier(InputBar())
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
