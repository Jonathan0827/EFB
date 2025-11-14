//
//  ResData.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import Foundation

nonisolated
struct AirportResponse: Codable {
    let data: [AirportData]
    let links: [PageLink]
    let meta: PageMeta
}

struct AirportData: Codable {
    let id: Int
    let ident: String
    let icaoCode: String?
    let iataCode: String?
    let name: String
    let type: String
    let latitude: Double
    let longitude: Double
    let elevationFt: Int?
    let isoA2Country: String
    let hasCharts: Bool
    let hasSources: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case ident
        case icaoCode = "icao_code"
        case iataCode = "iata_code"
        case name
        case type
        case latitude
        case longitude
        case elevationFt = "elevation_ft"
        case isoA2Country = "iso_a2_country"
        case hasCharts = "has_charts"
        case hasSources = "has_sources"
    }
}

struct PageLink: Codable {
    let url: String?
    let label: String
    let active: Bool
}

struct PageMeta: Codable {
    let currentPage: Int
    let firstPageURL: String
    let from: Int
    let lastPage: Int
    let lastPageURL: String
    let nextPageURL: String?
    let path: String
    let perPage: Int
    let prevPageURL: String?
    let to: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to
        case total
    }
}


nonisolated
struct ChartData: Codable {
    let id: String
    let parentID: String?
    let airportICAO: String
    let name: String
    let code: String?
    let type: Int
    let typeKey: String
    let url: URL
    let viewURL: URL
    let sourceURL: URL
    let sourceURLType: Int?
    let sourceUUID: String??
    let meta: [Meta]?
    let source: Source?
    let georefs: [[String: Double]]?
    let requiresPreauth: Bool?
    let allowsIframe: Bool?
    let hasGeoreferences: Bool?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parent_id"
        case airportICAO = "airport_icao"
        case name
        case code
        case type
        case typeKey = "type_key"
        case url
        case viewURL = "view_url"
        case sourceURL = "source_url"
        case sourceURLType = "source_url_type"
        case sourceUUID = "source_uuid"
        case meta
        case source
        case georefs
        case requiresPreauth = "requires_preauth"
        case allowsIframe = "allows_iframe"
        case hasGeoreferences = "has_georeferences"
        case updatedAt = "updated_at"
    }
}

struct Source: Codable {
    let name: String?
    let displayName: String?
    let isoA2Countries: [String]?
    let copyrightStatementShort: String?
    let copyrightStatementLong: String?
    let lastFullUpdate: String?

    enum CodingKeys: String, CodingKey {
        case name
        case displayName = "display_name"
        case isoA2Countries = "iso_a2_countries"
        case copyrightStatementShort = "copyright_statement_short"
        case copyrightStatementLong = "copyright_statement_long"
        case lastFullUpdate = "last_full_update"
    }
}

nonisolated
struct Index: Codable {
    let component: String
    let props: Props
    let url: String
    let version: String
    let clearHistory: Bool
    let encryptHistory: Bool
}

struct Props: Codable {
    let errors: [String: String]?
    let analyticsEvent: String?
    let flash: Flash?
    let settings: Settings?
    let config: Config?
    let auth: Auth?
    let airport: Airport?
    let metar: String?
    let groupedCharts: [String: [Chart]]?
    let serviceNotifications: [String]?
    let onboarding: Onboarding?
    let contributeUrl: String?
}

struct Flash: Codable {
    let errorMessage: String?
    let successMessage: String?
    let popupMessage: String?
    let pageData: String?
}

struct Settings: Codable {
    let feature: Feature?
    let consentedCookies: [String]?
    let plus: Plus?
}

struct Feature: Codable {
    let enableContributionCentre: Bool?
    let enableDonations: Bool?
    let enableApiApplications: Bool?
}

struct Plus: Codable {
    let restrictionsEnabled: Bool?
}

struct Config: Codable {
    let browserExtensions: BrowserExtensions?
    let baseURI: BaseURI?
    let support: Support?
}

struct BrowserExtensions: Codable {
    let chromium: String?
    let firefox: String?
}

struct BaseURI: Codable {
    let web: String?
    let api: String?
}

struct Support: Codable {
    let email: String?
    let web: String?
}

struct Auth: Codable {
    let user: User?
}

struct User: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let fullName: String?
    let abilities: Abilities?
    let featureGrants: [String]?
    let organisations: [String]?
    let notifications: Notifications?
}

struct Abilities: Codable {
    let developer: Bool?
    let admin: Bool?
    let seePlus: Bool?
}

struct Notifications: Codable {
    let numberUnread: Int?
}

struct Airport: Codable {
    let id: Int?
    let ident: String?
    let icaoCode: String?
    let iataCode: String?
    let name: String?
    let type: String?
    let latitude: Double?
    let longitude: Double?
    let elevationFt: Int?
    let isoA2Country: String?
    let hasCharts: Bool?
    let hasSources: Bool?
}

struct Chart: Codable, Equatable, Hashable {
    let id: String?
    let parentId: String?
    let airportIcao: String?
    let name: String?
    let code: String?
    let type: Int?
    let typeKey: String?
    let meta: [Meta]?
    let viewURL: String?
    let hasGeoreferences: Bool?
}

struct Meta: Codable, Equatable, Hashable {
    let type: Int?
    let typeKey: String?
    let value: [String]?

}


struct Onboarding: Codable {
    let hasDiscord: Bool?
}

