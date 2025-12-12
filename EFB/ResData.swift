//
//  ResData.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import Foundation

nonisolated
struct AircraftData: Codable, Hashable {
    let id = UUID().uuidString
    let aircraftID: String
    let aircraftIcao: String
    let aircraftName: String
    let aircraftSort: String
    let aircraftEngines: stringOrBool
    let aircraftSearch: String
    let aircraftPassengers: Int
    let aircraftMtowLbs: Int
    let aircraftMtowKgs: Int
    let aircraftSpeed: String
    let aircraftCeiling: Int
    let aircraftTakeoff: intOrBool
    let aircraftLanding: intOrBool
    let aircraftThrustLbf: intOrBool
    let aircraftThrustShp: intOrBool
    let aircraftThrustFlatRating: intOrBool
    let aircraftMaxCostindex: intOrBool
    let aircraftFuelflowLbs: Int
    let aircraftFuelflowKgs: Int
    let aircraftIsCargo: Bool
    let aircraftDiversionDistance: Int
    let aircraftProfilesClimb: [String]
    let aircraftProfilesCruise: [String]
    let aircraftProfilesDescent: [String]
    let aircraftProfilesTakeoffFlaps: [String]
    let aircraftProfilesTakeoffThrust: [String]
    let aircraftProfilesTakeoffThrustNames: [String]
    let aircraftProfilesTakeoffBleeds: [String]
    let aircraftProfilesTakeoffAntice: [String]
    let aircraftProfilesLandingFlaps: [String]
    let aircraftProfilesLandingBrakes: [String]
    let aircraftProfilesLandingReverse: [String]
    let aircraftDefaultCruise: stringOrBool
    let statsUpdated: String
    let statsAccuracy: stringOrBool
    let statsPopularity: Double
    let statsCharts: Bool
    let statsCostindex: Bool
    let statsTlr: intOrBool
    let statsFlex: Bool
    let statsIsCustom: Bool?
    let airframes: [Airframe]
    
    enum CodingKeys: String, CodingKey {
        case aircraftID = "aircraft_id"
        case aircraftIcao = "aircraft_icao"
        case aircraftName = "aircraft_name"
        case aircraftSort = "aircraft_sort"
        case aircraftEngines = "aircraft_engines"
        case aircraftSearch = "aircraft_search"
        case aircraftPassengers = "aircraft_passengers"
        case aircraftMtowLbs = "aircraft_mtow_lbs"
        case aircraftMtowKgs = "aircraft_mtow_kgs"
        case aircraftSpeed = "aircraft_speed"
        case aircraftCeiling = "aircraft_ceiling"
        case aircraftTakeoff = "aircraft_takeoff"
        case aircraftLanding = "aircraft_landing"
        case aircraftThrustLbf = "aircraft_thrust_lbf"
        case aircraftThrustShp = "aircraft_thrust_shp"
        case aircraftThrustFlatRating = "aircraft_thrust_flat_rating"
        case aircraftMaxCostindex = "aircraft_max_costindex"
        case aircraftFuelflowLbs = "aircraft_fuelflow_lbs"
        case aircraftFuelflowKgs = "aircraft_fuelflow_kgs"
        case aircraftIsCargo = "aircraft_is_cargo"
        case aircraftDiversionDistance = "aircraft_diversion_distance"
        case aircraftProfilesClimb = "aircraft_profiles_climb"
        case aircraftProfilesCruise = "aircraft_profiles_cruise"
        case aircraftProfilesDescent = "aircraft_profiles_descent"
        case aircraftProfilesTakeoffFlaps = "aircraft_profiles_takeoff_flaps"
        case aircraftProfilesTakeoffThrust = "aircraft_profiles_takeoff_thrust"
        case aircraftProfilesTakeoffThrustNames = "aircraft_profiles_takeoff_thrust_names"
        case aircraftProfilesTakeoffBleeds = "aircraft_profiles_takeoff_bleeds"
        case aircraftProfilesTakeoffAntice = "aircraft_profiles_takeoff_antice"
        case aircraftProfilesLandingFlaps = "aircraft_profiles_landing_flaps"
        case aircraftProfilesLandingBrakes = "aircraft_profiles_landing_brakes"
        case aircraftProfilesLandingReverse = "aircraft_profiles_landing_reverse"
        case aircraftDefaultCruise = "aircraft_default_cruise"
        case statsUpdated = "stats_updated"
        case statsAccuracy = "stats_accuracy"
        case statsPopularity = "stats_popularity"
        case statsCharts = "stats_charts"
        case statsCostindex = "stats_costindex"
        case statsTlr = "stats_tlr"
        case statsFlex = "stats_flex"
        case statsIsCustom = "stats_is_custom"
        case airframes
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id.hashValue)
      }

      static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
      }
}

