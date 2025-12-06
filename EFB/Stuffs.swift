//
//  Stuffs.swift
//  EFB
//
//  Created by Jonathan Lim on 12/5/25.
//

import Foundation
import SwiftUI

extension Text {
    func info() -> Text {
        return self
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.secondary)
    }
}
