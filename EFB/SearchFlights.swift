//
//  SearchFlights.swift
//  EFB
//
//  Created by Jonathan Lim on 11/25/25.
//

import Alamofire
import Foundation
import SwiftSoup
let langhead: HTTPHeaders = [
    "Accept-Language": "en"
]
func getFlights(_ depIcao: String?, _ arrIcao: String?, completion: @escaping (AirlabsResponse) -> Void) {
    let apiKey = readUserDefault("ALAPI") ?? ""
    AF.request("https://airlabs.co/api/v9/routes?api_key=\(apiKey)\(depIcao != nil ? "&dep_icao=\(depIcao!)" : "")\(arrIcao != nil ? "&arr_icao=\(arrIcao!)" : "")")
        .response { r in
            if let data = r.data {
                print(String(data: data, encoding: .utf8) ?? "No data")
            }
        }
        .responseDecodable(of: AirlabsResponse.self) { r in
            switch r.result {
                case .success(let value):
                print(value)
                completion(value)
            case .failure(let error):
                print(error)
                completion(AirlabsResponse(response: []))
            }
        }
}

func getFlightsAlt(_ depIcao: String, _ arrIcao: String, completion: @escaping ([flDS]) -> Void) {
    AF.request("https://www.flightaware.com/live/findflight?origin=\(depIcao)&destination=\(arrIcao)", headers: langhead)
        .response { r in
            print("r")
            do {
                let data = r.data
                let html = String(data: data!, encoding: .utf8)!
//                print(html)
                let document = try SwiftSoup.parse(html)
                let flights = try document.select("script")
                var list = [String]()
                for type in flights {
                    let text = try type.html()
                    if text.hasPrefix("(function(FA)") {
                        list.append(text)
                    }
                }
                for i in list[0].split(separator: "\n") {
                    if i.contains("FA.findflight.flights") {
                        let fl = i.replacing("FA.findflight.flights = ", with: "").replacing("];", with: "]")
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601

                        do {
                            let flight = try decoder.decode([[Flight]].self, from: String(fl).data(using: .utf8)!)
                            let flatFlights = flight.flatMap { $0 }
                            for j in list[1].split(separator: "\n") {
                                if j.contains("FA.findflight.resultsContent") {
                                    let fl = j.replacing("FA.findflight.resultsContent = ", with: "").replacing("];", with: "]")
                                    let decoder = JSONDecoder()
                                    decoder.dateDecodingStrategy = .iso8601
                                        let flights = try decoder.decode([FlightInfo].self, from: String(fl).data(using: .utf8)!)
                                        var finals : [FlightInfo] = []
                                        for flight in flights {
                                            let f = try SwiftSoup.parse(flight.flightIdent!)
                                            let fnbr = try f.select("a").first()!.text()
                                            var cache = flight
                                            cache.flightIdent = fnbr
                                            cache.flightDepartureTime = try SwiftSoup.parse(flight.flightDepartureTime!).text()
                                            cache.flightArrivalTime = try SwiftSoup.parse(flight.flightArrivalTime!).text()
                                            cache.flightDepartureDay = try SwiftSoup.parse(flight.flightDepartureDay!).text()
                                            cache.flightArrivalDay = try SwiftSoup.parse(flight.flightArrivalDay!).text()
                                            finals.append(cache)
                                        }
                                    var tr = [flDS]()
                                        var a = 0
                                        for fl in flatFlights {
                                            tr.append(flDS(flight: fl, flightInfo: finals[a]))
                                            a += 1
                                        }
                                        completion(tr)
                                }
                            }
                        } catch {
                            print("Failed to decode flights:", error)
                        }

                    }
                    
                }
            } catch let error {
                print(error)
            }
        }
}

struct flDS {
    let flight: Flight?
    let flightInfo: FlightInfo?
}
