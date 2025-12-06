//
//  Simbrief.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI
import XMLCoder

struct Simbrief: View {
    var body: some View {
        HStack {
            NavigationLink(destination: SimbriefWebView()) {
                ZStack {
                    VStack {
                        Image("Simbrief")
                            .resizable()
                            .frame(width: 130, height: 130)
                            .cornerRadius(20)
                        Text("Simbrief Web")
                            .foregroundStyle(.prm)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Text("Search Flights")
                        .hidden()
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(uiColor: UIColor.systemGray6))
                }
            }
            NavigationLink(destination: SimbriefOFPView()) {
                ZStack {
                    VStack {
                        Image(systemName: "document.on.document")
                            .resizable()
                            .frame(width: 100, height: 130)
                            .cornerRadius(20)
                            .foregroundStyle(.prm)
                        Text("Simbrief OFP")
                            .foregroundStyle(.prm)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Text("Search Flights")
                        .hidden()
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(uiColor: UIColor.systemGray6))
                }
            }
        }
        .navigationTitle("Simbrief")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SimbriefWebView: View {
    @State var currentURL: URL = URL(string: "https://dispatch.simbrief.com/home")!
    @State var cookie: [String: String] = [:]
    @AppStorage("simbriefSSO") var simbriefSSO: String = ""
    @AppStorage("simbriefUID") var simbriefUID: String = ""
    var body: some View {
        DWebView(url: URL(string: "https://dispatch.simbrief.com/home")!, cookie: [:], cUrl: $currentURL, newcookie: $cookie)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Simbrief WebView")
            .onChange(of: cookie) { ov, nv in
                print("Cookie Change")
                for cookie in nv {
                    if cookie.key == "simbrief_sso" {
                        print("Saving Simbrief SSO")
                        simbriefSSO = cookie.value
                    }
                    if cookie.key == "simbrief_user" {
                        print("Saving Simbrief UID")
                        simbriefUID = cookie.value
                    }
                }
            }
    }
}

struct SimbriefOFPView: View {
    @AppStorage("simbriefUID") var simbriefUID: String = ""
    @State var fPlan: FlightPlan? = nil
    @State var depDate: String = ""
    @State var depTime: String = ""
    @State var arrTime: String = ""
    @State var pdfData: Data? = nil
    var body: some View {
        VStack {
            if simbriefUID.isEmpty {
                Text("Configure Simbrief Username")
                    .info()
            } else {
                VStack {
                    if fPlan == nil {
                        HStack {
                            Text("Loading Flight Plan")
                                .info()
                            ProgressView()
                        }
                    } else {
                        HStack {
                            AsyncImage(url: URL(string: "https://www.flightaware.com/images/airline_logos/180px/\(fPlan!.general.icaoAirline ?? "").png")){ image in
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            } placeholder: {
                                Image(systemName: "airplane.circle")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                            .padding(.trailing, 5)
                            Text("\(fPlan!.general.icaoAirline ?? "")\(fPlan!.general.flightNumber ?? "")")
                                .font(.largeTitle.bold())
                        }
                        TabView {
                            Tab("Overview", systemImage: "circle") {
                                List {
                                    Section("Flight Info") {
                                        Text("Flight Number: \(fPlan!.general.icaoAirline ?? "")\(fPlan!.general.flightNumber ?? "")")
                                        Text("Departure Date: \(depDate) UTC")
                                        Text("Gate Departure Time: \(depTime) UTC")
                                        Text("Gate Arrival Time: \(arrTime) UTC")
                                        Text("Departure: \(fPlan!.origin.icaoCode ?? "Unknown") / \(fPlan!.origin.iataCode ?? "Unknown") / \(fPlan!.origin.name ?? "Unknown")")
                                        Text("Destination: \(fPlan!.destination.icaoCode ?? "Unknown") / \(fPlan!.destination.iataCode ?? "Unknown") / \(fPlan!.destination.name ?? "Unknown")")
                                        Text("Alternate: \(fPlan!.alternate.icaoCode ?? "-") / \(fPlan!.alternate.iataCode ?? "-") / \(fPlan!.alternate.name ?? "-")")
                                        Text("Release: \(fPlan!.general.release ?? "Unknown")")
                                    }
                                    Section("Aircraft") {
                                        Text("ICAO: \(fPlan!.aircraft.icaoCode ?? "Unknown")")
                                        Text("Name: \(fPlan!.aircraft.name ?? "Unknown")")
                                        Text("Registeration: \(fPlan!.aircraft.reg ?? "Unknown")")
                                        Text("Engines: \(fPlan!.aircraft.engines ?? "Unknown")")
                                        Text("ICAO: \(fPlan!.aircraft.icaoCode ?? "Unknown")")
                                    }
                                }
                            }
                            Tab("Route", systemImage: "circle") {
                                List {
                                    Section("Planned Route") {
                                        Text("\(fPlan!.general.route ?? "Unknown")")
                                            .fontDesign(.monospaced)
                                        Button("Copy Route", action: {
                                            UIPasteboard.general.string = (fPlan!.general.route ?? "")
                                        })
                                    }
                                    Section("Information") {
                                        Text("AIRAC Cycle: \(fPlan!.params.airac ?? "Unknown")")
                                        Text("Planned SID: \(fPlan!.general.sidIdent ?? "Unknown")")
                                        Text("Planned STAR: \(fPlan!.general.starIdent ?? "Unknown")")
                                        Text("Planned Route Distance: \(fPlan!.general.routeDistance ?? "Unknown") nm")
                                        Text("Initial Altitude: \(fPlan!.general.initialAltitude ?? "Unknown")")
                                        Text("Cruise True Airspeed: \(fPlan!.general.cruiseTas ?? "Unknown") knots")
                                        Text("Cruise Mach: Mach \(fPlan!.general.cruiseMach ?? "Unknown")")
                                        Text("CLB Profile: \(fPlan!.general.climbProfile ?? "Unknown")")
                                        Text("Cruise Profile: \(fPlan!.general.cruiseProfile ?? "Unknown")")
                                        Text("DES Profile: \(fPlan!.general.descentProfile ?? "Unknown")")
                                    }
                                }
                            }
                            Tab("Load Sheet", systemImage: "circle") {
                                List {
                                    Text("Unit: \(fPlan!.params.units ?? "Unknown")")
                                    Section("Weight") {
                                        Text("PAX: \(fPlan!.weights.paxCount ?? "Unknown")")
                                        Text("Estimated ZFW: \(fPlan!.weights.estZfw ?? "Unknown")")
                                        Text("Max ZFW: \(fPlan!.weights.maxZfw ?? "Unknown")")
                                        Text("Estimated TOW: \(fPlan!.weights.estTow ?? "Unknown")")
                                        Text("Max ZFW: \(fPlan!.weights.maxTowStruct ?? "Unknown")")
                                        Text("Empty Weight: \(fPlan!.weights.oew ?? "Unknown")")
                                        Text("Cargo: \(fPlan!.weights.cargo ?? "Unknown")")
                                        Text("Payload: \(fPlan!.weights.payload ?? "Unknown")")
                                    }
                                    Section("Fuel") {
                                        Text("Block Fuel: \(fPlan!.fuel.planRamp ?? "Unknown")")
                                        Text("Taxi Fuel: \(fPlan!.fuel.taxi ?? "Unknown")")
                                        Text("Takeoff Fuel: \(fPlan!.fuel.planTakeoff ?? "Unknown")")
                                        Text("Landing Fuel: \(fPlan!.fuel.planLanding ?? "Unknown")")
                                        Text("Enroute Burn: \(fPlan!.fuel.enrouteBurn ?? "Unknown")")
                                        Text("Alternate Burn: \(fPlan!.fuel.alternateBurn ?? "Unknown")")
                                        Text("Reserve Fuel: \(fPlan!.fuel.reserve ?? "Unknown")")
                                    }
                                }
                            }
//                            Tab("Takeoff", systemImage: "circle") {
//                            }
                            Tab("Briefing", systemImage: "circle") {
                                if pdfData != nil {
                                    PDFViewRepresentable(data: pdfData!, backgroundColor: .mode)
                                }
                            }
                        }
                        .padding(.top, -10)
                    }
                }
                .onAppear {
                    getSBOFP() { r in
//                        pdfData = r.files!.directory
                        let url = URL(string: "\(r.files!.directory!)\(r.files!.pdf!.link!)")!
                        do {
                            let data = try Data(contentsOf: url)
                            pdfData = data
                        } catch {
                            print(error)
                        }
                        fPlan = r
                        let dUnix = r.times.schedOut!
                        let aUnix = r.times.schedIn!
                        let df = DateFormatter()
                        df.timeZone = TimeZone(abbreviation: "UTC")
                        df.dateFormat = "yyyy-MM-dd"
                        depDate = df.string(from: Date(timeIntervalSince1970: Double(dUnix)!))
                        df.dateFormat = "HH:mm"
                        depTime = df.string(from: Date(timeIntervalSince1970: Double(dUnix)!))
                        arrTime = df.string(from: Date(timeIntervalSince1970: Double(aUnix)!))
//                        print(r)
//                        do {
//                            let url = URL(string: "\(r.params.xml_file ?? "")")!
//                            let data = try Data(contentsOf: url)
//                            fPlanOFP = try XMLDecoder().decode(OFPData.self, from: Data(String(data: data, encoding: .utf8)!.utf8))
////                            print(fPlanOFP)
//                        } catch {
//                            print(error)
//                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Simbrief OFP")
    }
}
