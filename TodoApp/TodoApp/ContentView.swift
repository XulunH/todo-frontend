//
//  ContentView.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import SwiftUI

struct ContentView: View {
    @State private var raw = "Loading..."

    var body: some View {
        ScrollView {
            Text(raw)
                .padding()
        }
        .task {
            do {
                // Replace 5000 with your actual backend port from launchSettings.json
                guard let url = URL(string: "http://localhost:5248/tasks") else { return }
                let (data, _) = try await URLSession.shared.data(from: url)
                raw = String(data: data, encoding: .utf8) ?? "Empty response"
            } catch {
                raw = "Error: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    ContentView()
}
