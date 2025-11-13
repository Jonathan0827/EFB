//
//  ContentView.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI
import PDFKit
import Alamofire
import LocalConsole
internal import Combine

struct ContentView: View {
    @AppStorage("cfoxPAT") var cfoxPAT: String = ""
    @AppStorage("cfoxSID") var cfoxSID: String = ""
    @AppStorage("xsrf") var xsrf: String = ""
    @AppStorage("rweb") var rweb: String = ""
    @AppStorage("rwebd") var rwebd: String = ""
    @State var showLoginCFox: Bool = false
    @State var showLoginCFoxBtn: Bool = false
    @State var showAdd: Bool = false
    @State var secondDP: Bool = false
    @State var currentOrientation = UIDevice.current.orientation
    
    private let orientationChangedNotification = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    var body: some View {
        let columns: [GridItem] = currentOrientation.rawValue == 1 || currentOrientation.rawValue == 2 || !secondDP
        ? [GridItem(.flexible())]
        : [GridItem(.flexible()), GridItem(.flexible())]
        NavigationView {
            VStack {
                if showAdd {
                    HStack {
                        VStack(alignment: .trailing) {
                            Text("Last Cookie Update:")
                            Text("Current Unix Time:")
                            if readUserDefault("LastCookieUpdate") != nil {
                                Text("Cookie Reset required:")
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("\(String(describing: readUserDefault("LastCookieUpdate") ?? "N/A"))")
                            Text("\(Date().timeIntervalSince1970.description)")
                            if readUserDefault("LastCookieUpdate") != nil {
                                Text("\(readUserDefault("LastCookieUpdate")! as! Double - Date().timeIntervalSince1970 > 7200 ? "Yes" : "No")")
                            }
                        }
                        VStack {
                            TextField("CFox PAT", text: $cfoxPAT)
                            TextField("CFox SID", text: $cfoxSID)
                            TextField("XSRF", text: $xsrf)
                            TextField("rweb", text: $rweb)
                            TextField("rwebd", text: $rwebd)
                        }
                    }
                }
                LazyVGrid(columns: columns) {
                    MainView(
                        showLoginCFox: $showLoginCFox,
                        showLoginCFoxBtn: $showLoginCFoxBtn,
                        showAdd: $showAdd
                    )
                    .frame(height: (currentOrientation.rawValue == 1 || currentOrientation.rawValue == 2) && secondDP ? UIScreen.main.bounds.height/2-25 : UIScreen.main.bounds.height-30)
                    if secondDP {
                        MainView(
                            showLoginCFox: $showLoginCFox,
                            showLoginCFoxBtn: $showLoginCFoxBtn,
                            showAdd: $showAdd
                        )
                        .frame(height: (currentOrientation.rawValue == 1 || currentOrientation.rawValue == 2) && secondDP ? UIScreen.main.bounds.height/2-25 : UIScreen.main.bounds.height-30)
                    }
                }
            }
            .navigationTitle("EFB")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                HStack {
                    if cfoxPAT.isEmpty || cfoxSID.isEmpty || showLoginCFoxBtn {
                        Button("Login to ChartFox", action: {
                            showLoginCFox = true
                        })
                    }
                    Button("\(secondDP ? "Hide" : "Show") Secondary Screen", action: {
                        withAnimation {
                            secondDP.toggle()
                        }
                    })
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(orientationChangedNotification) { _ in
            if UIDevice.current.orientation.rawValue <= 4 {
                self.currentOrientation = UIDevice.current.orientation
            }
        }
    }
}
struct MainView: View {
    var columns: [GridItem] {
        return [
            .init(.adaptive(minimum: 200, maximum: 200))
        ]
    }
    @Binding var showLoginCFox: Bool
    @Binding var showLoginCFoxBtn: Bool
    @Binding var showAdd: Bool
    @AppStorage("cfoxPAT") var cfoxPAT: String = ""
    @AppStorage("cfoxSID") var cfoxSID: String = ""
    @AppStorage("xsrf") var xsrf: String = ""
    @AppStorage("rweb") var rweb: String = ""
    @AppStorage("rwebd") var rwebd: String = ""
    var body: some View {
        NavigationView {
            //        ScrollView() {
            //                LazyVGrid(columns: columns) {
            VStack {
                Spacer()
                HStack {
                    NavigationLink(destination: Simbrief()) {
                        VStack {
                            Image("Simbrief")
                                .resizable()
                                .frame(width: 150, height: 150)
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
                                .frame(width: 150, height: 150)
                                .cornerRadius(20)
                            Text("MSFS")
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
                                .frame(width: 130, height: 130)
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
                }
                HStack {
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
                            testConnection() { r in
                                print("r rcvd")
                                print(r)
                                if r != .ok {
                                    showLoginCFoxBtn = true
                                } else {
                                    showLoginCFoxBtn = false
                                }
                            }
                        })
                        Button("Toggle Console", action: {
                            consoleManager.isVisible.toggle()
                        })
                    }
                    VStack {
                        Button("Test AutoLogin", action: {
                            AF.request("https://chartfox.org/", headers: headers())
                                .saveLogin()
                                .response {_ in
                                    testConnection { r in
                                        print("r rcvd")
                                        print(r)
                                        if r != .ok {
                                            showLoginCFoxBtn = true
                                        } else {
                                            showLoginCFoxBtn = false
                                        }
                                    }
                                }
                        })
                        Button("Clear ChartFox Cookies", action: {
                            clearChartFox()
                        })
                        Button("Test IFATC", action: {
                            getGateInfo("RKSI") { r in
                                print(r)
                            }
                            getAllGates("RKSI") { r in
                                print(r[0])
                            }
                        })
                        Button("Toggle showAdd", action: {
                            withAnimation {
                                showAdd.toggle()
                            }
                        })
                    }
                }
                //            }
                //        }
                Spacer()
            }
        }
        .onAppear {
            consoleManager.isVisible = true
        }
        //        .onChange(of: showLoginCFox) { _, _ in
        //            testConnection() { r in
        //                print(r)
        //                if r != .ok {
        //                    showLoginCFoxBtn = false
        //                }
        //            }
        //        }
        .sheet(isPresented: $showLoginCFox) {
            CFoxLogin(isPresented: $showLoginCFox)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
