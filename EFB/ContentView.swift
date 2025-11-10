//
//  ContentView.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI
import PDFKit

struct ContentView: View {
    var columns: [GridItem] {
            return [
                .init(.adaptive(minimum: 300, maximum: 300))
            ]
        }
    @State var showLoginCFox: Bool = false
    @State var showLoginCFoxBtn: Bool = false
    @AppStorage("cfoxPAT") var cfoxPAT: String = ""
    @AppStorage("cfoxSID") var cfoxSID: String = ""
    @AppStorage("xsrf") var xsrf: String = ""
    @AppStorage("rweb") var rweb: String = ""
    @AppStorage("rwebd") var rwebd: String = ""
    var body: some View {
        NavigationView {
            LazyVGrid(columns: columns) {
                NavigationLink(destination: Simbrief()) {
                    VStack {
                        Image("Simbrief")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                        Text("Simbrief")
                            .foregroundStyle(.prm)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(uiColor: UIColor.systemGray6))
                    }
                }
                NavigationLink(destination: MSPlanner()) {
                    VStack {
                        Image("MSFS")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                        Text("MS Flight Planner")
                            .foregroundStyle(.prm)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(uiColor: UIColor.systemGray6))
                    }
                }
                NavigationLink(destination: ChartView()) {
                    VStack {
                        Image(systemName: "map.fill")
                            .resizable()
                            .frame(width: 180, height: 180)
                            .cornerRadius(20)
                            .tint(.prm)
                            .padding([.horizontal, .top], 25)
                        Text("Charts")
                            .foregroundStyle(.prm)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom)
                    }
                    
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(uiColor: UIColor.systemGray6))
                    }
                }
                VStack {
                    TextField("CFox PAT", text: $cfoxPAT)
                        .padding()
                    TextField("CFox SID", text: $cfoxSID)
                        .padding()
                    TextField("XSRF", text: $xsrf)
                        .padding()
                    TextField("rweb", text: $rweb)
                        .padding()
                    TextField("rwebd", text: $rwebd)
                        .padding()
                }
                VStack {
                    Button("Reset CFox", action: {
                        cfoxPAT = ""
                        cfoxSID = ""
                        xsrf = ""
                        rweb = ""
                        rwebd = ""
                    })
                    Button("Print Cookies", action: {
                        print("PAT: \(cfoxPAT)")
                        print("SID: \(cfoxSID)")
                        print("XSRF: \(xsrf)")
                    })
                    Button("Run test", action: {
                        testConnection {r in
                            print(r)
                        }
                    })
                    Button("Complete Clear", action: {
                        clearAllCookies()
                    })
                    Button("Test Auto Login", action: {
                        
                    })
                }
            }
            .navigationTitle("EFB")
            .toolbar {
                if cfoxPAT.isEmpty || cfoxSID.isEmpty || showLoginCFoxBtn {
                    Button("Login to ChartFox", action: {
                        showLoginCFox = true
                    })
                }
            }
        }
        .onAppear {
            testConnection() { r in
                print(r)
                if r != .ok {
                    showLoginCFoxBtn = true
                }
            }
        }
        .onChange(of: showLoginCFox) { _, _ in
            testConnection() { r in
                print(r)
                if r != .ok {
                    showLoginCFoxBtn = false
                }
            }
        }
        .sheet(isPresented: $showLoginCFox) {
            CFoxLogin(isPresented: $showLoginCFox)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    }
