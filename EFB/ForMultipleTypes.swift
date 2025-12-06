//
//  ForMultipleTypes.swift
//  EFB
//
//  Created by Jonathan Lim on 12/6/25.
//

import Foundation

enum notamEmpty: Codable {
    
    case notam([SBNotamEntry]), empty([String: String])
    
    init(from decoder: Decoder) throws {
        if let notam = try? decoder.singleValueContainer().decode(Array<SBNotamEntry>.self) {
//            print("notam")
            self = .notam(notam)
            return
        }
        
        if let empty = try? decoder.singleValueContainer().decode(Dictionary<String, String>.self) {
            self = .notam([])
            return
        }
//        print("ntm e")
        self = .notam([])
    }
}

enum stringOrDict: Codable {
    
    case string(String), dict([String: String])
    
    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let dict = try? decoder.singleValueContainer().decode(Dictionary<String, String>.self) {
            self = .dict(dict)
            return
        }
//        print("std e")
        self = .dict([:])
    }
}

enum intOrBool: Codable {
    
    case int(Int), bool(Bool)
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        
        if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(bool)
            return
        }
//        print("inb e")
        self = .bool(false)
    }
}

enum stringOrBool: Codable {
    
    case string(String), bool(Bool)
    
    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(bool)
            return
        }
//        print("stb e")
        self = .bool(false)
    }
}

enum stringMeantToBeInt: Codable {
    case string(String), int(Int)
    init(from decoder: any Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .int(Int(string) ?? 0)
            return
        }
        
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
//        print("stmi e")
        self = .int(0)
    }
}
