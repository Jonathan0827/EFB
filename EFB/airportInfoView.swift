//
//  airportInfoView.swift
//  EFB
//
//  Created by Jonathan Lim on 11/13/25.
//

import SwiftUI

struct AirportInfoView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State var icao: String = ""
    @State var selIcao: String = ""
    @State var prevLoading: Bool = false
    @State var airportList: [ifatcAirport] = []
    @State var loading = false
    @State var selAirport: ifatcAirport?
    @State var prog: Int = 0
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility, sidebar: {
            TextField("ICAO", text: $icao)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.characters)
                .padding()
            if icao.isEmpty {
                Spacer()
                Text("Please enter an ICAO code.")
                Spacer()
            } else {
                if loading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    List(selection: $selAirport) {
                        ForEach(airportList, id: \.id) { airport in
                            NavigationLink(value: airport) {
                                Text("\(airport.id) - \(airport.text)")
                                    .onTapGesture {
                                        prevLoading = true
                                        icao = airport.id
                                        selIcao = airport.id
                                        selAirport = airport
                                    }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
        }, detail: {
            if selAirport != nil {
                RealAirportInfoView(icao: $selIcao, columnVis: $columnVisibility)
                    .onAppear {
                        columnVisibility = .detailOnly
                    }
            } else {
                Text("Select an airport")
            }
        })
        .navigationTitle("IFATC")
        .onChange(of: icao) { o, n in
            if !prevLoading {
                loading = true
                prog += 1
                searchAirportIFATC(icao, prog) { r, p in
                    if p == prog {
                        airportList = r
                        loading = false
                    }
                }
            }
            prevLoading = false
        }
    }
}

