//
//  TaskSettingsStore.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import Foundation

/// Persists the Settings screen's choices so they survive relaunches.
enum TaskSettingsStore {
    private static let key = "taskSettings"

    static func load(from defaults: UserDefaults = .standard) -> TaskSettings {
        guard
            let data = defaults.data(forKey: key),
            let settings = try? JSONDecoder().decode(TaskSettings.self, from: data)
        else {
            return TaskSettings()
        }
        return settings
    }

    static func save(_ settings: TaskSettings, to defaults: UserDefaults = .standard) {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: key)
    }
}
