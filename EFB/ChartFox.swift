//
//  ChartFox.swift
//  EFB
//
//  Created by Jonathan Lim on 12/18/25.
//

import Foundation
import Alamofire
import SwiftSoup

func getInertiaVersion(completion: @escaping (String) -> Void) {
    AF.request("https://chartfox.org/")
        .response { r in
            if let data = r.data {
                do {
                    let html = String(data: data, encoding: .utf8)!
                    let document = try SwiftSoup.parse(html)
                    let data = try document.select("#app").first()
                    let json = try data!.attr("data-page")
                    let jData = json.data(using: .utf8)!
                    if let jDir = try? JSONSerialization.jsonObject(with: jData, options: []) as? [String: Any] {
                        completion(jDir["version"] as! String)
                    }
                } catch {
                    print(error)
                    completion("")
                }
            }
        }
}

func CFoxHeaders(_ inclpat: Bool = true, completion: @escaping (HTTPHeaders) -> Void) {
    let pat = UserDefaults().string(forKey: "cfoxPAT") ?? ""
    let sid = UserDefaults().string(forKey: "cfoxSID") ?? ""
    let xsrf = UserDefaults().string(forKey: "xsrf") ?? ""
    let rweb = UserDefaults().string(forKey: "rweb") ?? ""
    let rwebd = UserDefaults().string(forKey: "rwebd") ?? ""
    getInertiaVersion() { inertia in
        var headers: HTTPHeaders = [
            "X-Inertia": "true",
            "X-Inertia-Version": inertia,
            "X-XSRF-TOKEN": xsrf.replacing("%3D", with: "")
        ]
        headers["Cookie"] = "\(inclpat ? " chartfox_user_pat=\(pat);chartfoxv2_session=\(sid);XSRF-TOKEN=\(xsrf);" : "")\(rweb)=\(rwebd)"
        completion(headers)
    }
}
func testConnection(completion: @escaping (stat) -> Void) {
    print("TC")
    var toTest = ""
    CFoxHeaders() { h in
        AF.request("https://chartfox.org/RKSI", headers: h)
            .saveLogin()
            .responseDecodable(of: Index.self) { r in
                switch r.result {
                case .success(let data):
                    print(data.component)
                    if data.component == "charts/index" {
                        let charts = data.props.groupedCharts!
                        toTest = charts["0"]![0].id!
                        CFoxHeaders() { h2 in
                            AF.request("https://api.chartfox.org/v2/charts/\(toTest)", headers: h2)
                                .responseDecodable(of: ChartData.self) { r in
                                    switch r.result {
                                    case .success:
                                        print("tc done")
                                        completion(.ok)
                                    case .failure(let e):
                                        print("fail test 2")
                                        print(e)
                                        completion(.fail)
                                    }
                                }
                        }
                    } else if data.component == "auth/loginLanding" {
                        print("login required")
                        completion(.loginreq)
                    }
                case .failure(let err):
                    print("fail test 1")
                    print(err)
                    completion(.fail)
                }
            }
    }
}

func getCharts(_ icao: String, completion: @escaping (ChartList) -> Void) {
    CFoxHeaders() { h in
        AF.request("https://chartfox.org/\(icao)", headers: h)
            .saveLogin()
            .responseDecodable(of: Index.self) { res in
                switch res.result {
                case .success(let value):
                    if value.component != "error" {
                        let gC = value.props.groupedCharts!
                        let cList = ChartList(
                            General: gC["0"] ?? [],
                            Ground: gC["3"] ?? [],
                            SID: gC["4"] ?? [],
                            STAR: gC["5"] ?? [],
                            Approach: gC["6"] ?? []
                        )
                        completion(cList)
                    } else {
                        print("Not Found")
                    }
                case .failure(let err):
                    print(err)
                }
            }
    }
}

func getChart(_ chartId: String, completion: @escaping (ChartData) -> Void) {
    CFoxHeaders() { h in
        AF.request("https://api.chartfox.org/v2/charts/\(chartId)", headers: h)
            .response { r in
                if let data = r.data {
                    print(String(data: data, encoding: .utf8) ?? "No Data")
                }
            }
            .responseDecodable(of: ChartData.self) { r in
                switch r.result {
                case .success(let data):
                    completion(data)
                case .failure(let e):
                    print("fail chtd de")
                    print(e)
                }
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

enum stat {
    case ok
    case loginreq
    case fail
}
