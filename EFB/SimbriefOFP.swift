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
        .responseDecodable(of: FlightPlan.self) { res in
            switch res.result {
                case .success(let fp):
                completion(fp)
//                print(fp)
            case .failure(let err):
                print(err)
            }
        }
}

func getAircraftData(_ aircraftIcao: String, completion: @escaping (AircraftData) -> Void) {
    AF.request("https://api.simbrief.com/v2/airframes")
        .responseDecodable(of: Array<AircraftData>.self) { r in
            switch r.result {
            case .success(let value):
                let _ = value.map {
                    if $0.aircraftIcao == aircraftIcao {
                        completion($0)
                    }
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
func getTOPerf(_ TOConf: SBTOModel, completion: @escaping (TOPerformanceResponse) -> Void) {
    getJWT { jwt in
        let params: [String: String] = [
            "aircraft": TOConf.ac!.aircraftIcao,
            "airport": TOConf.airport,
            "runway": TOConf.rwy,
            "length_units": TOConf.lUnit,
            "weight_units": TOConf.wUnit,
            "weight": TOConf.weight,
            "flap_setting": TOConf.flap,
            "thrust_setting": TOConf.thrust,
            "enable_bleeds": TOConf.bleed,
            "enable_anti_ice": TOConf.aIce,
            "wind": TOConf.wind,
            "temperature": TOConf.temp,
            "pressure_units": TOConf.pUnit,
            "altimeter": TOConf.pressure,
            "surface_condition": TOConf.sCond,
            "enable_flex": TOConf.flex,
            "enable_climb_optimization": TOConf.cOpt
        ]
        AF.request("https://api.simbrief.com/v2/performance/takeoff", method: .get, parameters: params, headers: ["Authorization": "Bearer \(jwt)"])
            .responseDecodable(of: TOPerformanceResponse.self) { r in
                switch r.result {
                case .success(let value):
                    completion(value)
                case .failure(let err):
                    print(TOConf.ac!.aircraftIcao)
                    print(err)
                }
            }
    }
}
func getLDGPerf(_ LDGConf: SBLDGModel, completion: @escaping (LDGPerformanceResponse) -> Void) {
    getJWT { jwt in
        let params: [String: String] = [
            "aircraft": LDGConf.ac?.aircraftIcao ?? "",
            "airport": LDGConf.airport,
            "runway": LDGConf.rwy,
            "length_units": LDGConf.lUnit,
            "weight_units": LDGConf.wUnit,
            "weight": LDGConf.weight,
            "flap_setting": LDGConf.flap,
            "brake_setting": LDGConf.brake,
            "reverser_credit": LDGConf.reverser,
            "vref_additive": LDGConf.vrefAdd,
            "wind": LDGConf.wind,
            "temperature": LDGConf.temp,
            "pressure_units": LDGConf.pUnit,
            "altimeter": LDGConf.pressure,
            "surface_condition": LDGConf.sCond,
            "calculation_method": LDGConf.calcMethod,
            "margin_method": LDGConf.marginMethod
        ]
        AF.request("https://api.simbrief.com/v2/performance/landing", method: .get, parameters: params, headers: ["Authorization": "Bearer \(jwt)"])
            .responseDecodable(of: LDGPerformanceResponse.self) { r in
                switch r.result {
                case .success(let value):
                    LDGConf.ldgPerf = value
                    completion(value)
                case .failure(let err):
                    print(LDGConf.ac?.aircraftIcao ?? "")
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
