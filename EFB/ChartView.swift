//
//  ChartView.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI
import PDFKit

struct ChartView: View {
    let chartType = ["GEN", "GND", "SID", "STAR", "APPR"]
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State var selectedType: String = "GEN"
    @State var icao: String = "KJFK"
    @State var charts: ChartList? = nil
    @State var showChart: Bool = false
    @State var chartData: Chart? = nil
    @State var loading: Bool = false
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility,sidebar: {
            VStack {
                HStack {
                    TextField("icao", text: $icao)
                        .textCase(.uppercase)
                    Button(action: {
                        loading = true
                        getCharts(icao) { r in
                            charts = r
                            loading = false
                        }
                    }) {
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
                    .foregroundStyle(.prm)
                }
                if charts != nil {
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
                } else if loading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    Spacer()
                }
            }
            .padding()
        }, detail: {
            NavigationStack {
                VStack {
                    if let chartData {
                        RealChartView(chart: $chartData, columnVis: $columnVisibility)
                            
                    } else {
                        Text("Choose an item from the content")
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
                DispatchQueue.main.async {
                    chartData = r
                    //                    print(r)
                    DispatchQueue.main.async {
                        self.pdfData = try? Data(contentsOf: r.url)
                        loading = false
                    }
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
