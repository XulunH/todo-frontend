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
        VStack(alignment: .leading, spacing: 0) {
            Text("Settings")
                .font(Theme.Typography.screenTitle)
                .frame(maxWidth: .infinity)
                .padding(.top, Theme.ScreenTitle.topPadding)

            Spacer().frame(height: Theme.Settings.titleToFilters)

            radioGroup(
                "Filters",
                labelToRows: Theme.Settings.filtersLabelToRows,
                options: TaskFilter.allCases,
                selection: $draft.filter
            )

            Spacer().frame(height: Theme.Settings.filtersToSortBy)

            radioGroup(
                "Sort By",
                labelToRows: Theme.Settings.sortByLabelToRows,
                options: TaskSortField.allCases,
                selection: $draft.sortField
            )

            Spacer().frame(height: Theme.Settings.sortByToDirection)

            radioGroup(
                "Sort Date Direction",
                labelToRows: Theme.Settings.directionLabelToRows,
                options: SortDirection.allCases,
                selection: $draft.direction
            )

            Spacer().frame(height: Theme.Settings.lastGroupToSave)

            saveButton

            Spacer()
        }
        .foregroundStyle(Theme.Palette.content)
        .padding(.horizontal, Theme.Settings.horizontalMargin)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.Palette.background)
    }

    private func radioGroup<Option: RadioOption>(
        _ title: String,
        labelToRows: CGFloat,
        options: [Option],
        selection: Binding<Option>
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(Theme.Typography.groupLabel)

            Spacer().frame(height: labelToRows)

            VStack(alignment: .leading, spacing: Theme.Settings.radioRowSpacing) {
                ForEach(options) { option in
                    Button {
                        selection.wrappedValue = option
                    } label: {
                        HStack(spacing: Theme.Settings.radioToLabel) {
                            Image(
                                systemName: selection.wrappedValue == option
                                    ? "largecircle.fill.circle"
                                    : "circle"
                            )
                            .themedIcon(Theme.Icon.card)

                            Text(option.label)
                                .font(Theme.Typography.body)

                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Theme.Palette.content)
                }
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
                    .font(Theme.Typography.button)
                    .foregroundStyle(Theme.Palette.buttonLabel)
                    .frame(width: Theme.SaveButton.width, height: Theme.SaveButton.height)
                    .background(
                        Theme.Palette.buttonFill,
                        in: .rect(cornerRadius: Theme.SaveButton.cornerRadius)
                    )
            }
            Spacer()
        }
    }
}

#Preview {
    SettingsView(settings: TaskSettings()) { _ in }
}
