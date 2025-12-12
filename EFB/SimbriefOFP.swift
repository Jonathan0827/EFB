//
//  SimbriefOFP.swift
//  EFB
//
//  Created by Jonathan Lim on 11/29/25.
//

import Foundation
import Alamofire

func getSBOFP(completion: @escaping (FlightPlan) -> Void) {
    AF.request("https://www.simbrief.com/api/xml.fetcher.php?userid=\(readUserDefault("simbriefUID") ?? "")&json=1")
//        .response { res in
//            if let data = res.data {
//                print(String(data: data, encoding: .utf8) ?? "No Data")
//            }
//        }
        .responseDecodable(of: FlightPlan.self) { res in
            switch res.result {
                case .success(let fp):
                completion(fp)
//                print(fp)
            case .failure(let err):
                print(err)
            }
        }
//        .responseDecodable(of: SimBriefResponse.self) { res in
//            switch res.result {
//                case .success(let fp):
////                completion(fp)
//                print(fp)
//            case .failure(let err):
//                print(err)
//            }
//        }
}

func getAircraftData(_ aircraftIcao: String, completion: @escaping (AircraftData) -> Void) {
    AF.request("https://api.simbrief.com/v2/airframes")
        .responseDecodable(of: Array<AircraftData>.self) { r in
            switch r.result {
            case .success(let value):
                let _ = value.map {
                    if $0.aircraftIcao == aircraftIcao {
                        completion($0)
//                        return true
                    }
//                    return false
                }
            case .failure(let err):
                print(err)
            }
        }
}
func getAircraftsList(completion: @escaping (Array<AircraftData>) -> Void) {
    AF.request("https://api.simbrief.com/v2/airframes")
        .responseDecodable(of: Array<AircraftData>.self) { r in
            switch r.result {
            case .success(let value):
                completion(value)
            case .failure(let err):
                print(err)
            }
        }
}
func getJWT(completion: @escaping (String) -> Void) {
    let headers: HTTPHeaders = [
        "Cookie": "simbrief_user=\(readUserDefault("simbriefUID")!);simbrief_sso=\(readUserDefault("simbriefSSO")!)"
    ]
    AF.request("https://dispatch.simbrief.com/ajax.login.php", headers: headers)
        .saveSBLogin()
        .responseDecodable(of: SBUserData.self) { r in
            switch r.result {
            case .success(let userData):
                let tkn = userData.user.accessToken
//                print(tkn)
                completion(tkn)
            case .failure(let error):
                print(error)
                completion("")
            }
        }
}
func getTOPerf(ac: String, airport: String, rwy: String, lUnit: String? = nil, wUnit: String? = nil, weight: String, flap: String? = nil, thrust: String? = nil, bleed: String? = nil, aIce: String? = nil, wind: String? = nil, temp: String? = nil, pUnit: String? = nil, pressure: String? = nil, sCond: String? = nil, flex: String? = nil, cOpt: String? = nil, completion: @escaping (TOPerformanceResponse) -> Void) {
    
    
    //        .response { res in
    //            if let data = res.data {
    //                print(String(data: data, encoding: .utf8)!)
    //            }
    //        }
    getJWT { jwt in
        let params: [String: String] = [
            "aircraft": ac,
            "airport": airport,
            "runway": rwy,
            "length_units": lUnit ?? "",
            "weight_units": wUnit ?? "",
            "weight": weight,
            "flap_setting": flap ?? "",
            "thrust_setting": thrust ?? "",
            "enable_bleeds": bleed ?? "",
            "enable_anti_ice": aIce ?? "",
            "wind": wind ?? "",
            "temperature": temp ?? "",
            "pressure_units": pUnit ?? "",
            "altimeter": pressure ?? "",
            "surface_condition": sCond ?? "",
            "enable_flex": flex ?? "",
            "enable_climb_optimization": cOpt ?? "",
            
        ]
        AF.request("https://api.simbrief.com/v2/performance/takeoff", method: .get, parameters: params, headers: ["Authorization": "Bearer \(jwt)"])
        //                        .response { r in
        //                            if let data = r.data {
        //                                print(String(data: data, encoding: .utf8)!)
        //                            }
        //                        }
            .responseDecodable(of: TOPerformanceResponse.self) { r in
                switch r.result {
                case .success(let value):
                    completion(value)
                case .failure(let err):
                    print(err)
                }
            }
    }
}

func getSBAirport(_ icao: String, completion: @escaping (SBAirportData) -> Void) {
    getJWT() { jwt in
        AF.request(
            "https://api.simbrief.com/v2/airports/\(icao)",
            method: .get,
            headers: [
                "Authorization": "Bearer \(jwt)"
            ]
        )
        .responseDecodable(of: SBAirportData.self) { r in
            switch r.result {
            case .success(let data):
                completion(data)
            case .failure(let e):
                print(e)
            }
        }
    }
}
