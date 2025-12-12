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
extension View {
  @ViewBuilder
  func viewSize(_ perform: @escaping (CGSize) -> Void) -> some View {
    self.customBackground {
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    }
    .onPreferenceChange(SizePreferenceKey.self, perform: perform)
  }
  
  @ViewBuilder
  func customBackground<V: View>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View {
    self.background(alignment: alignment, content: content)
  }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}
