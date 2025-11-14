//
//  ifatcview.swift
//  EFB
//
//  Created by Jonathan Lim on 11/13/25.
//

import SwiftUI

struct IFATCView: View {
    @State var icao: String = "KJFK"
    var body: some View {
        TextField("ICAO", text: $icao)
        
    }
}
