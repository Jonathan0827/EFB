//
//  LC.swift
//  EFB
//
//  Created by Jonathan Lim on 11/11/25.
//

import Foundation
import LocalConsole

let consoleManager = LCManager.shared

func print(_ msg: Any) {
    Swift.print(msg)
    consoleManager.print(msg)
}
