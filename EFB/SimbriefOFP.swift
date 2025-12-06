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
                let r = value.map {
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

func getTOPerf() {
    let headers: HTTPHeaders = [
        "Cookie": "simbrief_user=\(readUserDefault("simbriefUID")!);simbrief_sso=\(readUserDefault("simbriefSSO")!)"
    ]
    var jwt = ""
    AF.request("https://dispatch.simbrief.com/ajax.login.php", headers: headers)
        .saveSBLogin()
    //        .response { res in
    //            if let data = res.data {
    //                print(String(data: data, encoding: .utf8)!)
    //            }
    //        }
        .responseDecodable(of: SBUserData.self) { r in
            switch r.result {
            case .success(let userData):
                print(userData)
                jwt = userData.user.accessToken
                print(jwt)
                let params = [
                    "aircraft": ""
                ]
                AF.request("https://api.simbrief.com/v2/performance/takeoff", method: .get, headers: ["Authorization": "Bearer \(jwt)"])
                    .response { r in
                        if let data = r.data {
                            print(String(data: data, encoding: .utf8)!)
                        }
                    }
            case .failure(let err):
                print(err)
            }
        }
}

struct TOConf {
    let aircraft: String
    let airport: String
    let rwy: String
    let lUnit: String
    let wUnit: String
    let weight: String
    let bleed: String
    let antiIce: String
    let flex: String
}

