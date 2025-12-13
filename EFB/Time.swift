//
//  Time.swift
//  EFB
//
//  Created by Jonathan Lim on 11/29/25.
//

import Foundation

func toUTC(_ localTimeString: String) -> String {
    let d = localTimeString.replacing(" ", with: " ")
    
    let ds = d.split(separator: " ")[0]
    var tz = d.split(separator: " ")[1]
    let df = DateFormatter()
    df.dateFormat = "HH:mm"
    var res = ""
    if tz.contains("+") || tz.contains("-") {
        let isPositive = tz.contains("+")
        tz.removeFirst()
        let tzGap = Int(tz)! * 60 * 60 * (isPositive ? 1 : -1)
        res = df.string(from: Date(timeIntervalSince1970: df.date(from: String(ds))!.timeIntervalSince1970 - Double(tzGap)))
    } else {
        let timezone = TimeZone(abbreviation: String(tz))
        if timezone == nil { return "?" }
        let tzGap = timezone!.secondsFromGMT()
        res = df.string(from: Date(timeIntervalSince1970: df.date(from: String(ds))!.timeIntervalSince1970 - Double(tzGap)))
    }
    return res
}
