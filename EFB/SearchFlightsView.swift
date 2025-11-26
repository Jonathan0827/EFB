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
    @State var routes: [flDS] = []
    @State var state: Int = 0
    var body: some View {
        VStack {
            HStack {
                TextField("Departure ICAO", text: $depIcao)
                    .textCase(.uppercase)
                Button(action: {
                    searchAirport = 1
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
                TextField("Arrival ICAO", text: $arrIcao)
                    .textCase(.uppercase)
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
//                    print(r)
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
                        ForEach(routes, id:\.flightInfo.debugDescription) { route in
                            HStack {
                                AsyncImage(url: URL(string: route.flightInfo!.airlineLogo!)){ image in
                                    image
                                } placeholder: {
                                    Image(systemName: "airplane.circle")
                                }
                                VStack(alignment: .leading) {
                                    Text("\(route.flightInfo!.flightIdent!): Operated by \(route.flight!.operatorName ?? ""), Aircraft: \(route.flightInfo!.aircraftType ?? "A/C Unknown"), \(route.flightInfo!.origin ?? "N/A") - \(route.flightInfo!.destination ?? "N/A")")
                                        .fontWeight(.bold)
                                    Text("\(route.flightInfo!.flightDepartureTime ?? "?") - \(route.flightInfo!.flightArrivalTime ?? "?") \(route.flightInfo!.flightDepartureDay ?? "?") - \(route.flightInfo!.flightArrivalDay ?? "?")")
                                    Text("\(route.flight!.scheduledBlockOut!.split(separator: " ")[1].prefix(5)) UTC - \(route.flight!.scheduledBlockIn!.split(separator: " ")[1].prefix(5)) UTC")
                                }
                                .padding(.leading, 5)
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
    var body: some View {
        Text("Flight Detail View")
    }
}
