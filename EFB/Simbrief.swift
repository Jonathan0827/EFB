//
//  Simbrief.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI

struct Simbrief: View {
    var body: some View {
        WebView(url: URL(string: "https://dispatch.simbrief.com/home")!)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Simbrief Dispatch")
    }
}
