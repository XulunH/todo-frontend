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
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.title)
                .font(Theme.Typography.screenTitle)
                .frame(maxWidth: .infinity)
                .padding(.top, Theme.ScreenTitle.topPadding)

            Spacer().frame(height: Theme.Form.titleToLabel)

            Text("To-Do Item Name")
                .font(Theme.Typography.body)

            Spacer().frame(height: Theme.Form.labelToField)

            nameField

            Spacer().frame(height: Theme.Form.fieldToLabel)

            Text("Select Due Date")
                .font(Theme.Typography.body)

            Spacer().frame(height: Theme.Form.labelToField)

            dueDateBar

            Spacer().frame(height: Theme.Form.fieldToSaveButton)

            saveButton

            Spacer()
        }
        .foregroundStyle(Theme.Palette.content)
        .padding(.horizontal, Theme.Form.horizontalMargin)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.Palette.background)
        .alert(
            viewModel.alert?.title ?? "",
            isPresented: showingAlert,
            presenting: viewModel.alert
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { alert in
            Text(alert.message)
        }
    }

    private var nameField: some View {
        TextField("", text: $viewModel.taskDescription)
            .textFieldStyle(.plain)
            .font(Theme.Typography.body)
            .padding(.horizontal, Theme.Form.textFieldTextInset)
            .frame(height: Theme.Form.textFieldHeight)
            .background(
                Theme.Palette.surface,
                in: .rect(cornerRadius: Theme.Form.barCornerRadius)
            )
            // The design outlines a field only once it holds a value.
            .overlay {
                if !viewModel.taskDescription.isEmpty {
                    RoundedRectangle(cornerRadius: Theme.Form.barCornerRadius)
                        .stroke(Theme.Palette.content, lineWidth: 1)
                }
            }
    }

    private var dueDateBar: some View {
        Button {
            isShowingDatePicker = true
        } label: {
            HStack(spacing: 0) {
                Text(viewModel.dueDate.taskDisplayString)
                    .font(Theme.Typography.body)
                Spacer()
                Image(systemName: "calendar")
                    .themedIcon(Theme.Icon.calendar)
            }
            .foregroundStyle(Theme.Palette.content)
            .padding(.leading, Theme.Form.barTextInset)
            .padding(.trailing, Theme.Form.calendarTrailingInset)
            .frame(height: Theme.Form.dateBarHeight)
            .background(
                Theme.Palette.surface,
                in: .rect(cornerRadius: Theme.Form.barCornerRadius)
            )
            .overlay {
                RoundedRectangle(cornerRadius: Theme.Form.barCornerRadius)
                    .stroke(Theme.Palette.content, lineWidth: 1)
            }
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
                    .font(Theme.Typography.button)
                    .foregroundStyle(Theme.Palette.buttonLabel)
                    .frame(width: Theme.SaveButton.width, height: Theme.SaveButton.height)
                    .background(
                        Theme.Palette.buttonFill,
                        in: .rect(cornerRadius: Theme.SaveButton.cornerRadius)
                    )
            }
            .disabled(viewModel.isSaving)
            Spacer()
        }
    }

    private var showingAlert: Binding<Bool> {
        Binding(
            get: { viewModel.alert != nil },
            set: { if !$0 { viewModel.alert = nil } }
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
