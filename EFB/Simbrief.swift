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

@Observable
class SBTOModel {
    var fPlan: FlightPlan? = nil
    var depDate: String = ""
    var depTime: String = ""
    var arrTime: String = ""
    var pdfData: Data? = nil
    var toPerf: TOPerformanceResponse? = nil
    var aircraft: AircraftData? = nil
    var acList: Array<AircraftData>? = nil
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

struct SimbriefOFPView: View {
    @AppStorage("simbriefUID") var simbriefUID: String = ""
    @State var model = SBTOModel()
    @FocusState var ap: Bool
    var body: some View {
        VStack {
            
            if simbriefUID.isEmpty {
                Text("Configure Simbrief Username")
                    .info()
            } else {
                VStack {
                    if model.fPlan == nil {
                        HStack {
                            Text("Loading Flight Plan")
                                .info()
                            ProgressView()
                        }
                    } else {
                        let fPlan = model.fPlan!
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
                                        Text("Departure Date: \(model.depDate) UTC")
                                        Text("Gate Departure Time: \(model.depTime) UTC")
                                        Text("Gate Arrival Time: \(model.arrTime) UTC")
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
                                if model.toStat == 0 {
                                    ProgressView("Loading T.O. Performance Calculator...")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.secondary)
                                } else {
                                    let acList = model.acList!
                                    List {
                                        Picker("Aircraft Type", selection: $model.ac) {
                                            ForEach(acList, id: \.self) { acraft in
                                                Text("\(acraft.aircraftIcao) - \(acraft.aircraftName)")
                                                    .tag(acraft)
                                            }
                                        }
                                        if model.toStat == -1 {
                                            Text("Unsupported Aircraft")
                                        } else {
                                        Picker("Airframe", selection: $model.airframe) {
                                            ForEach(model.ac!.airframes, id: \.airframeInternalID) { af in
                                                Text("\(af.airframeComments)")
                                                    .tag(af)
                                            }
                                        }
                                            HStack {
                                                Picker("Weight Units", selection: $model.wUnit) {
                                                    Text("kgs")
                                                        .tag("kgs")
                                                    Text("lbs")
                                                        .tag("lbs")
                                                }
                                                Divider()
                                                HStack {
                                                    Text("Weight")
                                                    Spacer()
                                                    TextField("Weight", text: $model.weight)
                                                        .multilineTextAlignment(.trailing)
                                                        .frame(maxWidth: 150)   // Prevents cycles by limiting width
                                                }
                                            }
                                            HStack {
                                                HStack {
                                                    Text("Airport")
                                                    Spacer()
                                                    TextField("Airport", text: $model.airport)
                                                        .multilineTextAlignment(.trailing)
                                                        .frame(maxWidth: 150)
                                                        .focused($ap)
                                                }
                                                Divider()
                                                Picker("Runway", selection: $model.rwy) {
                                                    ForEach(model.rwys, id: \.self) { r in
                                                        Text("\(r)")
                                                            .tag(r)
                                                    }
                                                }
                                            }
                                            HStack {
                                                Picker("Flaps", selection: $model.flap) {
                                                    Text("Optimum")
                                                        .tag("")
                                                    ForEach(model.flaps, id: \.self) { f in
                                                        Text("\(f)")
                                                            .tag(f)
                                                    }
                                                }
                                                Divider()
                                                Picker("Takeoff Thrust", selection: $model.thrust) {
                                                    Text("Optimum")
                                                        .tag("")
                                                    ForEach(model.thrusts, id: \.self) { t in
                                                        Text("\(t)")
                                                            .tag(t)
                                                    }
                                                }
                                            }
                                            HStack {
                                                Text("Wind")
                                                Spacer()
                                                TextField("Wind", text: $model.wind)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: 150)
                                            }
                                            HStack {
                                                Picker("Pressure Units", selection: $model.pUnit) {
                                                    Text("inHg")
                                                        .tag("inHg")
                                                    Text("hPa")
                                                        .tag("hPa")
                                                }
                                                Divider()
                                                HStack {
                                                    Text("Altimeter")
                                                    Spacer()
                                                    TextField("Altimeter", text: $model.pressure)
                                                        .multilineTextAlignment(.trailing)
                                                        .frame(maxWidth: 150)
                                                }
                                            }
                                            HStack {
                                                Text("Temperature (Celsius)")
                                                Spacer()
                                                TextField("Temperature", text: $model.temp)
                                                    .multilineTextAlignment(.trailing)
                                                    .frame(maxWidth: 150)
                                            }
                                            Picker("Surface Condition", selection: $model.sCond) {
                                                Text("Dry")
                                                    .tag("dry")
                                                Text("Wet")
                                                    .tag("wet")
                                            }
                                            HStack {
                                                Picker("Flex T.O.", selection: $model.flex) {
                                                    Text("On")
                                                        .tag("1")
                                                    Text("Off")
                                                        .tag("0")
                                                }
                                                Divider()
                                                Picker("Climb Optimization", selection: $model.cOpt) {
                                                    Text("On")
                                                        .tag("1")
                                                    Text("Off")
                                                        .tag("0")
                                                }
                                            }
                                            Section {
                                                Button(action: {
                                                    withAnimation {
                                                        model.text = "loading"
                                                    }
                                                    getTOPerf(ac: model.ac!.aircraftIcao, airport: model.airport, rwy: model.rwy, lUnit: model.lUnit, wUnit: model.wUnit, weight: model.weight, flap: model.flap, thrust: model.thrust, bleed: model.bleed, aIce: model.aIce, wind: model.wind, temp: model.temp, pUnit: model.pUnit, pressure: model.pressure, sCond: model.sCond, flex: model.flex, cOpt: model.cOpt) { r in
                                                        withAnimation {
                                                            model.text = r.message
                                                        }
                                                    }
                                                }, label: {
                                                    HStack {
                                                        Text("Calculate")
                                                        if model.text == "loading" {
                                                            ProgressView()
                                                        }
                                                    }
                                                })
                                                .disabled(model.text == "loading" || model.weight.isEmpty || model.airport.isEmpty || model.rwy.isEmpty)
                                            }
                                            if model.text.isEmpty == false {
                                                Text(model.text)
                                                    .fontDesign(.monospaced)
                                            }
                                        }
                                    }
                                    .disabled(model.disable)
                                    .onChange(of: model.ac) { o, nv in
                                        let n = nv!
                                        model.disable = true
                                        if n.statsTlr.value == nil {
                                            model.toStat = -1
                                        } else {
                                            model.airframe = n.airframes[0]
                                            model.flaps = n.aircraftProfilesTakeoffFlaps
                                            model.flap = ""
                                            model.thrusts = n.aircraftProfilesTakeoffThrust
                                            model.thrust = ""
                                            if n.aircraftProfilesTakeoffAntice.contains("2") {
                                                model.aIceE = true
                                            }
                                            model.toStat = 1
                                        }
                                        model.disable = false
                                    }
                                    .onChange(of: ap) { o, n in
                                        model.airport = model.airport.uppercased()
                                        if !n {
                                            model.disable = true
                                            getSBAirport(model.airport) { r in
                                                model.wind = "\(String(format: "%03d", r.metar_wind_direction))/\(String(format: "%02d", r.metar_wind_speed))"
                                                model.pressure = r.metar_altimeter.description
                                                model.temp = r.metar_temperature.description
                                                model.rwys = []
                                                for i in r.runways {
                                                    model.rwys.append(i.identifier)
                                                }
                                                model.rwy = r.runways[0].identifier
                                                model.rwyLen = "\(r.runways[0].length)"
                                                model.disable = false
                                            }
                                        }
                                    }
                                }
                            }
                            Tab("Briefing", systemImage: "circle") {
                                if model.pdfData != nil {
                                    PDFViewRepresentable(data: model.pdfData!, usePageViewController: true,backgroundColor: .mode)
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
                                model.pdfData = data
                            } catch {
                                print(error)
                            }
                        }
                        let dUnix = r.times.schedOut!
                        let aUnix = r.times.schedIn!
                        let df = DateFormatter()
                        df.timeZone = TimeZone(abbreviation: "UTC")
                        df.dateFormat = "yyyy-MM-dd"
                        model.depDate = df.string(from: Date(timeIntervalSince1970: Double(dUnix)!))
                        df.dateFormat = "HH:mm"
                        model.depTime = df.string(from: Date(timeIntervalSince1970: Double(dUnix)!))
                        model.arrTime = df.string(from: Date(timeIntervalSince1970: Double(aUnix)!))
                        model.weight = r.weights.estTow ?? ""
                        model.airport = r.origin.icaoCode!
                        if r.tlr.takeoff != nil {
                            model.sCond = r.tlr.takeoff!.conditions!["surface_condition"]!
                        }
                        model.rwy = r.origin.planRwy!
                        model.wUnit = r.params.units!
                        withAnimation {
                            model.fPlan = r
                        }
                        print("OFP fetch completed")
                        getAircraftsList() { res in
                            model.acList = res
                            print("AClist set")
                            for i in res {
                                if i.aircraftIcao == r.aircraft.icaoCode! {
                                    model.ac = i
                                    if i.statsTlr.value == nil {
                                        model.toStat = -1
                                    } else {
                                        model.flaps = i.aircraftProfilesTakeoffFlaps
                                        model.flap = ""
                                        model.thrusts = i.aircraftProfilesTakeoffThrust
                                        model.thrust = ""
                                        if i.aircraftProfilesTakeoffAntice.contains("2") {
                                            model.aIceE = true
                                        }
                                        for j in i.airframes {
                                            if j.airframeInternalID == r.aircraft.internalID! {
                                                model.airframe = j
                                                model.toStat = 1
                                            }
                                        }
                                        break
                                    }
                                }
                            }
                        }
                        getSBAirport(r.origin.icaoCode!) { a in
                            model.wind = "\(String(format: "%03d", a.metar_wind_direction))/\(String(format: "%02d", a.metar_wind_speed))"
                            model.pressure = a.metar_altimeter.description
                            model.temp = a.metar_temperature.description
                            for i in a.runways {
                                model.rwys.append(i.identifier)
                                if i.identifier == r.origin.planRwy! {
                                    model.rwyLen = "\(i.length)"
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
//struct MapView: View {
//    let fPlan: FlightPlan
//    @State var focus: String = ""
//    @State var coords = [CLLocationCoordinate2D]()
//    @State var camera: MapCameraPosition = .automatic
//    @State var size: CGFloat = .zero
//
//    var body: some View {
//        VStack {
//            if !coords.isEmpty {
//                Map(position: $camera) {
//
//                    // ROUTE LINE
//                    MapPolyline(
//                        MKPolyline(
//                            coordinates: coords,
//                            count: coords.count
//                        )
//                    )
//                    .stroke(.blue, lineWidth: 3)
//
//                    // ORIGIN
//                    if let oLat = Double(fPlan.origin.posLat!),
//                       let oLon = Double(fPlan.origin.posLong!) {
//
//                        Annotation(
//                            fPlan.origin.icaoCode!,
//                            coordinate: CLLocationCoordinate2D(latitude: oLat, longitude: oLon)
//                        ) {
//                            ZStack {
//                                Circle().frame(width: 10, height: 10)
//                                if fPlan.origin.icaoCode! == focus {
//                                    VStack {
//                                        Text(fPlan.origin.icaoCode!)
//                                            .font(.caption.bold())
//                                        Text("Origin")
//                                            .font(.caption.bold())
//                                    }
//                                    .padding(5)
//                                    .foregroundStyle(.black)
//                                    .background(.white.opacity(0.7))
//                                    .cornerRadius(10)
//                                    .viewSize { s in size = s.height }
//                                    .offset(y: -size/2 - 10)
//                                }
//                            }
//                            .onTapGesture {
//                                focus = (focus == fPlan.origin.icaoCode!) ? "" : fPlan.origin.icaoCode!
//                            }
//                        }
//                    }
//
//                    // FIXES
//                    ForEach(fPlan.navlog.fix!.dropLast(), id: \.id) { nav in
//                        if let lat = Double(nav.posLat!), let lon = Double(nav.posLong!) {
//                            Annotation(
//                                "\(nav.ident! == focus ? "" : nav.ident!)",
//                                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)
//                            ) {
//                                ZStack {
//                                    Circle().frame(width: 10, height: 10)
//                                    if nav.ident! == focus {
//                                        VStack {
//                                            Text(nav.ident!)
//                                                .font(.caption.bold())
//                                            Text("Altitude: \(nav.altitudeFeet!)")
//                                                .font(.caption.bold())
//                                            Text("Speed: \(nav.indAirspeed!)")
//                                                .font(.caption.bold())
//                                            Text("Airway: \(nav.viaAirway ?? "DCT")")
//                                                .font(.caption.bold())
//                                        }
//                                        .padding(5)
//                                        .foregroundStyle(.black)
//                                        .background(.white.opacity(0.7))
//                                        .cornerRadius(10)
//                                        .viewSize { s in size = s.height }
//                                        .offset(y: -size/2 - 10)
//                                    }
//                                }
//                                .onTapGesture {
//                                    focus = (focus == nav.ident!) ? "" : nav.ident!
//                                }
//                            }
//                        }
//                    }
//
//                    // DESTINATION
//                    if let dLat = Double(fPlan.destination.posLat!),
//                       let dLon = Double(fPlan.destination.posLong!) {
//
//                        Annotation(
//                            fPlan.destination.icaoCode!,
//                            coordinate: CLLocationCoordinate2D(latitude: dLat, longitude: dLon)
//                        ) {
//                            ZStack {
//                                Circle().frame(width: 10, height: 10)
//                                if fPlan.destination.icaoCode! == focus {
//                                    VStack {
//                                        Text(fPlan.destination.icaoCode!)
//                                            .font(.caption.bold())
//                                        Text("Destination")
//                                            .font(.caption.bold())
//                                    }
//                                    .padding(5)
//                                    .foregroundStyle(.black)
//                                    .background(.white.opacity(0.7))
//                                    .cornerRadius(10)
//                                    .viewSize { s in size = s.height }
//                                    .offset(y: -size/2 - 10)
//                                }
//                            }
//                            .onTapGesture {
//                                focus = (focus == fPlan.destination.icaoCode!) ? "" : fPlan.destination.icaoCode!
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .onAppear {
//            coords.removeAll()
//
//            // ORIGIN
//            if let lat = Double(fPlan.origin.posLat!),
//               let lon = Double(fPlan.origin.posLong!) {
//                coords.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
//            }
//
//            // FIXES
//            for fix in fPlan.navlog.fix! {
//                if let lat = Double(fix.posLat!), let lon = Double(fix.posLong!) {
//                    coords.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
//                }
//            }
//
//            // DESTINATION
//            if let lat = Double(fPlan.destination.posLat!),
//               let lon = Double(fPlan.destination.posLong!) {
//                coords.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
//            }
//
//            // CAMERA
//            if !coords.isEmpty {
//                let minLat = coords.map { $0.latitude }.min()!
//                let maxLat = coords.map { $0.latitude }.max()!
//                let minLon = coords.map { $0.longitude }.min()!
//                let maxLon = coords.map { $0.longitude }.max()!
//
//                let center = CLLocationCoordinate2D(
//                    latitude: (minLat + maxLat) / 2,
//                    longitude: (minLon + maxLon) / 2
//                )
//                let span = MKCoordinateSpan(
//                    latitudeDelta: (maxLat - minLat) * 1.3,
//                    longitudeDelta: (maxLon - minLon) * 1.3
//                )
//                camera = .region(MKCoordinateRegion(center: center, span: span))
//            }
//        }
//    }
//}
