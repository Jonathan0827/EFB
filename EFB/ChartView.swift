//
//  ChartView.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI
import PDFKit
import Alamofire

struct ChartView: View {
    let chartType = ["GEN", "GND", "SID", "STAR", "APPR"]
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State var selectedType: String = "GEN"
    @State var icao: String = ""
    @State var charts: ChartList? = nil
    @State var showChart: Bool = false
    @State var chartData: Chart? = nil
    @State var showChartList: Bool = false
    @State var loading: Bool = false
    @State var loadingAirport: Bool = false
    @State var airportList: [AirportData] = []
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility,sidebar: {
            VStack {
                HStack {
                    TextField("ICAO", text: $icao)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.characters)
                        .onChange(of: icao) { o, n in
                            if !loading {
                                showChartList = false
                                loadingAirport = true
                                searchICAO(n) { r in
                                    do {
                                        airportList = try r.get().data
                                    } catch {
                                        print("No airport found")
                                        airportList = []
                                    }
                                    loadingAirport = false
                                }
                            }
                        }
                    Button(action: {
                        loading = true
                        getCharts(icao) { r in
                            charts = r
                            loading = false
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .foregroundStyle(.prm)
                }
                if !showChartList {
                    if loadingAirport {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else {
                        List(airportList, id:\.id) { airport in
                            Button("\(airport.icaoCode!): \(airport.name)", action: {
                                showChartList = true
                                loading = true
                                icao = airport.icaoCode!
                                charts = nil
                                getCharts(icao) { r in
                                    charts = r
                                    loading = false
                                }
                            })
                        }
                    }
                }
                if charts != nil && showChartList {
                    Picker("chart", selection: $selectedType) {
                        ForEach(chartType, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    List(selection: $chartData) {
                        switch selectedType {
                        case "GEN":
                            ForEach(charts!.General, id: \.id!) { chart in
                                NavigationLink(chart.name!, value: chart)
                            }
                        case "GND":
                            ForEach(charts!.Ground, id: \.id!) { chart in
                                NavigationLink(chart.name!, value: chart)
                            }
                        case "SID":
                            ForEach(charts!.SID, id: \.id!) { chart in
                                NavigationLink(chart.name!, value: chart)
                            }
                        case "STAR":
                            ForEach(charts!.STAR, id: \.id!) { chart in
                                NavigationLink(chart.name!, value: chart)
                            }
                        case "APPR":
                            ForEach(charts!.Approach, id: \.id!) { chart in
                                NavigationLink(chart.name!, value: chart)
                            }
                        default:
                            Text("WTF?")
                        }
                    }
                    .scrollContentBackground(.hidden)
                     .background(Color.clear)
                    .presentationCornerRadius(20)
                } else if loading && showChartList{
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            .padding()
        }, detail: {
            NavigationStack {
                VStack {
                    if chartData != nil {
                        RealChartView(chart: $chartData, columnVis: $columnVisibility)
                    } else {
                        Text("Choose a chart from the list")
                            .info()
                    }
                }
            }
        })
        .navigationTitle("Chart Viewer")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct RealChartView: View {
    @Binding var chart: Chart?
    //    @Binding var show: Bool
    @State var loading = true
    @State var chartData: ChartData?
    @State var pdfData: Data?
    @State var showInfo: Bool = false
    @Binding var columnVis: NavigationSplitViewVisibility
    var body: some View {
        VStack {
            if loading {
                ProgressView("Loading \(chart!.name ?? "")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .onAppear {
                        columnVis = .detailOnly
                    }
            } else {
                PDFViewRepresentable(data: pdfData!)
            }
        }
        .navigationTitle(chart!.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: {
                showInfo = true
            }, label: {
                Image(systemName: "info.circle")
            })
            .foregroundStyle(.prm)
        }
        .onChange(of: chart!.id!, initial: true) {
            loading = true
            getChart(chart!.id!) { r in
                OperationQueue().addOperation {
                    chartData = r
                    //                    print(r)
                    self.pdfData = try? Data(contentsOf: r.url)
                    loading = false
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            VStack {
                ZStack {
                    Text("Chart Information")
                        .font(.headline.bold())
                    HStack {
                        Spacer()
                        Button("Close", action: {
                            showInfo = false
                        })
                    }
                }
                .padding([.top, .horizontal])
                List {
                    Text("Chart Name: \(chartData!.name)")
                    Text("Chart ID: \(chartData!.id)")
                    Text("Provider: \(chartData!.source!.displayName ?? "Unknown")")
                    Text("Source URL: \(chartData!.sourceURL.absoluteString)")
                    Text("ICAO: \(chartData!.airportICAO)")
                }
                
            }
        }
        
    }
}

func searchICAO(_ icao: String, completion: @escaping (Result<AirportResponse, Error>) -> Void) {
    AF.request("https://api.chartfox.org/v2/airports?query=\(icao)&supported=1", headers: headers())
        .saveLogin()
        .responseDecodable(of: AirportResponse.self) { r in
            switch r.result {
            case .success(let res):
                for i in res.data {
                    print(i.icaoCode ?? "")
                }
                completion(.success(res))
            case .failure(let e):
                print(e)
                completion(.failure(e))
            }
        }
}
