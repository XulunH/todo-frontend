//
//  APIError.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import Foundation

/// The `{ "message": "..." }` shape every 4XX and 5XX response uses.
struct APIErrorResponse: Decodable {
    let message: String
}

enum APIError: LocalizedError {
    case invalidURL
    case network(Error)
    case decoding(Error)
    case server(status: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Could not build a valid request URL."
        case .network(let error):
            return "Network error. \(error.localizedDescription)"
        case .decoding:
            return "The server returned data in an unexpected format."
        case .server(_, let message):
            return message
        }
    }
}