struct Airframe: Codable, Hashable {
    let airframeID: intOrBool
    let userID: stringOrBool
    let pilotID: intOrBool
    let modifiedTime: String
    let airframeInternalID: String
    let airframeBaseType: String
    let airframeListType: String
    let airframeIcao: String
    let airframeName: String
    let airframeEngines: stringOrBool
    let airframeRegistration: String
    let airframeFin: String
    let airframePassengers: Int
    let airframeComments: String
    let airframeOptions: AirframeOptions
    
    enum CodingKeys: String, CodingKey {
        case airframeID = "airframe_id"
        case userID = "user_id"
        case pilotID = "pilot_id"
        case modifiedTime = "modified_time"
        case airframeInternalID = "airframe_internal_id"
        case airframeBaseType = "airframe_base_type"
        case airframeListType = "airframe_list_type"
        case airframeIcao = "airframe_icao"
        case airframeName = "airframe_name"
        case airframeEngines = "airframe_engines"
        case airframeRegistration = "airframe_registration"
        case airframeFin = "airframe_fin"
        case airframePassengers = "airframe_passengers"
        case airframeComments = "airframe_comments"
        case airframeOptions = "airframe_options"
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.airframeInternalID.hashValue)
      }

      static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
      }
}

struct AirframeOptions: Codable {
    let basetype: String
    let icao: String
    let reg: String
    let fin: String
    let selcal: stringOrBool
    let hexcode: stringOrBool
    let name: String
    let engines: stringOrBool
    let comments: stringOrBool
    let cat: String
    let per: String
    let equip: String
    let transponder: String
    let pbn: String
    let extrarmk: stringOrBool
    let wgtunits: String
    let maxpax: stringOrBool
    let paxwgt: Int
    let bagwgt: Int
    let oew: Int
    let mzfw: Int
    let mtow: Int
    let mlw: Int
    let maxfuel: Int
    let maxcargo: intOrBool
    let defaultcruise: stringOrBool?
    let defaultci: stringOrBool
    let defaultclimb: stringOrBool?
    let defaultdescent: stringOrBool?
    let fuelfactor: stringOrBool
    let ceiling: stringMeantToBeInt
    let thrust: stringOrBool?
    let thrustUnits: stringOrBool?
    let flatrating: stringOrBool?
    let cruiseoffset: stringOrBool
    let etopsthreshold: stringMeantToBeInt?
    let etopsrange: String?
    let planunits: String?
    let cargomode: String?
    let planformat: String?
    let flightrules: String?
    let flighttype: String?
    let altnsadvRadius: String?
    let altnsadvRwy: String?
    let altnsadvUnitsRwy: String?
    let manualrmk: String?
    let contpct: String?
    let resvrule: String?
    let taxifuel: String?
    let minfob: String?
    let minfod: String?
    let melfuel: String?
    let atcfuel: String?
    let wxxfuel: String?
    let addedfuel: String?
    let tankering: String?
    let minfobUnits: String?
    let minfodUnits: String?
    let melfuelUnits: String?
    let atcfuelUnits: String?
    let wxxfuelUnits: String?
    let addedfuelUnits: String?
    let tankeringUnits: String?
    let addedfuelLabel: String?
    
    enum CodingKeys: String, CodingKey {
        case basetype
        case icao
        case reg
        case fin
        case selcal
        case hexcode
        case name
        case engines
        case comments
        case cat
        case per
        case equip
        case transponder
        case pbn
        case extrarmk
        case wgtunits
        case maxpax
        case paxwgt
        case bagwgt
        case oew
        case mzfw
        case mtow
        case mlw
        case maxfuel
        case maxcargo
        case defaultcruise
        case defaultci
        case defaultclimb
        case defaultdescent
        case fuelfactor
        case ceiling
        case thrust
        case thrustUnits = "thrust_units"
        case flatrating
        case cruiseoffset
        case etopsthreshold
        case etopsrange
        case planunits
        case cargomode
        case planformat
        case flightrules
        case flighttype
        case altnsadvRadius = "altnsadv_radius"
        case altnsadvRwy = "altnsadv_rwy"
        case altnsadvUnitsRwy = "altnsadv_units_rwy"
        case manualrmk
        case contpct
        case resvrule
        case taxifuel
        case minfob
        case minfod
        case melfuel
        case atcfuel
        case wxxfuel
        case addedfuel
        case tankering
        case minfobUnits = "minfob_units"
        case minfodUnits = "minfod_units"
        case melfuelUnits = "melfuel_units"
        case atcfuelUnits = "atcfuel_units"
        case wxxfuelUnits = "wxxfuel_units"
        case addedfuelUnits = "addedfuel_units"
        case tankeringUnits = "tankering_units"
        case addedfuelLabel = "addedfuel_label"
    }
}


