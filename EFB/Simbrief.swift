//
//  Simbrief.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI
import XMLCoder
import MapKit

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
        DWebView(url: URL(string: "https://dispatch.simbrief.com/home")!, cookie: ["\(simbriefUID.isEmpty ? "" : "simbrief_user")": "\(simbriefUID)", "\(simbriefSSO.isEmpty ? "" : "simbrief_sso")": "\(simbriefSSO)"], cUrl: $currentURL, newcookie: $cookie)
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

@Observable
class SBTOModel {
    var toPerf: TOPerformanceResponse? = nil
    var aircraft: AircraftData? = nil
    var ac: AircraftData? = nil
    var airframe: Airframe? = nil
    var airport: String = ""
    var rwy: String = ""
    var rwyLen: String = ""
    var rwys: Array<String> = []
    var lUnit: String = ""
    var wUnit: String = "kgs"
    var weight: String = ""
    var flap: String = ""
    var flaps: Array<String> = []
    var thrust: String = ""
    var thrusts: Array<String> = []
    var bleed: String = "1"
    var aIceE: Bool = false
    var aIce: String = "auto"
    var wind: String = ""
    var temp: String = ""
    var pUnit: String = "inHg"
    var pressure: String = "29.92"
    var sCond: String = "dry"
    var flex: String = "1"
    var cOpt: String = "1"
    var toStat: Int = 0
    var disable: Bool = false
    var text: String = ""
}

@Observable
class SBLDGModel {
    var ldgPerf: LDGPerformanceResponse? = nil

    var aircraft: AircraftData? = nil
    var acList: [AircraftData]? = nil
    var ac: AircraftData? = nil
    var airframe: Airframe? = nil

    var airport: String = ""
    var rwy: String = ""
    var rwyLen: String = ""
    var rwys: [String] = []

    var lUnit: String = "ft"
    var wUnit: String = "kgs"
    var weight: String = ""

    var flap: String = ""
    var flaps: [String] = []

