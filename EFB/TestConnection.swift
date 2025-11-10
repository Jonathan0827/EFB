//
//  TestConnection.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import Foundation
import Alamofire

enum stat {
    case ok
    case loginreq
    case fail
}
func testConnection(completion: @escaping (stat) -> Void) {
    print("TC")
    var toTest = ""
    AF.request("https://chartfox.org/RKSI", headers: headers(false))
        .response {r in
            switch r.result {
            case .success:
                let cookies = r.response!.headers.value(for: "Set-Cookie")!.split(separator: ", ")
                var realCookies = [String: String]()
                var a = 0
                for cookie in cookies {
                    if a % 2 == 0 {
                        let realCookie = cookie.split(separator: ";")[0].split(separator: "=")
                        let name = String(realCookie[0])
                        let value = String(realCookie[1])
                        realCookies[name] = value
                    }
                    a += 1
                }
                saveUserDefault("cfoxPAT", realCookies["chartfox_user_pat"])
                saveUserDefault("cfoxSID", realCookies["chartfoxv2_session"])
                saveUserDefault("xsrf", realCookies["XSRF-TOKEN"])
                for cookie in realCookies {
                    if cookie.key.hasPrefix("remember_web_") {
                        saveUserDefault("rweb", cookie.key)
                        saveUserDefault("rwebd", cookie.value)
                    }
                }
            case .failure(let e):
                print("fail ch")
                print(e)
            }
        }
        .responseDecodable(of: Index.self) { r in
            switch r.result {
            case .success(let data):
                if data.component == "charts/index" {
                    let charts = data.props.groupedCharts!
                    toTest = charts["0"]![0].id!
                    AF.request("https://api.chartfox.org/v2/charts/\(toTest)", headers: headers())
                        .responseDecodable(of: ChartData.self) {r in
                            switch r.result {
                            case .success(let data):
                                completion(.ok)
                            case .failure(let e):
                                print("fail chtd de")
                                print(e)
                                completion(.fail)
                            }
                        }
                } else if data.component == "auth/loginLanding" {
                    completion(.loginreq)
                }
            case .failure(let err):
                print("fail ch de")
                print(err)
                completion(.fail)
            }
        }
}
