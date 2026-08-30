//
//  Theme.swift
//  TodoApp
//
//  Created by Xulun Huang on 8/31/26.
//

import SwiftUI

/// Values transcribed from the Figma spec. The design frames are 390 x 844, which
/// maps 1:1 onto iOS points, so every number here is the design's number.
enum Theme {

    enum Palette {
        static let background = Color.white                 // #FFFFFF
        static let surface = Color(white: 217.0 / 255.0)    // #D9D9D9
        static let content = Color.black                    // #000000
        static let deleteIcon = Color.black.opacity(0.54)   // rgba(0,0,0,0.54)
        static let buttonFill = Color.black
        static let buttonLabel = Color.white
    }

    /// Sizes are fixed rather than Dynamic Type scaled, because the design pins the
    /// task card to a 90pt height that scaled text would overflow.
    enum Typography {
        static let mainTitle = inter(30)              // "Task List"
        static let screenTitle = inter(34)            // "Create" / "Edit" / "Settings"
        static let groupLabel = inter(20)             // "Filters", "Sort By", ...
        static let body = inter(16)                   // field labels, radio labels, inputs
        static let cardTitle = inter(16, .medium)     // task description (weight 500)
        static let cardMeta = inter(14)               // "Due:" / "Created:"
        static let button = inter(18)                 // "Save"

        enum Weight: String {
            case regular = "Inter-Regular"
            case medium = "Inter-Medium"
        }

        static func inter(_ size: CGFloat, _ weight: Weight = .regular) -> Font {
            .custom(weight.rawValue, fixedSize: size)
        }
    }

    enum Card {
        static let height: CGFloat = 90
        static let cornerRadius: CGFloat = 8
        static let spacing: CGFloat = 16
        static let horizontalMargin: CGFloat = 16

        static let leadingPadding: CGFloat = 15       // pencil at x=15
        static let trailingPadding: CGFloat = 10      // trash ends at x=348 of 358
        static let pencilToText: CGFloat = 24         // text starts at x=64
        static let checkboxToTrash: CGFloat = 15
        static let titleToDueSpacing: CGFloat = 5
        static let dueToCreatedSpacing: CGFloat = 4
    }

    enum Icon {
        static let header: CGFloat = 35               // gear and add-circle
        static let card: CGFloat = 25                 // pencil and checkbox
        static let delete: CGFloat = 24
        static let calendar: CGFloat = 25
    }

    enum Header {
        static let horizontalMargin: CGFloat = 27
        static let verticalPadding: CGFloat = 20
    }

    enum Form {
        static let horizontalMargin: CGFloat = 29
        static let barCornerRadius: CGFloat = 4
        static let textFieldHeight: CGFloat = 43
        static let dateBarHeight: CGFloat = 41
        static let barTextInset: CGFloat = 11
        static let textFieldTextInset: CGFloat = 18
        static let calendarTrailingInset: CGFloat = 8

        static let titleToLabel: CGFloat = 35
        static let labelToField: CGFloat = 8
        static let fieldToLabel: CGFloat = 19
        static let fieldToSaveButton: CGFloat = 54
    }

    /// The design does not use one consistent gap between groups, so each is kept
    /// as its own constant rather than averaged into a single value.
    enum Settings {
        static let horizontalMargin: CGFloat = 33
        static let radioToLabel: CGFloat = 13
        static let radioRowSpacing: CGFloat = 16      // rows sit 41pt apart, radios are 25pt
        static let titleToFilters: CGFloat = 33
        static let filtersLabelToRows: CGFloat = 14
        static let filtersToSortBy: CGFloat = 31
        static let sortByLabelToRows: CGFloat = 8
        static let sortByToDirection: CGFloat = 38
        static let directionLabelToRows: CGFloat = 14
        static let lastGroupToSave: CGFloat = 47
    }

    enum SaveButton {
        static let width: CGFloat = 81
        static let height: CGFloat = 40
        static let cornerRadius: CGFloat = 4
    }

    enum ScreenTitle {
        static let topPadding: CGFloat = 20
    }
}

extension View {
    /// SF Symbols sized to exact point dimensions, matching the design's icon boxes.
    func iconSize(_ size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }
}

extension Image {
    func themedIcon(_ size: CGFloat) -> some View {
        self.resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}
