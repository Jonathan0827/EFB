//
//  SearchFlightsView.swift
//  EFB
//
//  Created by Jonathan Lim on 11/26/25.
//

import SwiftUI

struct SearchFlightsView: View {
    @State var depIcao: String = ""
    @State var arrIcao: String = ""
    //    @State var opIcao: String = ""
    @State var searchAirport: Int = 0
    @State var routes: [[flDS]] = []
    @State var state: Int = 0
    var body: some View {
        VStack {
            HStack {
                TextField("Departure ICAO", text: $depIcao)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.characters)
                Button(action: {
                    searchAirport = 1
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
                TextField("Arrival ICAO", text: $arrIcao)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.characters)
                Button(action: {
                    searchAirport = 2
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
            }
            .padding(.horizontal)
            Button("Search", action: {
                state = 1
                getFlightsAlt(depIcao, arrIcao) { r in
                    routes = r
                    state = 2
                }
            })
            .disabled(depIcao.isEmpty || arrIcao.isEmpty)
            if state == 1 {
                Spacer()
                ProgressView()
                Spacer()
            } else if state == 2 {
                if routes.isEmpty {
                    Spacer()
                    Text("No real world flights found")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(routes, id:\.description) { r in
                            Section {
                                ForEach(r, id:\.flightInfo?.destination) { route in
                                    NavigationLink(destination: FlightDetailView(flight: r)) {
                                        HStack {
                                            AsyncImage(url: URL(string: route.flightInfo!.airlineLogo ?? "")){ image in
                                                image
                                                    .frame(width: 30, height: 30)
                                            } placeholder: {
                                                Image(systemName: "airplane.circle")
                                                    .frame(width: 30, height: 30)
                                            }
                                            .padding(.trailing, 5)
                                            VStack(alignment: .leading) {
                                                Text("\(route.flightInfo!.flightIdent!): Operated by \((route.flight!.operatorName ?? "").replacing("&quot&", with: "").replacing("&quot;", with: "")), Aircraft: \(route.flightInfo!.aircraftType ?? "A/C Unknown"), \(route.flightInfo!.origin ?? "N/A") - \(route.flightInfo!.destination ?? "N/A")")
                                                    .fontWeight(.bold)
                                                Text("\(route.flightInfo!.flightDepartureTime ?? "?") - \(route.flightInfo!.flightArrivalTime ?? "?") \(route.flightInfo!.flightDepartureDay ?? "?") - \(route.flightInfo!.flightArrivalDay ?? "?")")
                                                Text("\(toUTC(route.flightInfo!.flightDepartureTime!)) UTC- \(toUTC(route.flightInfo!.flightArrivalTime!)) UTC")
                                            }
                                            Spacer()
                                            Text("\((route.flight!.status ?? "").replacing("En_Route", with: "Enroute"))")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Spacer()
                Text("Search real world flights")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .navigationTitle("Search Flights")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: .constant(searchAirport != 0)) {
            SearchAirportView(icao: searchAirport == 1 ? $depIcao : $arrIcao, sA: $searchAirport)
                .onDisappear {
                    searchAirport = 0
                }
        }
    }
}

struct SearchAirportView: View {
    @Binding var icao: String
    @Binding var sA: Int
    @State var searchQuery: String = ""
    @State var prog: Int = 0
    @State var airportList: [ifatcAirport] = []
    @State var loading: Bool = false
    var body: some View {
        VStack {
            TextField("Search Airport (ex: Incheon, ICN, RKSI)", text: $searchQuery)
            if loading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                List {
                    ForEach(airportList, id: \.id) { airport in
                        Button("\(airport.id): \(airport.text)", action: {
                            icao = airport.id
                            sA = 0
                        })
                    }
                }
            }
        }
        .padding()
        .onChange(of: searchQuery) { _, nV in
            withAnimation {
                prog += 1
                loading = true
            }
            searchAirportIFATC(nV, prog) { r, p in
                if p == prog {
                    loading = false
                    airportList = r
                }
            }
        }
    }
}

struct FlightDetailView: View {
    let flight: [flDS]
//    let flightInfo: [FlightInfo]
    @State var shownData: Int = 0
    @State var shownList: Int = 0
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(flight, id: \.flight.debugDescription) { fl in
                HStack {
                    Text("\(fl.flightInfo!.flightIdent!.replacing("&quot&", with: "").replacing("&quot;", with: "")) Operated by \((fl.flight!.operatorName ?? "Unknown").replacing("&quot&", with: ""))")
                        .font(.largeTitle.bold())
                    if flight.count > 1 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                let index = flight.firstIndex(where: {return $0 == fl})!
                                if shownData == index {
                                    shownData = -1
                                } else {
                                    shownData = index
                                }
                            }
                        }, label: {
                            Image(systemName: "chevron.right")
                                .rotationEffect(.degrees(shownData == flight.firstIndex(of: fl)! ? 90 : 0))
                        })
                    }
                    Spacer()
                }
                if shownData == flight.firstIndex(where: {return $0 == fl})! {
                    List {
                        if shownList == flight.firstIndex(where: {return $0 == fl})! {
                            Section("Operator Information") {
                                Text("Name: \(fl.flight!.operatorName ?? "Unknown")")
                                Text("ICAO: \(fl.flight!.prefix ?? "Unknown")")
                                Text("Alliance: \(fl.flight!.alliance ?? "No Alliance")")
                            }
                            Section("Aircraft Information") {
                                Text("Name: \(fl.flight!.aircraftType ?? "Unknown")")
                                Text("ICAO: \(fl.flightInfo!.aircraftType ?? "Unknown")")
                            }
                            Section("Flight Information") {
                                Text("Status: \(fl.flightInfo!.flightStatus ?? "Unknown")")
                                Text("Duration: \(fl.flight!.filedETE ?? "Unknown")")
                                Text("IATA: \(fl.flightInfo!.origin ?? "N/A") - \(fl.flightInfo!.destination ?? "N/A")")
                                Text("Departure Gate: \(fl.flight!.gateOrigin ?? "Unknown")")
                                Text("Arrival Gate: \(fl.flight!.gateDestination ?? "Unknown")")
                                Text("Departure Terminal: \(fl.flight!.terminalOrigin ?? "Unknown")")
                                Text("Arrival Terminal: \(fl.flight!.terminalDestination ?? "Unknown")")
                                if !((fl.flightInfo!.flightArrivalTime ?? "").isEmpty) {
                                    Text("Departure Time (Zulu Time): \(toUTC(fl.flightInfo!.flightDepartureTime!)) UTC")
                                    Text("Arrival Time (Zulu Time): \(toUTC(fl.flightInfo!.flightArrivalTime!)) UTC")
                                    Text("Local Departure Time: \(fl.flightInfo!.flightDepartureTime!)")
                                    Text("Local Arrival Time: \(fl.flightInfo!.flightArrivalTime!)")
                                }
//                                Text("\(fl)")
                            }
                            
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            Spacer()
        }
        .padding()
        .onChange(of: shownData) { _, N in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                withAnimation {
                    shownList = N
                }
            })
        }
    }
}
