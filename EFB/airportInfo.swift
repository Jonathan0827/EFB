//
//  airportInfo.swift
//  EFB
//
//  Created by Jonathan Lim on 11/14/25.
//

import Foundation
import Alamofire

func airportInfo(_ icao: String, completion: @escaping (AirportDetail) -> Void) {
    let apiKey = readUserDefault("ADBAPI")
    if apiKey == nil {
        
    } else {
        AF.request("https://airportdb.io/api/v1/airport/\(icao)?apiToken=\(apiKey!)")
            .response { r in
                if let data = r.data {
                    print(String(data: data, encoding: .utf8) ?? "no data")
                }
            }
            .responseDecodable(of: AirportDetail.self) { res in
                switch res.result {
                case .success(let value):
                    completion(value)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