struct RealAirportInfoView: View {
    @Binding var icao: String
    @State var airport: AirportDetail?
    @State var gateInfo: [gateType]?
    @State var gates: [gate]?
    @State var loading = 0
    @State var showAllGates = false
    @Binding var columnVis: NavigationSplitViewVisibility
    var body: some View {
        VStack {
            if loading != 3{
                ProgressView()
                    .onAppear {
                        columnVis = .detailOnly
                    }
            } else {
                VStack(alignment: .leading) {
                    Text("\(airport!.icaoCode!)")
                        .font(.title.bold())
                        .padding(.horizontal)
                    Text("\(String(describing: airport!.name))")
                        .font(.headline.bold())
                        .padding(.horizontal)
                    List {
                        Section(header: Text("Gate Information")) {
                            if gateInfo!.count == 0 {
                                Text("N/A")
                            }
                            ForEach(gateInfo!, id: \.type) { g in
                                Text("Class \(g.type): Count: \(g.count), Max Aircraft Size: \(g.aircraft)")
                            }
                        }
                        Section(header: Text("Gates")) {
                            if gates!.isEmpty {
                                Text("N/A")
                            } else {
                                Button("\(showAllGates ? "Hide" : "Show") All Gates", action: {
                                    withAnimation {
                                        showAllGates.toggle()
                                    }
                                })
                                if showAllGates {
                                    ForEach(gates!, id: \.gateName) { g in
                                        Text("\(g.gateName), Class: \(g.aircraftType), Aircrafts: \(g.aircraft)")
                                    }
                                }
                            }
                        }
                        //                    }
                        //                    List {
                        Section(header: Text("Location")) {
                            Text("\(airport!.region.name), \(airport!.country.name)")
                            Text("Longitude: \(airport!.longitudeDeg)")
                            Text("Latitude: \(airport!.latitudeDeg)")
                        }
                        
                        ForEach(airport!.runways, id: \.id) { rwy in
                            Section(header: Text("RWY \(rwy.leIdent), RWY \(rwy.heIdent)")) {
                                Text("\(rwy.lengthFt)ft x \(rwy.widthFt)ft")
                                Text("RWY Heading")
                                    .fontWeight(.bold)
                                Text("\(rwy.leIdent): \(rwy.leHeadingDegT ?? "Unknown")")
                                Text("\(rwy.heIdent): \(rwy.heHeadingDegT ?? "Unknown")")
                                if rwy.heIls != nil || rwy.leIls != nil {
                                    Text("ILS")
                                        .fontWeight(.bold)
                                    if rwy.leIls != nil {
                                        Text("\(rwy.leIdent), Frequency: \(rwy.leIls!.freq.description), Course: \(rwy.leIls!.course)")
                                    }
                                    if rwy.heIls != nil {
                                        Text("\(rwy.heIdent), Frequency: \(rwy.heIls!.freq.description), Course: \(rwy.heIls!.course)")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .listRowSeparator(.visible)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
        }
        .onChange(of: icao, initial: true) { o, n in
            loading = 0
            airportInfo(n) { r in
                print("r rcvd")
                airport = r
                loading += 1
            }
//            airport = AirportDetail(ident: "RKSI", type: "large_airport", name: "Incheon International Airport", latitudeDeg: 37.46910095214844, longitudeDeg: 126.45099639892578, elevationFt: Optional("23"), continent: "AS", isoCountry: "KR", isoRegion: "KR-28", municipality: Optional("Seoul"), scheduledService: Optional("yes"), gpsCode: Optional("RKSI"), iataCode: Optional("ICN"), localCode: Optional(""), homeLink: Optional(""), wikipediaLink: Optional("https://en.wikipedia.org/wiki/Incheon_International_Airport"), keywords: Optional(""), icaoCode: Optional("RKSI"), runways: [EFB.Runway(id: "237289", airportRef: "5653", airportIdent: "RKSI", lengthFt: "12303", widthFt: "197", surface: "ASPH", lighted: "1", closed: "0", leIdent: "15L", leLatitudeDeg: Optional("37.4839"), leLongitudeDeg: Optional("126.44"), leElevationFt: Optional("23"), leHeadingDegT: Optional("145"), leDisplacedThresholdFt: Optional(""), heIdent: "33R", heLatitudeDeg: Optional("37.4564"), heLongitudeDeg: Optional("126.465"), heElevationFt: Optional("23"), heHeadingDegT: Optional("325"), heDisplacedThresholdFt: Optional(""), leIls: Optional(EFB.RunwayILS(freq: 111.9, course: 153)), heIls: Optional(EFB.RunwayILS(freq: 108.9, course: 333))), EFB.Runway(id: "237288", airportRef: "5653", airportIdent: "RKSI", lengthFt: "12303", widthFt: "197", surface: "ASPH", lighted: "1", closed: "0", leIdent: "15R", leLatitudeDeg: Optional("37.4818"), leLongitudeDeg: Optional("126.436"), leElevationFt: Optional("23"), leHeadingDegT: Optional("145"), leDisplacedThresholdFt: Optional(""), heIdent: "33L", heLatitudeDeg: Optional("37.4542"), heLongitudeDeg: Optional("126.461"), heElevationFt: Optional("23"), heHeadingDegT: Optional("325"), heDisplacedThresholdFt: Optional(""), leIls: Optional(EFB.RunwayILS(freq: 109.1, course: 153)), heIls: Optional(EFB.RunwayILS(freq: 109.3, course: 333))), EFB.Runway(id: "313766", airportRef: "5653", airportIdent: "RKSI", lengthFt: "13123", widthFt: "197", surface: "ASPH", lighted: "1", closed: "0", leIdent: "16L", leLatitudeDeg: Optional("37.4728"), leLongitudeDeg: Optional("126.416"), leElevationFt: Optional(""), leHeadingDegT: Optional("153"), leDisplacedThresholdFt: Optional(""), heIdent: "34R", heLatitudeDeg: Optional("37.4434"), heLongitudeDeg: Optional("126.442"), heElevationFt: Optional(""), heHeadingDegT: Optional("333"), heDisplacedThresholdFt: Optional(""), leIls: Optional(EFB.RunwayILS(freq: 110.35, course: 153)), heIls: Optional(EFB.RunwayILS(freq: 108.1, course: 333))), EFB.Runway(id: "346105", airportRef: "5653", airportIdent: "RKSI", lengthFt: "12303", widthFt: "197", surface: "ASPH", lighted: "1", closed: "0", leIdent: "16R", leLatitudeDeg: Optional("37.4688"), leLongitudeDeg: Optional("126.413"), leElevationFt: Optional("23"), leHeadingDegT: Optional(""), leDisplacedThresholdFt: Optional(""), heIdent: "34L", heLatitudeDeg: Optional("37.4412"), heLongitudeDeg: Optional("126.438"), heElevationFt: Optional("23"), heHeadingDegT: Optional(""), heDisplacedThresholdFt: Optional(""), leIls: Optional(EFB.RunwayILS(freq: 108.55, course: 153)), heIls: Optional(EFB.RunwayILS(freq: 109.95, course: 333)))], freqs: [EFB.Frequency(id: "54878", airportRef: "5653", airportIdent: "RKSI", type: "APP", description: "SEOUL APP", frequencyMHz: "120.8"), EFB.Frequency(id: "54879", airportRef: "5653", airportIdent: "RKSI", type: "ATIS", description: "ATIS", frequencyMHz: "23.025"), EFB.Frequency(id: "54880", airportRef: "5653", airportIdent: "RKSI", type: "CLD", description: "CLNC DEL", frequencyMHz: "121"), EFB.Frequency(id: "54881", airportRef: "5653", airportIdent: "RKSI", type: "DEP", description: "SEOUL DEP", frequencyMHz: "121.35"), EFB.Frequency(id: "54882", airportRef: "5653", airportIdent: "RKSI", type: "GND", description: "GND", frequencyMHz: "121.4"), EFB.Frequency(id: "54883", airportRef: "5653", airportIdent: "RKSI", type: "RMP", description: "RAMP CON", frequencyMHz: "121.65"), EFB.Frequency(id: "54884", airportRef: "5653", airportIdent: "RKSI", type: "TWR", description: "TWR", frequencyMHz: "118.2")], country: EFB.Country(id: "302643", code: "KR", name: "South Korea", continent: "AS", wikipediaLink: Optional("https://en.wikipedia.org/wiki/South_Korea"), keywords: Optional("한국의 공항")), region: EFB.Region(id: "304403", code: "KR-28", localCode: Optional("28"), name: "Incheon Gwang\'yeogsi", continent: "AS", isoCountry: "KR", wikipediaLink: Optional("https://en.wikipedia.org/wiki/Incheon_Gwang\'yeogsi"), keywords: Optional("")), navaids: [EFB.Navaid(id: "91487", filename: Optional("Incheon_VOR-DME_KR"), ident: "NCN", name: "Incheon", type: "VOR-DME", frequencyKHz: Optional("113800"), latitudeDeg: Optional("37.49489974975586"), longitudeDeg: Optional("126.43000030517578"), elevationFt: Optional("23"), isoCountry: Optional("KR"), dmeFrequencyKHz: Optional("113800"), dmeChannel: Optional("085X"), dmeLatitudeDeg: Optional(""), dmeLongitudeDeg: Optional(""), dmeElevationFt: Optional(""), slavedVariationDeg: Optional("-8.011"), magneticVariationDeg: Optional("-7.433"), usageType: Optional("BOTH"), power: Optional("LOW"), associatedAirport: Optional("RKSI"))], updatedAt: nil, station: Optional(EFB.Station(icaoCode: "RKSI", distance: 0.0)))
//            loading += 1
            getGateInfo(icao) { g in
                print("g rcvd")
                gateInfo = g
                print(g)
                loading += 1
            }
            getAllGates(icao) { g in
                print("all g rcvd")
                gates = g
                loading += 1
            }
        }
    }
}
