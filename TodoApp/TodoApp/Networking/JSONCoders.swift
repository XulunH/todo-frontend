//
//  JSONCoders.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import Foundation

enum JSONCoders {
    /// The API pins timestamps to `yyyy-MM-ddTHH:mm:ss.SSSZ`, but we still accept a
    /// missing fractional part: `ISO8601DateFormatter` refuses one format when
    /// configured for the other, so neither option alone covers both.
    static let decoder: JSONDecoder = {
        let withFraction = ISO8601DateFormatter()
        withFraction.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let withoutFraction = ISO8601DateFormatter()
        withoutFraction.formatOptions = [.withInternetDateTime]

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let raw = try container.decode(String.self)

            if let date = withFraction.date(from: raw) ?? withoutFraction.date(from: raw) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unrecognized date format: \(raw)"
            )
        }
        return decoder
    }()

    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}
