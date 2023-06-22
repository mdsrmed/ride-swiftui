//
//  Color.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/22/23.
//

import Foundation
import SwiftUI

extension Color {
     static let theme = ColorTheme()
}

struct ColorTheme {
    let backgroundColor = Color("BackgroundColor")
    let secondaryBackgroundColor = Color("SecondaryBackgroudColor")
    let primaryTextColor = Color("PrimaryTextColor")
}
