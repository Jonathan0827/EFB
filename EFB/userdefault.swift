//
//  userdefault.swift
//  EFB
//
//  Created by Jonathan Lim on 11/10/25.
//

import Foundation

func saveUserDefault(_ key: String, _ value: Any?) {
    UserDefaults().setValue(value, forKey: key)
}

func readUserDefault(_ key: String) -> Any? {
    return UserDefaults().object(forKey: key)
}
