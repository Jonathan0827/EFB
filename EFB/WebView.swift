//
//  WebView.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI
import WebKit
internal import Combine

struct WebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }
}

struct DWebView: UIViewRepresentable {
    let url: URL
    let cookie: [String: String]
    @Binding var cUrl: URL
    @Binding var newcookie: [String: String]
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        print("a")
        
        for (name, value) in cookie {
            if let cookie = HTTPCookie(properties: [
                .domain: url.host ?? "",
                .path: "/",
                .name: name,
                .value: value,
                .secure: true,
            ]) {
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
                print("setCookie \(name)")
            }
        }
        webView.navigationDelegate = context.coordinator
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != cUrl {
            uiView.load(URLRequest(url: cUrl))
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: DWebView
        
        init(_ parent: DWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                for cookie in cookies {
//                    print(cookie)
                    if !(self.parent.newcookie[cookie.name] ?? "").isEmpty && cookie.value.isEmpty {
                        print("Skip")
                    } else {
                        self.parent.newcookie[cookie.name] = cookie.value
                    }
                }
            }
            parent.cUrl = webView.url!
            
        }
    }
}
func clearAllCookies() {
    // 1. Clear cookies from the shared HTTP cookie store
    let dataStore = WKWebsiteDataStore.default()
    let cookieStore = dataStore.httpCookieStore

    cookieStore.getAllCookies { cookies in
        for cookie in cookies {
            cookieStore.delete(cookie)
        }
    }
    
    // 2. Clear cached website data (local storage, caches, etc.)
    let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
    let dateFrom = Date(timeIntervalSince1970: 0)
    
    dataStore.removeData(ofTypes: dataTypes, modifiedSince: dateFrom) {
        print("✅ All WKWebView cookies and website data cleared.")
    }
}
func clearChartFox() {
    let dataStore = WKWebsiteDataStore.default()
    dataStore.httpCookieStore.getAllCookies { cookies in
        for cookie in cookies {
            if cookie.domain.contains("chartfox.org") {
                dataStore.httpCookieStore.delete(cookie)
            }
        }
    }
    let types = WKWebsiteDataStore.allWebsiteDataTypes()
    let dateFrom = Date(timeIntervalSince1970: 0)
    
    dataStore.fetchDataRecords(ofTypes: types) { records in
        let targetRecords = records.filter { $0.displayName.contains("chartfox.org") }
        dataStore.removeData(ofTypes: types, for: targetRecords) {
            print("ChartFox.org data cleared.")
        }
    }
}