nonisolated
struct SBUserData: Codable {
    let user: SBUser
//    let app: SBApp
//    let processTime: Double

//    enum CodingKeys: String, CodingKey {
//        case user
//        case app
//        case processTime = "process_time"
//    }
}

struct SBUser: Codable {
    let userID: String
    let pilotID: Int
    let loggedIn: Bool
    let accountLinked: Bool
    let accessToken: String
    let username: String
    let firstName: String
    let lastName: String
    let email: String
    let firstLogin: String?
    let lastUnlock: Bool
    let permissions: String?
    let creationMethod: String
//    let airac: Airac
//    let navigraph: Navigraph
//    let consent: Consent

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case pilotID = "pilot_id"
        case loggedIn = "logged_in"
        case accountLinked = "account_linked"
        case accessToken = "access_token"
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case firstLogin = "first_login"
        case lastUnlock = "last_unlock"
        case permissions
        case creationMethod = "creation_method"
//        case airac
//        case navigraph
//        case consent
    }
}

struct Airac: Codable {
    let cycles: [String: AiracCycle]
    let active: Int
    let current: Int
    let `default`: Int
}

struct AiracCycle: Codable {
    let dateStart: String
    let dateEnd: String
    let unlocked: Bool

    enum CodingKeys: String, CodingKey {
        case dateStart = "date_start"
        case dateEnd = "date_end"
        case unlocked
    }
}

struct Navigraph: Codable {
    let username: String
    let givenName: String
    let familyName: String
    let email: String
    let role: Bool?
    let subscriptions: [String]

    enum CodingKeys: String, CodingKey {
        case username
        case givenName = "given_name"
        case familyName = "family_name"
        case email
        case role
        case subscriptions
    }
}

struct Consent: Codable {
    let cookiesV2: ConsentEntry?
    let analyticsV2: ConsentEntry?
    let cookies: ConsentEntry?
    let terms: ConsentEntry?
    let dataUse: ConsentEntry?

    enum CodingKeys: String, CodingKey {
        case cookiesV2 = "cookies_v2"
        case analyticsV2 = "analytics_v2"
        case cookies
        case terms
        case dataUse = "data_use"
    }
}

struct ConsentEntry: Codable {
    let consentDate: String
    let consentMethod: String
    let consentResponse: String
    let policyVersion: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case consentDate = "consent_date"
        case consentMethod = "consent_method"
        case consentResponse = "consent_response"
        case policyVersion = "policy_version"
        case userID = "user_id"
    }
}

struct SBApp: Codable {
    let versionCurrent: String
    let enableLogging: Bool
    let lastPath: Bool?
    let lastPing: String

    enum CodingKeys: String, CodingKey {
        case versionCurrent = "version_current"
        case enableLogging = "enable_logging"
        case lastPath = "last_path"
        case lastPing = "last_ping"
    }
}

struct FlightInfo: Codable, Hashable {
    let aircraftLabel: String?
    let aircraftType: String?
    let airlineLogo: String?
    let airlineName: String?

    let arriveLabel: String?
    let connectionCity: String?
    let connectionLabel: String?
    let departLabel: String?

    let destination: String?
    let destinationFontWeight: String?

    var flightArrivalDay: String?
    var flightArrivalTime: String?
    var flightDepartureDay: String?
    var flightDepartureTime: String?

    var flightIdent: String?
    var flightStatus: String?

    let layoverDuration: String?
    let layoverLabel: String?

    let logoRowspan: String?
    let origin: String?
    let originFontWeight: String?
    let rowspan: String?
}

