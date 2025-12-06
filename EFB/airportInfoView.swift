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
            TextField("Search an airport", text: $icao)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.characters)
                .padding()
            if icao.isEmpty {
                Spacer()
                Text("Select an airport")
                    .info()
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
                Text("Select an airport from the list")
                    .info()
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
            getGateInfo(icao) { g in
                print("g rcvd")
                gateInfo = g
                loading += 1
            }
            getAllGates(icao) { g in
                gates = g
                loading += 1
            }
        }
    }
}
