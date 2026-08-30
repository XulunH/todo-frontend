//
//  Date+Display.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/30/26.
//

import Foundation

extension Date {
    /// Matches the design's "March 6, 2023" format, rendered in the device's time zone.
    var taskDisplayString: String {
        formatted(.dateTime.month(.wide).day().year())
    }
}
