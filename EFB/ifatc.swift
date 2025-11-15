//
//  ifatc.swift
//  EFB
//
//  Created by Jonathan Lim on 11/11/25.
//

import Foundation
import SwiftSoup
import Alamofire

func searchAirportIFATC(_ icao: String, _ prog: Int,completion: @escaping ([ifatcAirport], Int) -> Void) {
    AF.request("https://www.ifatc.org/api/airport_query?term=\(icao)&_type=query&q=\(icao)")
        .responseDecodable(of: ifatcAirportRes.self) { r in
            switch r.result {
            case .success(let value):
                completion(value.results, prog)
            case .failure(let error):
                print(error)
            }
        }
}

func getGateInfo(_ icao: String, completion: @escaping ([gateType]) -> Void) {
    AF.request("https://www.ifatc.org/airports?code=\(icao)")
        .response { response in
            do {
                let data = response.data
                let html = String(data: data!, encoding: .utf8)!
                let document = try SwiftSoup.parse(html)
                let types = try document.select("#content > div.flex.flex-col.drawer-content.min-h-screen > div.flex-grow > div > div > div > div > div:nth-child(5) > div > div > table > tbody > tr > td")
                let index = types.size()
                var list = [String]()
                for type in types {
                    list.append(try type.text())
                }
                var final = [gateType]()
                for i in 0..<index/3 {
                    final.append(
                        gateType(
                            type: list[i*3],
                            count: Int(list[(i+1)*3-2]) ?? 0,
                            aircraft: list[(i+1)*3-1]
                        )
                    )
                }
                completion(final)
            } catch let error {
                print(error)
            }
        }
}

func getAllGates(_ icao: String, completion: @escaping ([gate]) -> Void) {
    AF.request("https://www.ifatc.org/gates?code=\(icao)")
        .response { response in
            do {
                let data = response.data
                let html = String(data: data!, encoding: .utf8)!
                let document = try SwiftSoup.parse(html)
                let types = try document.select("#content > div.flex.flex-col.drawer-content.min-h-screen > div.flex-grow > div > div:nth-child(3) > div > table > tbody > tr > td")
                let index = types.size()
                var list = [String]()
                for type in types {
                    list.append(try type.text())
                }
                var final = [gate]()
                for i in 0..<index/4 {
                    final.append(
                        gate(
                            gateName: list[i*4],
                            type: list[(i+1)*4-3],
                            aircraftType: list[(i+1)*4-2],
                            aircraft: list[(i+1)*4-1].split(separator: ", ").toStringArray()
                        )
                    )
                }
                completion(final)
            } catch let error {
                print(error)
            }
        }
}

struct gateType {
    let type: String
    let count: Int
    let aircraft: String
}
struct gate {
    let gateName: String
    let type: String
    let aircraftType: String
    let aircraft: [String]
}
extension Array<Substring> {
    func toStringArray() -> [String] {
        var result: [String] = []
        for element in self {
            result.append(String(element))
        }
        return result
    }
}
