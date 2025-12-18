//
//  CFoxLoginView.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI

struct CFoxLogin: View {
    @Binding var isPresented: Bool
    @State var currentURL: URL = URL(string: "https://chartfox.org/login")!
    @State var cookie: [String: String] = [:]
    @AppStorage("cfoxPAT") var cfoxPAT: String = ""
    @AppStorage("cfoxSID") var cfoxSID: String = ""
    @AppStorage("xsrf") var xsrf: String = ""
    @AppStorage("rweb") var rweb: String = ""
    @AppStorage("rwebd") var rwebd: String = ""
    var body: some View {
        VStack {
            HStack {
                Text("\(currentURL)")
                    .padding(.top)
            }
            DWebView(url: URL(string: "https://chartfox.org/login")!, cookie: ["XSRF-TOKEN": xsrf, "chartfox_user_pat": cfoxPAT, "chartfoxv2_session": cfoxSID, rweb: rwebd], cUrl: $currentURL, newcookie: $cookie)
        }
        .onAppear {
            print("Login")
//            print(["XSRF-TOKEN": xsrf, "chartfox_user_pat": cfoxPAT, "chartfoxv2_session": cfoxSID, rweb: rwebd])
        }
        .onChange(of: cookie) { ov, nv in
            print("Cookie Change")
            for cookie in nv {
                if cookie.key.hasPrefix("remember_web_") {
//                    print(cookie.key)
                    rweb = cookie.key
                    rwebd = cookie.value
                }
            }
            if !rweb.isEmpty {
                if cfoxPAT.isEmpty || !(nv["chartfox_user_pat"]!.isEmpty) {
                    cfoxPAT = nv["chartfox_user_pat"]!
                    print("Set pat")
                    print(nv["chartfox_user_pat"]!)
                }
                cfoxSID = nv["chartfoxv2_session"]!
                xsrf = nv["XSRF-TOKEN"]!
//                print(cfoxPAT)
                testConnection() { r in
                    if r == .ok {
                        isPresented = false
                    }
                }
            }
        }
    }
}