extension FlightInfo {
    enum CodingKeys: String, CodingKey {
        case aircraftLabel
        case aircraftType
        case airlineLogo
        case airlineName
        case arriveLabel
        case connectionCity
        case connectionLabel
        case departLabel
        case destination
        case destinationFontWeight = "destination-font-weight"
        case flightArrivalDay
        case flightArrivalTime
        case flightDepartureDay
        case flightDepartureTime
        case flightIdent
        case flightStatus
        case layoverDuration
        case layoverLabel
        case logoRowspan
        case origin
        case originFontWeight = "origin-font-weight"
        case rowspan
    }
}

struct Flight: Codable, Hashable {
//    var id: String { reg }
    
    let aircraftType: String?
    let alliance: String?
    let operatorName: String?
    let prefix: String?
    let reg: String?
    let destinationCity: String?
    
    let estimatedDepartureTime: String?
    let estimatedArrivalTime: String?
    let scheduledBlockOut: String?
    let scheduledBlockIn: String?
    let filedDepartureTime: String?
    let filedArrivalTime: String?
    let filedETE: String?
    
    let gateOrigin: String?
    let gateDestination: String?
    let terminalOrigin: String?
    let terminalDestination: String?
    
    let seatsBusiness: String?
    let seatsCoach: String?
    let seatsFirst: String?
    
    let routeDistance: String?
    let status: String?
    let statusCode: String?
    
    enum CodingKeys: String, CodingKey {
        case aircraftType = "aircrafttype_friendly"
        case alliance
        case operatorName = "operator"
        case prefix
        case reg
        case destinationCity = "destination_city"
        case estimatedDepartureTime = "estimateddeparturetime"
        case estimatedArrivalTime = "estimatedarrivaltime"
        case scheduledBlockOut = "sch_block_out"
        case scheduledBlockIn = "sch_block_in"
        case filedDepartureTime = "filed_departuretime"
        case filedArrivalTime = "filed_arrivaltime"
        case filedETE = "filed_ete"
        case gateOrigin = "gate_orig"
        case gateDestination = "gate_dest"
        case terminalOrigin = "terminal_orig"
        case terminalDestination = "terminal_dest"
        case seatsBusiness = "seats_cabin_business"
        case seatsCoach = "seats_cabin_coach"
        case seatsFirst = "seats_cabin_first"
        case routeDistance = "route_distance"
        case status
        case statusCode = "status_code"
    }
}

nonisolated
struct AirlabsResponse: Codable {
    let response: [Route]
}

struct Route: Codable {
    let airline_iata: String?
    let airline_icao: String?
    let flight_number: String?
    let flight_iata: String?
    let flight_icao: String?
//    let cs_airline_iata: String?
//    let cs_flight_iata: String?
//    let cs_flight_number: String? Might fuck everything up
    let dep_iata: String?
    let dep_icao: String?
    let dep_terminals: [String]?
    let dep_time: String?
    let dep_time_utc: String?
    let arr_iata: String?
    let arr_icao: String?
    let arr_terminals: [String]?
    let arr_time: String?
    let arr_time_utc: String?
    let duration: Int?
    let aircraft_icao: String?
    let counter: Int?
    let updated: String?
    let days: [String]?
}


nonisolated
struct AirportDetail: Codable {
    let ident: String
    let type: String
    let name: String
    let latitudeDeg: Double
    let longitudeDeg: Double
    let elevationFt: String?
    let continent: String
    let isoCountry: String
    let isoRegion: String
    let municipality: String?
    let scheduledService: String?
    let gpsCode: String?
    let iataCode: String?
    let localCode: String?
    let homeLink: String?
    let wikipediaLink: String?
    let keywords: String?
    let icaoCode: String?
    let runways: [Runway]
    let freqs: [Frequency]
    let country: Country
    let region: Region
    let navaids: [Navaid]?
    let updatedAt: String?
    let station: Station?

    enum CodingKeys: String, CodingKey {
        case ident, type, name
        case latitudeDeg = "latitude_deg"
        case longitudeDeg = "longitude_deg"
        case elevationFt = "elevation_ft"
        case continent
        case isoCountry = "iso_country"
        case isoRegion = "iso_region"
        case municipality
        case scheduledService = "scheduled_service"
        case gpsCode = "gps_code"
        case iataCode = "iata_code"
        case localCode = "local_code"
        case homeLink = "home_link"
        case wikipediaLink = "wikipedia_link"
        case keywords
        case icaoCode = "icao_code"
        case runways, freqs, country, region, navaids, updatedAt
        case station
    }
}

