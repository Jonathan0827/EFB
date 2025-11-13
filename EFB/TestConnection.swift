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
    AF.request("https://chartfox.org/RKSI", headers: headers())
        .saveLogin()
        .responseDecodable(of: Index.self) { r in
            switch r.result {
            case .success(let data):
                print(data.component)
                if data.component == "charts/index" {
                    let charts = data.props.groupedCharts!
                    toTest = charts["0"]![0].id!
                    AF.request("https://api.chartfox.org/v2/charts/\(toTest)", headers: headers())
                        .responseDecodable(of: ChartData.self) {r in
                            switch r.result {
                            case .success(let data):
                                print("ok tc")
                                completion(.ok)
                            case .failure(let e):
                                print("fail chtd de")
                                print(e)
                                completion(.fail)
                            }
                        }
                } else if data.component == "auth/loginLanding" {
                    print("login req")
                    completion(.loginreq)
                }
            case .failure(let err):
                print("fail ch de")
                print(err)
                completion(.fail)
            }
        }
}
