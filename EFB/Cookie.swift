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
            print("saveCFoxLogin")
            switch r.result {
            case .success:
                let setcookie = r.response!.headers.value(for: "Set-Cookie")
                if setcookie == nil {
                    print("No cookie")
                    return
                }
                let cookies = setcookie!.split(separator: ", ")
                var realCookies = [String: String]()
                var a = 0
                for cookie in cookies {
                    if a % 2 == 0 {
                        let realCookie = cookie.split(separator: ";")[0].split(separator: "=")
                        let name = String(realCookie[0])
                        let value = String(realCookie[1])
                        if (realCookies[name] ?? "").isEmpty {
                            realCookies[name] = value
                        }
                    }
                    a += 1
                }
                saveUserDefault("LastCookieUpdate", Date().timeIntervalSince1970)
                if realCookies["chartfox_user_pat"] != nil {
                    print("PAT Avail")
                    saveUserDefault("cfoxPAT", realCookies["chartfox_user_pat"])
                }
                if realCookies["chartfoxv2_session"] != nil {
                    saveUserDefault("cfoxSID", realCookies["chartfoxv2_session"])
                }
                if realCookies["XSRF-TOKEN"] != nil {
                    saveUserDefault("xsrf", realCookies["XSRF-TOKEN"])
                }
                for cookie in realCookies {
                    if cookie.key.hasPrefix("remember_web_") {
                        print("Rweb Avail")
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
    func saveSBLogin() -> Self {
        self.response {r in
            print("saveSBLogin")
            switch r.result {
            case .success:
                let setcookie = r.response!.headers.value(for: "Set-Cookie")
                if setcookie == nil {
                    print("No cookie")
                    return
                }
                let cookies = setcookie!.split(separator: ", ")
                var realCookies = [String: String]()
                var a = 0
                for cookie in cookies {
                    let realCookie = cookie.split(separator: ";")[0]
                    if realCookie.contains("=") {
                        let theRealCookie = realCookie.split(separator: "=")
                        let name = String(theRealCookie[0])
                        let value = String(theRealCookie[1])
                        if (realCookies[name] ?? "").isEmpty {
                            realCookies[name] = value
                        }
                    }
                    a += 1
                }
                saveUserDefault("simbriefSSO", realCookies["simbrief_sso"])
                saveUserDefault("simbriefUID", realCookies["simbrief_user"])
            case .failure(let e):
                print("fail ch")
                print(e)
            }
        }
    }
}
