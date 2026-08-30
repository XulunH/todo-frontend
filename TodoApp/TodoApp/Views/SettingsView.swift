//
//  SettingsView.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import SwiftUI

/// The Settings screen from the design: filters, sort field, sort direction.
struct SettingsView: View {
    @State private var draft: TaskSettings
    @Environment(\.dismiss) private var dismiss

    private let onSave: (TaskSettings) -> Void

    init(settings: TaskSettings, onSave: @escaping (TaskSettings) -> Void) {
        _draft = State(initialValue: settings)
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("Settings")
                .font(.title3.weight(.bold))
                .padding(.vertical, 16)

            VStack(alignment: .leading, spacing: 20) {
                radioGroup("Filters", options: TaskFilter.allCases, selection: $draft.filter)
                radioGroup("Sort By", options: TaskSortField.allCases, selection: $draft.sortField)
                radioGroup(
                    "Sort Date Direction",
                    options: SortDirection.allCases,
                    selection: $draft.direction
                )
                saveButton
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()
        }
    }

    private func radioGroup<Option: RadioOption>(
        _ title: String,
        options: [Option],
        selection: Binding<Option>
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            ForEach(options) { option in
                Button {
                    selection.wrappedValue = option
                } label: {
                    HStack(spacing: 8) {
                        Image(
                            systemName: selection.wrappedValue == option
                                ? "largecircle.fill.circle"
                                : "circle"
                        )
                        .font(.system(size: 13))
                        Text(option.label)
                            .font(.system(size: 12))
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.primary)
            }
        }
    }

    private var saveButton: some View {
        HStack {
            Spacer()
            Button {
                onSave(draft)
                dismiss()
            } label: {
                Text("Save")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 7)
                    .background(Color.black, in: .rect(cornerRadius: 3))
            }
            Spacer()
        }
        .padding(.top, 6)
    }
}

#Preview {
    SettingsView(settings: TaskSettings()) { _ in }
}
