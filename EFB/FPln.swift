//
//  FPln.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI

struct MSPlanner: View {
    var body: some View {
        WebView(url: URL(string: "https://planner.flightsimulator.com")!)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("MS Flight Planner")
    }
}