struct Runway: Codable {
    let id: String
    let airportRef: String
    let airportIdent: String
    let lengthFt: String
    let widthFt: String
    let surface: String
    let lighted: String
    let closed: String
    let leIdent: String
    let leLatitudeDeg: String?
    let leLongitudeDeg: String?
    let leElevationFt: String?
    let leHeadingDegT: String?
    let leDisplacedThresholdFt: String?
    let heIdent: String
    let heLatitudeDeg: String?
    let heLongitudeDeg: String?
    let heElevationFt: String?
    let heHeadingDegT: String?
    let heDisplacedThresholdFt: String?
    let leIls: RunwayILS?
    let heIls: RunwayILS?

    enum CodingKeys: String, CodingKey {
        case id
        case airportRef = "airport_ref"
        case airportIdent = "airport_ident"
        case lengthFt = "length_ft"
        case widthFt = "width_ft"
        case surface, lighted, closed
        case leIdent = "le_ident"
        case leLatitudeDeg = "le_latitude_deg"
        case leLongitudeDeg = "le_longitude_deg"
        case leElevationFt = "le_elevation_ft"
        case leHeadingDegT = "le_heading_degT"
        case leDisplacedThresholdFt = "le_displaced_threshold_ft"
        case heIdent = "he_ident"
        case heLatitudeDeg = "he_latitude_deg"
        case heLongitudeDeg = "he_longitude_deg"
        case heElevationFt = "he_elevation_ft"
        case heHeadingDegT = "he_heading_degT"
        case heDisplacedThresholdFt = "he_displaced_threshold_ft"
        case leIls = "le_ils"
        case heIls = "he_ils"
    }
}

struct RunwayILS: Codable {
    let freq: Double
    let course: Int
}

struct Frequency: Codable {
    let id: String
    let airportRef: String
    let airportIdent: String
    let type: String
    let description: String
    let frequencyMHz: String

    enum CodingKeys: String, CodingKey {
        case id
        case airportRef = "airport_ref"
        case airportIdent = "airport_ident"
        case type
        case description
        case frequencyMHz = "frequency_mhz"
    }
}

struct Country: Codable {
    let id: String
    let code: String
    let name: String
    let continent: String
    let wikipediaLink: String?
    let keywords: String?

    enum CodingKeys: String, CodingKey {
        case id, code, name, continent
        case wikipediaLink = "wikipedia_link"
        case keywords
    }
}

struct Region: Codable {
    let id: String
    let code: String
    let localCode: String?
    let name: String
    let continent: String
    let isoCountry: String
    let wikipediaLink: String?
    let keywords: String?

    enum CodingKeys: String, CodingKey {
        case id, code
        case localCode = "local_code"
        case name, continent
        case isoCountry = "iso_country"
        case wikipediaLink = "wikipedia_link"
        case keywords
    }
}

struct Navaid: Codable {
    let id: String
    let filename: String?
    let ident: String
    let name: String
    let type: String
    let frequencyKHz: String?
    let latitudeDeg: String?
    let longitudeDeg: String?
    let elevationFt: String?
    let isoCountry: String?
    let dmeFrequencyKHz: String?
    let dmeChannel: String?
    let dmeLatitudeDeg: String?
    let dmeLongitudeDeg: String?
    let dmeElevationFt: String?
    let slavedVariationDeg: String?
    let magneticVariationDeg: String?
    let usageType: String?
    let power: String?
    let associatedAirport: String?

    enum CodingKeys: String, CodingKey {
        case id, filename, ident, name, type
        case frequencyKHz = "frequency_khz"
        case latitudeDeg = "latitude_deg"
        case longitudeDeg = "longitude_deg"
        case elevationFt = "elevation_ft"
        case isoCountry = "iso_country"
        case dmeFrequencyKHz = "dme_frequency_khz"
        case dmeChannel = "dme_channel"
        case dmeLatitudeDeg = "dme_latitude_deg"
        case dmeLongitudeDeg = "dme_longitude_deg"
        case dmeElevationFt = "dme_elevation_ft"
        case slavedVariationDeg = "slaved_variation_deg"
        case magneticVariationDeg = "magnetic_variation_deg"
        case usageType, power
        case associatedAirport = "associated_airport"
    }
}

struct Station: Codable {
    let icaoCode: String
    let distance: Double

    enum CodingKeys: String, CodingKey {
        case icaoCode = "icao_code"
        case distance
    }
}
nonisolated
struct ifatcAirportRes: Codable, Hashable {
    let results: [ifatcAirport]
}

struct ifatcAirport: Codable, Equatable, Hashable {
    let id: String
    let text: String
}

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