    var brake: String = ""
    var brakes: [String] = []
    var reverser: String = "1"
    var vrefAdd: String = "5"
    var wind: String = ""
    var temp: String = ""
    var pUnit: String = "inHg"
    var pressure: String = "29.92"
    var sCond: String = "dry"
    var calcMethod: String = "inflight"
    var marginMethod: String = "factored"
    var ldgStat: Int = 0
    var disable: Bool = false
    var text: String = ""
}
struct SimbriefOFPView: View {
    @AppStorage("simbriefUID") var simbriefUID: String = ""
    @State var TO = SBTOModel()
    @State var LDG = SBLDGModel()
    @State var fPlan: FlightPlan?
    @State var acList: Array<AircraftData> = []
    @State var depDate: String = ""
    @State var depTime: String = ""
    @State var arrTime: String = ""
    @State var pdfData: Data? = nil
    @FocusState var ap: Bool
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
                        let fPlan = fPlan!
                        HStack {
                            AsyncImage(url: URL(string: "https://www.flightaware.com/images/airline_logos/180px/\(fPlan.general.icaoAirline?.value ?? "").png")){ image in
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            } placeholder: {
                                Image(systemName: "airplane.circle")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                            .padding(.trailing, 5)
                            Text("\(fPlan.general.icaoAirline?.value ?? "")\(fPlan.general.flightNumber ?? "")")
                                .font(.largeTitle.bold())
                        }
                        .padding(.top, 5)
                        TabView {
                            Tab("Overview", systemImage: "circle") {
                                List {
                                    Section("Flight Info") {
                                        Text("Flight Number: \(fPlan.general.icaoAirline?.value ?? "")\(fPlan.general.flightNumber ?? "")")
                                        Text("Departure Date: \(depDate) UTC")
                                        Text("Gate Departure Time: \(depTime) UTC")
                                        Text("Gate Arrival Time: \(arrTime) UTC")
                                        Text("Departure: \(fPlan.origin.icaoCode ?? "Unknown") / \(fPlan.origin.iataCode?.value ?? "Unknown") / \(fPlan.origin.name ?? "Unknown")")
                                        Text("Destination: \(fPlan.destination.icaoCode ?? "Unknown") / \(fPlan.destination.iataCode?.value ?? "Unknown") / \(fPlan.destination.name ?? "Unknown")")
                                        Text("Alternate: \(fPlan.alternate.icaoCode ?? "-") / \(fPlan.alternate.iataCode?.value ?? "-") / \(fPlan.alternate.name ?? "-")")
                                        Text("Release: \(fPlan.general.release ?? "Unknown")")
                                    }
                                    Section("Aircraft") {
                                        Text("ICAO: \(fPlan.aircraft.icaoCode ?? "Unknown")")
                                        Text("Name: \(fPlan.aircraft.name ?? "Unknown")")
                                        Text("Registeration: \(fPlan.aircraft.reg ?? "Unknown")")
                                        Text("Engines: \(fPlan.aircraft.engines ?? "Unknown")")
                                        Text("ICAO: \(fPlan.aircraft.icaoCode ?? "Unknown")")
                                    }
                                }
                            }
                            Tab("Route", systemImage: "circle") {
                                VStack{
                                    List {
                                        MapView(fPlan: fPlan)
                                            .cornerRadius(10)
                                            .frame(height: 500)
                                        Section("Planned Route") {
                                            Text("\(fPlan.general.route?.value ?? "Unknown")")
                                                .fontDesign(.monospaced)
                                            Button("Copy Route", action: {
                                                UIPasteboard.general.string = (fPlan.general.route?.value ?? "")
                                            })
                                        }
                                        Section("Information") {
                                            Text("AIRAC Cycle: \(fPlan.params.airac ?? "Unknown")")
                                            Text("Planned Departure Runway: \(fPlan.origin.planRwy ?? "Unknown")")
                                            Text("Planned Arrival Runway: \(fPlan.destination.planRwy ?? "Unknown")")
                                            Text("Planned SID: \(fPlan.general.sidIdent?.value ?? "Unknown")")
                                            Text("Planned SID Trans: \(fPlan.general.sidTrans?.value ?? "Unknown")")
                                            Text("Planned STAR: \(fPlan.general.starIdent?.value ?? "No Trans")")
                                            Text("Planned STAR Trans: \(fPlan.general.starTrans?.value ?? "No Trans")")
                                            Text("Planned Route Distance: \(fPlan.general.routeDistance ?? "Unknown") nm")
                                            Text("Initial Altitude: \(fPlan.general.initialAltitude ?? "Unknown")")
                                            Text("Cruise True Airspeed: \(fPlan.general.cruiseTas ?? "Unknown") knots")
                                            Text("Cruise Mach: Mach \(fPlan.general.cruiseMach ?? "Unknown")")
                                            Text("CLB Profile: \(fPlan.general.climbProfile ?? "Unknown")")
                                            Text("Cruise Profile: \(fPlan.general.cruiseProfile ?? "Unknown")")
                                            Text("DES Profile: \(fPlan.general.descentProfile ?? "Unknown")")
                                        }
                                    }
                                }
                            }
                            Tab("Load Sheet", systemImage: "circle") {
                                List {
                                    Text("Unit: \(fPlan.params.units ?? "Unknown")")
                                    Section("Weight") {
                                        Text("PAX: \(fPlan.weights.paxCount ?? "Unknown")")
                                        Text("Estimated ZFW: \(fPlan.weights.estZfw ?? "Unknown")")
                                        Text("Max ZFW: \(fPlan.weights.maxZfw ?? "Unknown")")
                                        Text("Estimated TOW: \(fPlan.weights.estTow ?? "Unknown")")
                                        Text("Max ZFW: \(fPlan.weights.maxTowStruct ?? "Unknown")")
                                        Text("Empty Weight: \(fPlan.weights.oew ?? "Unknown")")
                                        Text("Cargo: \(fPlan.weights.cargo ?? "Unknown")")
                                        Text("Payload: \(fPlan.weights.payload ?? "Unknown")")
                                    }
                                    Section("Fuel") {
                                        Text("Block Fuel: \(fPlan.fuel.planRamp ?? "Unknown")")
                                        Text("Taxi Fuel: \(fPlan.fuel.taxi ?? "Unknown")")
                                        Text("Takeoff Fuel: \(fPlan.fuel.planTakeoff ?? "Unknown")")
                                        Text("Landing Fuel: \(fPlan.fuel.planLanding ?? "Unknown")")
                                        Text("Enroute Burn: \(fPlan.fuel.enrouteBurn ?? "Unknown")")
                                        Text("Alternate Burn: \(fPlan.fuel.alternateBurn ?? "Unknown")")
                                        Text("Reserve Fuel: \(fPlan.fuel.reserve ?? "Unknown")")
                                    }
                                }
                            }
                            Tab("T.O. Perf", systemImage: "circle") {
                                if TO.toStat == 0 {
                                    ProgressView("Loading T.O. Performance Calculator...")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.secondary)
                                } else {
//                                    let acList = acList!
                                    List {
                                        Picker("Aircraft Type", selection: $TO.ac) {
                                            ForEach(acList, id: \.self) { acraft in
                                                Text("\(acraft.aircraftIcao) - \(acraft.aircraftName)")
                                                    .tag(acraft)
                                            }
                                        }
                                        if TO.toStat == -1 {
                                            Text("Unsupported Aircraft")
                                        } else {
                                        Picker("Airframe", selection: $TO.airframe) {
                                            ForEach(TO.ac!.airframes, id: \.airframeInternalID) { af in
                                                Text("\(af.airframeComments)")
                                                    .tag(af)
                                            }
                                        }
                                            HStack {
                                                Picker("Weight Units", selection: $TO.wUnit) {
                                                    Text("kgs")
                                                        .tag("kgs")
                                                    Text("lbs")
                                                        .tag("lbs")
                                                }
                                                Divider()
                                                HStack {
                                                    Text("Weight")
                                                    Spacer()
                                                    TextField("Weight", text: $TO.weight)
                                                        .multilineTextAlignment(.trailing)
                                                        .frame(maxWidth: 150)   // Prevents cycles by limiting width
                                                }
                                            }
                                            HStack {
                                                HStack {
                                                    Text("Airport")
                                                    Spacer()
                                                    TextField("Airport", text: $TO.airport)
                                                        .multilineTextAlignment(.trailing)
                                                        .frame(maxWidth: 150)
                                                        .focused($ap)
                                                }
                                                Divider()
                                                Picker("Runway", selection: $TO.rwy) {
                                                    ForEach(TO.rwys, id: \.self) { r in
                                                        Text("\(r)")
                                                            .tag(r)
                                                    }
                                                }
                                            }
                                            HStack {
                                                Picker("Flaps", selection: $TO.flap) {
                                                    Text("Optimum")
                                                        .tag("")
                                                    ForEach(TO.flaps, id: \.self) { f in
                                                        Text("\(f)")
                                                            .tag(f)
                                                    }
                                                }
                                                Divider()
                                                Picker("Takeoff Thrust", selection: $TO.thrust) {
                                                    Text("Optimum")
                                                        .tag("")
                                                    ForEach(TO.thrusts, id: \.self) { t in
                                                        Text("\(t)")
                                                            .tag(t)
                                                    }
                                                }
                                            }
                                            HStack {
                                                Text("Wind")
                                                Spacer()
                                                TextField("Wind", text: $TO.wind)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: 150)
                                            }
                                            HStack {
                                                Picker("Pressure Units", selection: $TO.pUnit) {
                                                    Text("inHg")
                                                        .tag("inHg")
                                                    Text("hPa")
                                                        .tag("hPa")
                                                }
                                                Divider()
                                                HStack {
                                                    Text("Altimeter")
                                                    Spacer()
                                                    TextField("Altimeter", text: $TO.pressure)
                                                        .multilineTextAlignment(.trailing)
                                                        .frame(maxWidth: 150)
                                                }
                                            }
                                            HStack {
                                                Text("Temperature (Celsius)")
                                                Spacer()
                                                TextField("Temperature", text: $TO.temp)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: 150)
                                            }
                                            Picker("Surface Condition", selection: $TO.sCond) {
                                                Text("Dry")
                                                    .tag("dry")
                                                Text("Wet")
                                                    .tag("wet")
                                            }
                                            HStack {
                                                Picker("Flex T.O.", selection: $TO.flex) {
                                                    Text("On")
                                                        .tag("1")
                                                    Text("Off")
                                                        .tag("0")
                                                }
                                                Divider()
                                                Picker("Climb Optimization", selection: $TO.cOpt) {
                                                    Text("On")
                                                        .tag("1")
                                                    Text("Off")
                                                        .tag("0")
                                                }
                                            }
                                            Section {
                                                Button(action: {
                                                    withAnimation {
                                                        TO.text = "loading"
                                                    }
                                                    getTOPerf(TO) { r in
                                                        withAnimation {
                                                            TO.text = r.message
                                                        }
                                                    }
                                                }, label: {
                                                    HStack {
                                                        Text("Calculate")
                                                        if TO.text == "loading" {
                                                            ProgressView()
                                                        }
                                                    }
                                                })
                                                .disabled(TO.text == "loading" || TO.weight.isEmpty || TO.airport.isEmpty || TO.rwy.isEmpty)
                                            }
                                            if TO.text.isEmpty == false {
                                                Text(TO.text)
                                                    .fontDesign(.monospaced)
                                            }
                                        }
                                    }
                                    .disabled(TO.disable)
                                    .onChange(of: TO.ac) { o, nv in
                                        let n = nv!
                                        TO.disable = true
                                        if n.statsTlr.value == nil {
                                            TO.toStat = -1
                                        } else {
                                            TO.airframe = n.airframes[0]
                                            TO.flaps = n.aircraftProfilesTakeoffFlaps
                                            TO.flap = ""
                                            TO.thrusts = n.aircraftProfilesTakeoffThrust
                                            TO.thrust = ""
                                            if n.aircraftProfilesTakeoffAntice.contains("2") {
                                                TO.aIceE = true
                                            }
                                            TO.toStat = 1
                                        }
                                        TO.disable = false
                                    }
                                    .onChange(of: ap) { o, n in
                                        TO.airport = TO.airport.uppercased()
                                        if !n {
                                            TO.disable = true
                                            getSBAirport(TO.airport) { r in
                                                TO.wind = "\(String(format: "%03d", r.metar_wind_direction))/\(String(format: "%02d", r.metar_wind_speed))"
                                                TO.pressure = r.metar_altimeter.description
                                                TO.temp = r.metar_temperature.description
                                                TO.rwys = []
                                                for i in r.runways {
                                                    TO.rwys.append(i.identifier)
                                                }
                                                TO.rwy = r.runways[0].identifier
                                                TO.rwyLen = "\(r.runways[0].length)"
                                                TO.disable = false
                                            }
                                        }
                                    }
                                }
                            }
                            Tab("LDG Perf", systemImage: "arrow.down.circle") {
                                if LDG.ldgStat == 0 {
                                    ProgressView("Loading Landing Performance Calculator...")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.secondary)
                                } else {
                                    List {
                                        Picker("Aircraft Type", selection: $LDG.ac) {
                                            ForEach(acList, id: \.self) { acraft in
                                                Text("\(acraft.aircraftIcao) - \(acraft.aircraftName)")
                                                    .tag(acraft as AircraftData?)
                                            }
                                        }
                                        if TO.toStat == -1 {
                                            Text("Unsupported Aircraft")
                                        } else {
                                            Picker("Airframe", selection: $LDG.airframe) {
                                                ForEach(LDG.ac!.airframes, id: \.airframeInternalID) { af in
                                                    Text("\(af.airframeComments)")
                                                        .tag(af as Airframe?)
                                                }
                                            }
                                            
                                            HStack {
                                                Text("Airport")
                                                Spacer()
                                                TextField("Airport", text: $LDG.airport)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: 150)
                                                    .focused($ap)
                                            }
                                            
                                            HStack {
                                                Text("Runway")
                                                Spacer()
                                                TextField("Runway", text: $LDG.rwy)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: 150)
                                            }
                                            
                                            HStack {
                                                Picker("Weight Units", selection: $LDG.wUnit) {
                                                    Text("kgs").tag("kgs")
                                                    Text("lbs").tag("lbs")
                                                }
                                                Divider()
                                                HStack {
                                                    Text("Weight")
                                                    Spacer()
                                                    TextField("Weight", text: $LDG.weight)
                                                        .multilineTextAlignment(.trailing)
                                                        .frame(maxWidth: 150)
                                                }
                                            }
                                            
                                            HStack {
                                                Picker("Flaps", selection: $LDG.flap) {
                                                    ForEach(LDG.flaps, id: \.self) { f in
                                                        Text("\(f)").tag(f)
                                                    }
                                                }
                                                Divider()
                                                Picker("Brakes", selection: $LDG.brake) {
                                                    Text("Optium").tag("")
                                                    ForEach(LDG.brakes, id: \.self) { b in
                                                        Text("\(b)").tag(b)
                                                    }
                                                }
                                            }
                                            
                                            HStack {
                                                Picker("Reverse", selection: $LDG.reverser) {
                                                    Text("Yes").tag("1")
                                                    Text("No").tag("0")
                                                }
                                            }
                                            
                                            HStack {
                                                Text("VREF Additive")
                                                Spacer()
                                                TextField("VREF Add", text: $LDG.vrefAdd)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: 150)
                                            }
                                            
                                            HStack {
                                                Text("Wind")
                                                Spacer()
                                                TextField("Wind", text: $LDG.wind)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: 150)
                                            }
                                            
                                            HStack {
                                                Text("Temperature (Celsius)")
                                                Spacer()
                                                TextField("Temperature", text: $LDG.temp)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: 150)
                                            }
                                            
                                            HStack {
                                                Picker("Pressure Units", selection: $LDG.pUnit) {
                                                    Text("inHg").tag("inHg")
                                                    Text("hPa").tag("hPa")
                                                }
                                                Divider()
                                                HStack {
                                                    Text("Altimeter")
                                                    Spacer()
                                                    TextField("Altimeter", text: $LDG.pressure)
                                                        .multilineTextAlignment(.trailing)
                                                        .frame(maxWidth: 150)
                                                }
                                            }
                                            
                                            Picker("Surface Condition", selection: $LDG.sCond) {
                                                Text("Dry").tag("dry")
                                                Text("Wet").tag("wet")
                                            }
                                            HStack {
                                                Picker("Calculation Method", selection: $LDG.calcMethod) {
                                                    Text("In-flight").tag("inflight")
                                                    Text("Manual").tag("manual")
                                                }
                                                
                                                Picker("Margin Method", selection: $LDG.marginMethod) {
                                                    Text("Factored").tag("factored")
                                                    Text("Braked").tag("braked")
                                                }
                                            }
                                            Section {
                                                Button(action: {
                                                    withAnimation {
                                                        LDG.text = "loading"
                                                    }
                                                    getLDGPerf(LDG) { r in
                                                        withAnimation {
                                                            LDG.text = r.message
                                                        }
                                                    }
                                                }, label: {
                                                    HStack {
                                                        Text("Calculate")
                                                        if LDG.text == "loading" {
                                                            ProgressView()
                                                        }
                                                    }
                                                })
                                                .disabled(LDG.text == "loading" || LDG.airport.isEmpty || LDG.rwy.isEmpty || LDG.weight.isEmpty || LDG.airport.isEmpty)
                                            }
                                            if !LDG.text.isEmpty {
                                                Text(LDG.text)
                                                    .fontDesign(.monospaced)
                                            }
                                        }
                                    }
                                    .disabled(LDG.disable)
                                    .onChange(of: LDG.ac) { o, nv in
                                        let n = nv!
                                        LDG.disable = true
                                        if n.statsTlr.value == nil {
                                            LDG.ldgStat = -1
                                        } else {
                                            LDG.airframe = n.airframes[0]
                                            LDG.flaps = n.aircraftProfilesLandingFlaps
                                            LDG.flap = n.aircraftProfilesLandingFlaps[0]
                                            LDG.brakes = n.aircraftProfilesLandingBrakes
                                            LDG.brake = ""
                                            LDG.ldgStat = 1
                                        }
                                        LDG.disable = false
                                    }
                                    .onChange(of: ap) { o, n in
                                        LDG.airport = LDG.airport.uppercased()
                                        if !n {
                                            LDG.disable = true
                                            getSBAirport(LDG.airport) { r in
                                                LDG.wind = "\(String(format: "%03d", r.metar_wind_direction))/\(String(format: "%02d", r.metar_wind_speed))"
                                                LDG.pressure = r.metar_altimeter.description
                                                LDG.temp = r.metar_temperature.description
                                                LDG.rwys = []
                                                for i in r.runways {
                                                    LDG.rwys.append(i.identifier)
                                                }
                                                LDG.rwy = r.runways[0].identifier
                                                LDG.rwyLen = "\(r.runways[0].length)"
                                                LDG.disable = false
                                            }
                                        }
                                    }
                                }
                            }
                            Tab("Briefing", systemImage: "circle") {
                                if pdfData != nil {
                                    PDFViewRepresentable(data: pdfData!, usePageViewController: true,backgroundColor: .mode)
                                }
                            }
                        }
                        .padding(.top, -10)
                    }
                }
                .onAppear {
                    getSBOFP() { r in
                        let url = URL(string: "\(r.files!.directory!)\(r.files!.pdf!.link!)")!
                        OperationQueue().addOperation {
                            do {
                                let data = try Data(contentsOf: url)
                                pdfData = data
                            } catch {
                                print(error)
                            }
                        }
                        let dUnix = r.times.schedOut!
                        let aUnix = r.times.schedIn!
                        let df = DateFormatter()
                        df.timeZone = TimeZone(abbreviation: "UTC")
                        df.dateFormat = "yyyy-MM-dd"
                        depDate = df.string(from: Date(timeIntervalSince1970: Double(dUnix)!))
                        df.dateFormat = "HH:mm"
                        depTime = df.string(from: Date(timeIntervalSince1970: Double(dUnix)!))
                        arrTime = df.string(from: Date(timeIntervalSince1970: Double(aUnix)!))
                        TO.weight = r.weights.estTow ?? ""
                        LDG.weight = r.weights.estLdw ?? ""
                        TO.airport = r.origin.icaoCode!
                        LDG.airport = r.destination.icaoCode!
                        if r.tlr.takeoff != nil {
                            TO.sCond = r.tlr.takeoff!.conditions!["surface_condition"]!
                        }
                        if r.tlr.landing != nil {
                            LDG.sCond = r.tlr.landing!.conditions!["surface_condition"]!
                        }
                        TO.rwy = r.origin.planRwy!
                        LDG.rwy = r.destination.planRwy!
                        TO.wUnit = r.params.units!
                        LDG.wUnit = r.params.units!
                        withAnimation {
                            fPlan = r
                        }
                        print("OFP fetch completed")
                        getAircraftsList() { res in
                            for airc in res {
                                if airc.statsTlr.value != nil {
                                    acList.append(airc)
                                }
                            }
//                            TO.acList = res
                            print("AClist set")
                            for i in res {
                                if i.aircraftIcao == r.aircraft.icaoCode! {
                                    if i.statsTlr.value == nil {
                                        TO.toStat = -1
                                        LDG.ldgStat = -1
                                    } else {
                                        TO.ac = i
                                        LDG.ac = i
                                        TO.flaps = i.aircraftProfilesTakeoffFlaps
                                        LDG.flaps = i.aircraftProfilesLandingFlaps
                                        TO.flap = ""
                                        LDG.flap = i.aircraftProfilesLandingFlaps[0]
                                        TO.thrusts = i.aircraftProfilesTakeoffThrust
                                        TO.thrust = ""
                                        LDG.brakes = i.aircraftProfilesLandingBrakes
                                        LDG.brake = ""
                                        if i.aircraftProfilesTakeoffAntice.contains("2") {
                                            TO.aIceE = true
                                        }
                                        for j in i.airframes {
                                            if j.airframeInternalID == r.aircraft.internalID! {
                                                TO.airframe = j
                                                LDG.airframe = j
                                                TO.toStat = 1
                                                LDG.ldgStat = 1
                                            }
                                        }
                                        break
                                    }
                                }
                            }
                        }
                        getSBAirport(r.origin.icaoCode!) { a in
                            TO.wind = "\(String(format: "%03d", a.metar_wind_direction))/\(String(format: "%02d", a.metar_wind_speed))"
                            TO.pressure = a.metar_altimeter.description
                            TO.temp = a.metar_temperature.description
                            for i in a.runways {
                                TO.rwys.append(i.identifier)
                                if i.identifier == r.origin.planRwy! {
                                    TO.rwyLen = "\(i.length)"
                                }
                            }
                        }
                        getSBAirport(r.destination.icaoCode!) { a in
                            LDG.wind = "\(String(format: "%03d", a.metar_wind_direction))/\(String(format: "%02d", a.metar_wind_speed))"
                            LDG.pressure = a.metar_altimeter.description
                            LDG.temp = a.metar_temperature.description
                            for i in a.runways {
                                LDG.rwys.append(i.identifier)
                                if i.identifier == r.destination.planRwy! {
                                    LDG.rwyLen = "\(i.length)"
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Simbrief OFP")
    }
}

struct Marker: Identifiable {
    let id = UUID()
    let location: CLLocationCoordinate2D
    let title: String
}
struct MapView: View {
    let fPlan: FlightPlan
    @State var focus: String = ""
    @State var coords = [CLLocationCoordinate2D]()
    @State var camera: MapCameraPosition = .automatic
    @State var size: CGFloat = .zero
    var body: some View {
        VStack {
            Map(position: $camera) {
                MapPolyline(
                    MKPolyline(
                        coordinates: coords,
                        count: coords.count
                    )
                )
                .stroke(.blue, lineWidth: 3)
                Annotation(
                    fPlan.origin.icaoCode!, coordinate: CLLocationCoordinate2D(
                        latitude: Double(fPlan.origin.posLat!)!,
                        longitude: Double(fPlan.origin.posLong!)!
                    )
                ) {
                    ZStack() {
                        Circle().frame(width: 10, height: 10)
                        //                                                        .background {
                        if fPlan.origin.icaoCode! == focus {
                            //                                VStack {
                            VStack {
                                Text(fPlan.origin.icaoCode!)
                                    .font(.caption.bold())
                                Text("Origin")
                                    .font(.caption.bold())
                            }
                            .padding(5)
                            .foregroundStyle(.black)
                            .background(.white.opacity(0.7))
                            .cornerRadius(10)
                            .viewSize { s in
                                size = s.height
                            }
                            .offset(y: -size/2 - 10)
                        }
                    }
                    .onTapGesture {
                        if fPlan.origin.icaoCode! == focus {
                            focus = ""
                        } else {
                            focus = fPlan.origin.icaoCode!
                        }
                    }
                }
                ForEach(fPlan.navlog.fix!.dropLast(), id: \.id) { nav in
                    Annotation(
                        "\(nav.ident! == focus ? "" : nav.ident!)", coordinate: CLLocationCoordinate2D(
                            latitude: Double(nav.posLat!)!,
                            longitude: Double(nav.posLong!)!
                        )
                    ) {
                        ZStack() {
                            Circle().frame(width: 10, height: 10)
                            //                                                        .background {
                            if nav.ident! == focus {
                                //                                VStack {
                                VStack {
                                    Text(nav.ident!)
                                        .font(.caption.bold())
                                    Text("Altitude: \(nav.altitudeFeet!)")
                                        .font(.caption.bold())
                                    Text("Speed: \(nav.indAirspeed!)")
                                        .font(.caption.bold())
                                    Text("Airway: \(nav.viaAirway ?? "DCT")")
                                        .font(.caption.bold())
                                }
                                .padding(5)
                                .foregroundStyle(.black)
                                .background(.white.opacity(0.7))
                                .cornerRadius(10)
                                .viewSize { s in
                                    size = s.height
                                }
                                .offset(y: -size/2 - 10)
                            }
                        }
//                            }
                        .onTapGesture {
                            if nav.ident! == focus {
                                focus = ""
                            } else {
                                focus = nav.ident!
                            }
                        }
                    }

                }
                Annotation(
                    fPlan.destination.icaoCode!, coordinate: CLLocationCoordinate2D(
                        latitude: Double(fPlan.destination.posLat!)!,
                        longitude: Double(fPlan.destination.posLong!)!
                    )
                ) {
                    ZStack() {
                        Circle().frame(width: 10, height: 10)
                        //                                                        .background {
                        if fPlan.destination.icaoCode! == focus {
                            //                                VStack {
                            VStack {
                                Text(fPlan.destination.icaoCode!)
                                    .font(.caption.bold())
                                Text("Destination")
                                    .font(.caption.bold())
                            }
                            .padding(5)
                            .foregroundStyle(.black)
                            .background(.white.opacity(0.7))
                            .cornerRadius(10)
                            .viewSize { s in
                                size = s.height
                            }
                            .offset(y: -size/2 - 10)
                        }
                    }
//                            }
                    .onTapGesture {
                        if fPlan.destination.icaoCode! == focus {
                            focus = ""
                        } else {
                            focus = fPlan.destination.icaoCode!
                        }
                    }
                }
            }
        }
//        .onTapGesture {
//            if focus != "" {
//                focus = ""
//            }
//        }
        .onAppear {
            coords.append(CLLocationCoordinate2D(
                latitude: Double(fPlan.origin.posLat!)!,
                longitude: Double(fPlan.origin.posLong!)!
            ))
            for i in fPlan.navlog.fix! {
                    coords.append(CLLocationCoordinate2D(
                        latitude: Double(i.posLat!)!,
                        longitude: Double(i.posLong!)!
                    ))
            }
            coords.append(CLLocationCoordinate2D(
                latitude: Double(fPlan.destination.posLat!)!,
                longitude: Double(fPlan.destination.posLong!)!
            ))
            let minLat = coords.map { $0.latitude }.min()!
            let maxLat = coords.map { $0.latitude }.max()!
            let minLon = coords.map { $0.longitude }.min()!
            let maxLon = coords.map { $0.longitude }.max()!

            let center = CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLon + maxLon) / 2
            )

            let span = MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) * 1.3,
                longitudeDelta: (maxLon - minLon) * 1.3
            )

            let reg = MKCoordinateRegion(center: center, span: span)
            camera = .region(reg)
        }
    }
}
