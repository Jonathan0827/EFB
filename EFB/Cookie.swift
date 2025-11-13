//
//  Cookie.swift
//  EFB
//
//  Created by Jonathan Lim on 11/11/25.
//

import Foundation
import Alamofire

extension DataRequest {
    func saveLogin() -> Self {
        self.response {r in
            print("saveLogin")
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
                saveUserDefault("LastCookieUpdate", Date().timeIntervalSince1970)
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
    }
}
