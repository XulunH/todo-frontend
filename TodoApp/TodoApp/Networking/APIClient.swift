//
//  APIClient.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import Foundation

struct APIClient {
    static let shared = APIClient()

    private let baseURL = URL(string: "http://localhost:5248")!
    private let session = URLSession.shared

    // MARK: - Endpoints

    func fetchTasks(completed: Bool? = nil, sortBy: String? = nil) async throws -> [TodoTask] {
        guard var components = URLComponents(
            url: baseURL.appending(path: "tasks"),
            resolvingAgainstBaseURL: false
        ) else { throw APIError.invalidURL }

        var items: [URLQueryItem] = []
        if let completed {
            items.append(URLQueryItem(name: "completed", value: String(completed)))
        }
        if let sortBy {
            items.append(URLQueryItem(name: "sort_by", value: sortBy))
        }
        components.queryItems = items.isEmpty ? nil : items

        // URLComponents leaves "+" unescaped in query values, and a raw "+" decodes
        // to a space server-side, so `sort_by=+dueDate` would arrive as " dueDate".
        if let encoded = components.percentEncodedQuery {
            components.percentEncodedQuery = encoded.replacingOccurrences(of: "+", with: "%2B")
        }

        guard let url = components.url else { throw APIError.invalidURL }
        return try await send(URLRequest(url: url))
    }

    func fetchTask(id: UUID) async throws -> TodoTask {
        try await send(URLRequest(url: taskURL(id)))
    }

    func createTask(_ body: CreateTaskRequest) async throws -> TodoTask {
        var request = URLRequest(url: baseURL.appending(path: "tasks"))
        request.httpMethod = "POST"
        try attachJSONBody(body, to: &request)
        return try await send(request)
    }

    func updateTask(_ body: UpdateTaskRequest) async throws -> TodoTask {
        var request = URLRequest(url: taskURL(body.id))
        request.httpMethod = "PUT"
        try attachJSONBody(body, to: &request)
        return try await send(request)
    }

    func deleteTask(id: UUID) async throws {
        var request = URLRequest(url: taskURL(id))
        request.httpMethod = "DELETE"
        _ = try await perform(request)
    }

    // MARK: - Plumbing

    private func taskURL(_ id: UUID) -> URL {
        baseURL.appending(path: "tasks/\(id.uuidString)")
    }

    private func attachJSONBody(_ body: some Encodable, to request: inout URLRequest) throws {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONCoders.encoder.encode(body)
    }

    private func send<T: Decodable>(_ request: URLRequest) async throws -> T {
        let data = try await perform(request)
        do {
            return try JSONCoders.decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    /// Runs the request and turns any non-2xx response into `APIError.server`,
    /// so every caller sees failures as one type with the server's own message.
    private func perform(_ request: URLRequest) async throws -> Data {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.network(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.network(URLError(.badServerResponse))
        }

        guard (200..<300).contains(http.statusCode) else {
            let message = (try? JSONCoders.decoder.decode(APIErrorResponse.self, from: data))?.message
                ?? "Request failed with status \(http.statusCode)."
            throw APIError.server(status: http.statusCode, message: message)
        }

        return data
    }
}
