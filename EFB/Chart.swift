//
//  Chart.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import Foundation
import Alamofire

func headers(_ inclpat: Bool = true) -> HTTPHeaders {
    let pat = UserDefaults().string(forKey: "cfoxPAT") ?? ""
    let sid = UserDefaults().string(forKey: "cfoxSID") ?? ""
    let xsrf = UserDefaults().string(forKey: "xsrf") ?? ""
    let rweb = UserDefaults().string(forKey: "rweb") ?? ""
    let rwebd = UserDefaults().string(forKey: "rwebd") ?? ""
    var headers: HTTPHeaders = [
        "X-Inertia": "true",
        "X-Inertia-Version": "35784934205c3489a38a57e0b48631c6",
        "X-XSRF-TOKEN": xsrf.replacing("%3D", with: "")
    ]
    headers["Cookie"] = "\(inclpat ? " chartfox_user_pat=\(pat);chartfoxv2_session=\(sid);XSRF-TOKEN=\(xsrf);" : "")\(rweb)=\(rwebd)"
    return headers
}

func getCharts(_ icao: String, completion: @escaping (ChartList) -> Void) {
    AF.request("https://chartfox.org/\(icao)", headers: headers())
        .saveLogin()
        .responseDecodable(of: Index.self) { res in
            switch res.result {
                case .success(let value):
                if value.component != "error" {
                    let gC = value.props.groupedCharts!
                    let cList = ChartList(General: gC["0"] ?? [], Ground: gC["3"] ?? [], SID: gC["4"] ?? [], STAR: gC["5"] ?? [], Approach: gC["6"] ?? [])
                    completion(cList)
                } else {
                    print("Not Found")
                }
            case .failure(let err):
                print(err)
            }
        }
}

func getChart(_ chartId: String, completion: @escaping (ChartData) -> Void) {
    AF.request("https://api.chartfox.org/v2/charts/\(chartId)", headers: headers())
        .response { r in
            if let data = r.data {
                print(String(data: data, encoding: .utf8) ?? "No Data")
            }
        }
        .responseDecodable(of: ChartData.self) {r in
            switch r.result {
            case .success(let data):
                completion(data)
            case .failure(let e):
                print("fail chtd de")
                print(e)
            }
        }
}

struct ChartList {
    let General: [Chart]
    let Ground: [Chart]
    let SID: [Chart]
    let STAR: [Chart]
    let Approach: [Chart]
}
