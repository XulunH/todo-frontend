//
//  TaskSettings.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import Foundation

/// A choice rendered as one radio row on the Settings screen.
protocol RadioOption: Identifiable, Equatable {
    var label: String { get }
}

enum TaskFilter: String, CaseIterable, Codable, RadioOption {
    case all
    case complete
    case incomplete

    var id: String { rawValue }

    var label: String {
        switch self {
        case .all: return "All"
        case .complete: return "Complete"
        case .incomplete: return "Incomplete"
        }
    }

    /// `nil` means "don't send `?completed=` at all", which is how the API returns everything.
    var completedParameter: Bool? {
        switch self {
        case .all: return nil
        case .complete: return true
        case .incomplete: return false
        }
    }
}

enum TaskSortField: String, CaseIterable, Codable, RadioOption {
    case dueDate
    case createdDate

    var id: String { rawValue }

    var label: String {
        switch self {
        case .dueDate: return "Due"
        case .createdDate: return "Created"
        }
    }
}

enum SortDirection: String, CaseIterable, Codable, RadioOption {
    case ascending
    case descending

    var id: String { rawValue }

    var label: String {
        switch self {
        case .ascending: return "Ascending"
        case .descending: return "Descending"
        }
    }

    var sign: String {
        switch self {
        case .ascending: return "+"
        case .descending: return "-"
        }
    }
}

struct TaskSettings: Codable, Equatable {
    var filter: TaskFilter = .all
    var sortField: TaskSortField = .dueDate
    var direction: SortDirection = .ascending

    /// Builds the spec's `sort_by` value, e.g. `+dueDate` or `-createdDate`.
    var sortByParameter: String {
        direction.sign + sortField.rawValue
    }
}
