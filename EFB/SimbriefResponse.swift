//
//  SimbriefResponse.swift
//  EFB
//
//  Created by Jonathan Lim on 12/6/25.
//

import Foundation

nonisolated
struct SBAirportData: Codable {
    let airport_icao: String
    let airport_iata: String
    let airport_region: String
    let airport_name: String
    let airport_latitude: Double
    let airport_longitude: Double
    let airport_elevation: Int
    let airport_localtime: String
    let airport_declination: Int
    let metar_description: String
    let metar_visibility: Int
    let metar_ceiling: Int
    let metar_wind_direction: Int
    let metar_wind_speed: Int
    let metar_wind_gust: intOrBool
    let metar_temperature: Int
    let metar_altimeter: Double
    let metar_precipitation: stringOrBool
    let transition_altitude: Int
    let transition_level: Int
    let text_metar: String
    let text_taf: String
//    let text_atis: [String]
    let text_metar_age: String
    let text_taf_age: String
    let runways: [Runway]

    struct Runway: Codable {
        let identifier: String
        let length: Int
        let length_toda: Int
        let length_tora: Int
        let length_asda: Int
        let length_lda: Int
        let width: Int
        let true_course: Int
        let headwind_component: Int
        let crosswind_component: Int
        let used_for_departure: Bool
        let used_for_arrival: Bool
        let primary_for_departure: Bool
        let primary_for_arrival: Bool
    }
}

nonisolated
struct FlightPlan: Codable {
    let fetch: SBFetch
    let params: SBParams
    let general: SBGeneral
    let origin: SBAirport
    let destination: SBAirport
    let alternate: SBAirport
    let alternateNavlog: [String: String]?
    let takeoffAltn: SBAirport?
    let enrouteAltn: SBAirport?
    let enrouteStation: [String: String]?
    let navlog: SBNavlog
    let etops: [String: String]?
    let tlr: SBTlr
    let atc: SBAtc
    let aircraft: SBAircraft
    let fuel: SBFuel
    let fuelExtra: SBFuelExtra?
    let times: SBTimes
    let weights: SBWeights
    let impacts: SBImpacts?
    let crew: SBCrew?
    let notams: SBNotams?
//    let sigmets: [String: String]?
    let text: SBText?
    let maps: SBMaps?
    let links: SBLinks?
    let files: SBFiles?
    let images: SBImages?
    let tracks: [String: String]?
    let databaseUpdates: [String: String]?
    let apiParams: SBApiParams
//    let filesListings: [String: String]? // backup flexible holder if needed

    enum CodingKeys: String, CodingKey {
        case fetch, params, general, origin, destination, alternate
        case alternateNavlog = "alternate_navlog"
        case takeoffAltn = "takeoff_altn"
        case enrouteAltn = "enroute_altn"
        case enrouteStation = "enroute_station"
        case navlog, etops, tlr, atc, aircraft, fuel
        case fuelExtra = "fuel_extra"
        case times, weights, impacts, crew, notams, text, maps, links, files, images, tracks
        case databaseUpdates = "database_updates"
        case apiParams = "api_params"
//        case files = "files"
    }
}

struct SBFetch: Codable {
    let userid: String?
    let staticID: [String: String]?
    let status: String?
    let time: String?

    enum CodingKeys: String, CodingKey {
        case userid
        case staticID = "static_id"
        case status, time
    }
}

struct SBParams: Codable {
    let requestID: String?
    let sequenceID: String?
    let staticID: [String: String]?
    let userID: String?
    let timeGenerated: String?
    let xmlFile: String?
    let ofpLayout: String?
    let airac: String?
    let units: String?

    enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
        case sequenceID = "sequence_id"
        case staticID = "static_id"
        case userID = "user_id"
        case timeGenerated = "time_generated"
        case xmlFile = "xml_file"
        case ofpLayout = "ofp_layout"
        case airac, units
    }
}

struct SBGeneral: Codable {
    let release: String?
    let icaoAirline: stringOrDict?
    let flightNumber: String?
    let isEtops: String?
    let dxRmk: stringOrDict?
    let sysRmk: stringOrDict?
    let isDetailedProfile: String?
    let cruiseProfile: String?
    let climbProfile: String?
    let descentProfile: String?
    let alternateProfile: String?
    let reserveProfile: String?
    let costindex: stringOrDict?
    let contRule: String?
    let initialAltitude: String?
    let stepclimbString: String?
    let avgTempDev: String?
    let avgTropopause: String?
    let avgWindComp: String?
    let avgWindDir: String?
    let avgWindSpd: String?
    let gcDistance: String?
    let routeDistance: String?
    let airDistance: String?
    let totalBurn: String?
    let cruiseTas: String?
    let cruiseMach: String?
    let passengers: String?
    let route: stringOrDict?
    let routeIfps: stringOrDict?
    let routeNavigraph: stringOrDict?
    let sidIdent: stringOrDict?
    let sidTrans: stringOrDict?
    let starIdent: stringOrDict?
    let starTrans: stringOrDict?

    enum CodingKeys: String, CodingKey {
        case release
        case icaoAirline = "icao_airline"
        case flightNumber = "flight_number"
        case isEtops = "is_etops"
        case dxRmk = "dx_rmk"
        case sysRmk = "sys_rmk"
        case isDetailedProfile = "is_detailed_profile"
        case cruiseProfile = "cruise_profile"
        case climbProfile = "climb_profile"
        case descentProfile = "descent_profile"
        case alternateProfile = "alternate_profile"
        case reserveProfile = "reserve_profile"
        case costindex, contRule = "cont_rule"
        case initialAltitude = "initial_altitude"
        case stepclimbString = "stepclimb_string"
        case avgTempDev = "avg_temp_dev"
        case avgTropopause = "avg_tropopause"
        case avgWindComp = "avg_wind_comp"
        case avgWindDir = "avg_wind_dir"
        case avgWindSpd = "avg_wind_spd"
        case gcDistance = "gc_distance"
        case routeDistance = "route_distance"
        case airDistance = "air_distance"
        case totalBurn = "total_burn"
        case cruiseTas = "cruise_tas"
        case cruiseMach = "cruise_mach"
        case passengers, route
        case routeIfps = "route_ifps"
        case routeNavigraph = "route_navigraph"
        case sidIdent = "sid_ident"
        case sidTrans = "sid_trans"
        case starIdent = "star_ident"
        case starTrans = "star_trans"
    }
}

struct SBAirport: Codable {
    let icaoCode: String?
    let iataCode: stringOrDict?
    let faaCode: stringOrDict?
    let icaoRegion: String?
    let elevation: String?
    let posLat: String?
    let posLong: String?
    let name: String?
    let timezone: String?
    let planRwy: String?
    let transAlt: String?
    let transLevel: String?
    let metar: String?
    let metarTime: String?
    let metarCategory: String?
    let metarVisibility: String?
    let metarCeiling: String?
    let taf: String?
    let tafTime: String?
//    let atis: [String: String]?
    let notam: notamEmpty?

    enum CodingKeys: String, CodingKey {
        case icaoCode = "icao_code"
        case iataCode = "iata_code"
        case faaCode = "faa_code"
        case icaoRegion = "icao_region"
        case elevation, posLat = "pos_lat", posLong = "pos_long"
        case name, timezone
        case planRwy = "plan_rwy"
        case transAlt = "trans_alt"
        case transLevel = "trans_level"
        case metar, metarTime = "metar_time", metarCategory = "metar_category"
        case metarVisibility = "metar_visibility"
        case metarCeiling = "metar_ceiling"
        case taf, tafTime = "taf_time", notam
    }
}

struct SBNotamEntry: Codable {
    let sourceID: String?
    let accountID: String?
    let notamID: String?
    let locationID: String?
    let locationICAO: String?
    let locationName: String?
    let locationType: String?
    let dateCreated: String?
    let dateEffective: String?
    let dateExpire: String?
    let dateExpireIsEstimated: String?
    let dateModified: String?
    let notamSchedule: [String: String]?
    let notamHTML: String?
    let notamText: String?
    let notamRaw: String?
    let notamNrc: String?
    let notamQcode: String?
    let notamQcodeCategory: String?
    let notamQcodeSubject: String?
    let notamQcodeStatus: String?
    let notamIsObstacle: String?

    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case accountID = "account_id"
        case notamID = "notam_id"
        case locationID = "location_id"
        case locationICAO = "location_icao"
        case locationName = "location_name"
        case locationType = "location_type"
        case dateCreated = "date_created"
        case dateEffective = "date_effective"
        case dateExpire = "date_expire"
        case dateExpireIsEstimated = "date_expire_is_estimated"
        case dateModified = "date_modified"
        case notamSchedule = "notam_schedule"
        case notamHTML = "notam_html"
        case notamText = "notam_text"
        case notamRaw = "notam_raw"
        case notamNrc = "notam_nrc"
        case notamQcode = "notam_qcode"
        case notamQcodeCategory = "notam_qcode_category"
        case notamQcodeSubject = "notam_qcode_subject"
        case notamQcodeStatus = "notam_qcode_status"
        case notamIsObstacle = "notam_is_obstacle"
    }
}

struct SBTlr: Codable {
    let takeoff: SBTlrPhase?
    let landing: SBTlrPhase?
}

struct SBTlrPhase: Codable {
    let conditions: [String: String]?
    let runway: [SBTlrRunway]?
    let distanceDry: SBTlrDistance?
    let distanceWet: SBTlrDistance?

    enum CodingKeys: String, CodingKey {
        case conditions, runway
        case distanceDry = "distance_dry"
        case distanceWet = "distance_wet"
    }
}

struct SBTlrRunway: Codable {
    let identifier: String?
    let length: String?
    let lengthTora: String?
    let lengthToda: String?
    let lengthAsda: String?
    let lengthLda: String?
    let elevation: String?
    let gradient: String?
    let trueCourse: String?
    let magneticCourse: String?
    let headwindComponent: String?
    let crosswindComponent: String?
    let ilsFrequency: stringOrDict?
    let flapSetting: String?
    let thrustSetting: String?
    let bleedSetting: String?
    let antiIceSetting: String?
    let flexTemperature: stringOrDict?
    let maxTemperature: stringOrDict?
    let maxWeight: stringOrDict?
    let limitCode: stringOrDict?
    let limitObstacle: stringOrDict?
    let speedsV1: stringOrDict?
    let speedsVr: stringOrDict?
    let speedsV2: stringOrDict?
    let speedsV2ID: stringOrDict?
    let speedsOther: String?
    let speedsOtherID: String?
    let distanceDecide: String?
    let distanceReject: String?
    let distanceMargin: String?
    let distanceContinue: String?

    enum CodingKeys: String, CodingKey {
        case identifier, length
        case lengthTora = "length_tora"
        case lengthToda = "length_toda"
        case lengthAsda = "length_asda"
        case lengthLda = "length_lda"
        case elevation, gradient
        case trueCourse = "true_course"
        case magneticCourse = "magnetic_course"
        case headwindComponent = "headwind_component"
        case crosswindComponent = "crosswind_component"
        case ilsFrequency = "ils_frequency"
        case flapSetting = "flap_setting"
        case thrustSetting = "thrust_setting"
        case bleedSetting = "bleed_setting"
        case antiIceSetting = "anti_ice_setting"
        case flexTemperature = "flex_temperature"
        case maxTemperature = "max_temperature"
        case maxWeight = "max_weight"
        case limitCode = "limit_code"
        case limitObstacle = "limit_obstacle"
        case speedsV1 = "speeds_v1"
        case speedsVr = "speeds_vr"
        case speedsV2 = "speeds_v2"
        case speedsV2ID = "speeds_v2_id"
        case speedsOther = "speeds_other"
        case speedsOtherID = "speeds_other_id"
        case distanceDecide = "distance_decide"
        case distanceReject = "distance_reject"
        case distanceMargin = "distance_margin"
        case distanceContinue = "distance_continue"
    }
}

struct SBTlrDistance: Codable {
    let weight: String?
    let flapSetting: String?
    let brakeSetting: String?
    let reverserCredit: String?
    let speedsVref: String?
    let actualDistance: String?
    let factoredDistance: String?

    enum CodingKeys: String, CodingKey {
        case weight, flapSetting = "flap_setting", brakeSetting = "brake_setting", reverserCredit = "reverser_credit"
        case speedsVref = "speeds_vref"
        case actualDistance = "actual_distance"
        case factoredDistance = "factored_distance"
    }
}

struct SBAtc: Codable {
    let flightplanText: String?
    let route: String?
    let routeIfps: String?
    let callsign: String?
    let flightType: String?
    let flightRules: String?
    let initialSpd: String?
    let initialSpdUnit: String?
    let initialAlt: String?
    let initialAltUnit: String?
    let section18: String?
    let firOrig: String?
    let firDest: String?
    let firAltn: [String: String]?
    let firEtops: [String: String]?
    let firEnroute: stringOrDict?

    enum CodingKeys: String, CodingKey {
        case flightplanText = "flightplan_text"
        case route, routeIfps = "route_ifps", callsign, flightType = "flight_type", flightRules = "flight_rules"
        case initialSpd = "initial_spd", initialSpdUnit = "initial_spd_unit"
        case initialAlt = "initial_alt", initialAltUnit = "initial_alt_unit"
        case section18 = "section18"
        case firOrig = "fir_orig"
        case firDest = "fir_dest"
        case firAltn = "fir_altn"
        case firEtops = "fir_etops"
        case firEnroute = "fir_enroute"
    }
}

struct SBAircraft: Codable {
    let icaocode: String?
    let iatacode: stringOrDict?
    let baseType: String?
    let listType: String?
    let icaoCode: String?
    let iataCode: stringOrDict?
    let name: String?
    let engines: String?
    let reg: String?
    let fin: stringOrDict?
    let selcal: stringOrDict?
    let equip: String?
    let equipCategory: String?
    let equipNavigation: String?
    let equipTransponder: String?
    let fuelfact: String?
    let fuelfactor: String?
    let maxPassengers: String?
    let supportsTlr: String?
    let internalID: String?
    let isCustom: String?

    enum CodingKeys: String, CodingKey {
        case icaocode, iatacode, baseType = "base_type", listType = "list_type"
        case icaoCode = "icao_code", iataCode = "iata_code", name, engines, reg, fin, selcal, equip
        case equipCategory = "equip_category"
        case equipNavigation = "equip_navigation"
        case equipTransponder = "equip_transponder"
        case fuelfact, fuelfactor, maxPassengers = "max_passengers", supportsTlr = "supports_tlr"
        case internalID = "internal_id", isCustom = "is_custom"
    }
}

struct SBFuel: Codable {
    let taxi: String?
    let enrouteBurn: String?
    let contingency: String?
    let alternateBurn: String?
    let reserve: String?
    let etops: String?
    let extra: String?
    let extraRequired: String?
    let extraOptional: String?
    let minTakeoff: String?
    let planTakeoff: String?
    let planRamp: String?
    let planLanding: String?
    let avgFuelFlow: String?
    let maxTanks: String?

    enum CodingKeys: String, CodingKey {
        case taxi
        case enrouteBurn = "enroute_burn"
        case contingency, alternateBurn = "alternate_burn", reserve, etops, extra
        case extraRequired = "extra_required"
        case extraOptional = "extra_optional"
        case minTakeoff = "min_takeoff"
        case planTakeoff = "plan_takeoff"
        case planRamp = "plan_ramp"
        case planLanding = "plan_landing"
        case avgFuelFlow = "avg_fuel_flow"
        case maxTanks = "max_tanks"
    }
}

struct SBFuelExtra: Codable {
    let bucket: [SBFuelBucket]?
}

struct SBFuelBucket: Codable {
    let label: String?
    let fuel: String?
    let time: String?
    let required: stringOrDict?
}

struct SBTimes: Codable {
    let estTimeEnroute: String?
    let schedTimeEnroute: String?
    let schedOut: String?
    let schedOff: String?
    let schedOn: String?
    let schedIn: String?
    let schedBlock: String?
    let estOut: String?
    let estOff: String?
    let estOn: String?
    let estIn: String?
    let estBlock: String?
    let origTimezone: String?
    let destTimezone: String?
    let taxiOut: stringOrDict?
    let taxiIn: stringOrDict?
    let reserveTime: String?
    let endurance: String?
    let contfuelTime: String?
    let etopsfuelTime: String?
    let extrafuelTime: String?

    enum CodingKeys: String, CodingKey {
        case estTimeEnroute = "est_time_enroute"
        case schedTimeEnroute = "sched_time_enroute"
        case schedOut = "sched_out", schedOff = "sched_off", schedOn = "sched_on", schedIn = "sched_in", schedBlock = "sched_block"
        case estOut = "est_out", estOff = "est_off", estOn = "est_on", estIn = "est_in", estBlock = "est_block"
        case origTimezone = "orig_timezone", destTimezone = "dest_timezone"
        case taxiOut = "taxi_out", taxiIn = "taxi_in", reserveTime = "reserve_time", endurance
        case contfuelTime = "contfuel_time", etopsfuelTime = "etopsfuel_time", extrafuelTime = "extrafuel_time"
    }
}

struct SBWeights: Codable {
    let oew: String?
    let paxCount: String?
    let bagCount: String?
    let paxCountActual: String?
    let bagCountActual: String?
    let paxWeight: String?
    let bagWeight: String?
    let freightAdded: String?
    let cargo: String?
    let payload: String?
    let estZfw: String?
    let maxZfw: String?
    let estTow: String?
    let maxTow: String?
    let maxTowStruct: String?
    let towLimitCode: String?
    let estLdw: String?
    let maxLdw: String?
    let estRamp: String?

    enum CodingKeys: String, CodingKey {
        case oew
        case paxCount = "pax_count"
        case bagCount = "bag_count"
        case paxCountActual = "pax_count_actual"
        case bagCountActual = "bag_count_actual"
        case paxWeight = "pax_weight"
        case bagWeight = "bag_weight"
        case freightAdded = "freight_added"
        case cargo, payload
        case estZfw = "est_zfw"
        case maxZfw = "max_zfw"
        case estTow = "est_tow"
        case maxTow = "max_tow"
        case maxTowStruct = "max_tow_struct"
        case towLimitCode = "tow_limit_code"
        case estLdw = "est_ldw"
        case maxLdw = "max_ldw"
        case estRamp = "est_ramp"
    }
}

struct SBImpacts: Codable {
    let minus6000ft: SBImpactDetail?
    let minus4000ft: SBImpactDetail?
    let minus2000ft: SBImpactDetail?
    let plus2000ft: SBImpactDetail?
    let plus4000ft: SBImpactDetail?
    let plus6000ft: SBImpactDetail?
    let higherCi: SBImpactDetail?
    let lowerCi: SBImpactDetail?
    let zfwPlus1000: SBImpactDetail?
    let zfwMinus1000: SBImpactDetail?

    enum CodingKeys: String, CodingKey {
        case minus6000ft = "minus_6000ft"
        case minus4000ft = "minus_4000ft"
        case minus2000ft = "minus_2000ft"
        case plus2000ft = "plus_2000ft"
        case plus4000ft = "plus_4000ft"
        case plus6000ft = "plus_6000ft"
        case higherCi = "higher_ci"
        case lowerCi = "lower_ci"
        case zfwPlus1000 = "zfw_plus_1000"
        case zfwMinus1000 = "zfw_minus_1000"
    }
}

struct SBImpactDetail: Codable {
    let timeEnroute: String?
    let timeDifference: String?
    let enrouteBurn: String?
    let burnDifference: String?
    let rampFuel: String?
    let initialFl: String?
    let initialTas: String?
    let initialMach: String?
    let costIndex: String?

    enum CodingKeys: String, CodingKey {
        case timeEnroute = "time_enroute"
        case timeDifference = "time_difference"
        case enrouteBurn = "enroute_burn"
        case burnDifference = "burn_difference"
        case rampFuel = "ramp_fuel"
        case initialFl = "initial_fl"
        case initialTas = "initial_tas"
        case initialMach = "initial_mach"
        case costIndex = "cost_index"
    }
}

struct SBCrew: Codable {
    let pilotID: stringOrDict?
    let cpt: stringOrDict?
    let fo: stringOrDict?
    let dx: stringOrDict?
    let pu: stringOrDict?
    let fa: [String]?

    enum CodingKeys: String, CodingKey {
        case pilotID = "pilot_id"
        case cpt, fo, dx, pu, fa
    }
}

struct SBNotams: Codable {
    let notamdrec: [SBNotamRec]?
}

struct SBNotamRec: Codable {
    let sourceID: String?
    let accountID: String?
    let notamID: String?
    let notamPart: String?
    let cnsLocationID: String?
    let icaoID: String?
    let icaoName: String?
    let totalParts: String?
    let notamCreatedDtg: String?
    let notamEffectiveDtg: String?
    let notamExpireDtg: String?
    let notamLastmodDtg: String?
    let notamInsertedDtg: String?
    let notamText: String?
    let notamReport: String?
    let notamNrc: String?
    let notamQcode: String?

    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case accountID = "account_id"
        case notamID = "notam_id"
        case notamPart = "notam_part"
        case cnsLocationID = "cns_location_id"
        case icaoID = "icao_id"
        case icaoName = "icao_name"
        case totalParts = "total_parts"
        case notamCreatedDtg = "notam_created_dtg"
        case notamEffectiveDtg = "notam_effective_dtg"
        case notamExpireDtg = "notam_expire_dtg"
        case notamLastmodDtg = "notam_lastmod_dtg"
        case notamInsertedDtg = "notam_inserted_dtg"
        case notamText = "notam_text"
        case notamReport = "notam_report"
        case notamNrc = "notam_nrc"
        case notamQcode = "notam_qcode"
    }
}

struct SBText: Codable {
    let natTracks: [String: String]?
    let tlrSection: stringOrDict?

    enum CodingKeys: String, CodingKey {
        case natTracks = "nat_tracks"
        case tlrSection = "tlr_section"
    }
}

struct SBMaps: Codable {
    let mapData: String?

    enum CodingKeys: String, CodingKey {
        case mapData = "map_data"
    }
}

struct SBLinks: Codable {
    let skyvector: String?

    enum CodingKeys: String, CodingKey {
        case skyvector
    }
}

struct SBFiles: Codable {
    let directory: String?
    let pdf: SBFileRef?
    let file: [SBFileRef]?

    enum CodingKeys: String, CodingKey {
        case directory, pdf, file
    }
}

struct SBFileRef: Codable {
    let name: String?
    let link: String?
}

struct SBImages: Codable {
    let directory: String?
    let map: [SBFileRef]?
}

struct SBNavlog: Codable {
    let fix: [SBNavFix]?
}

struct SBNavFix: Codable, Identifiable {
    let id = UUID()
    let ident: String?
    let name: String?
    let type: String?
    let icaoRegion: stringOrDict?
    let regionCode: stringOrDict?
    let frequency: stringOrDict?
    let posLat: String?
    let posLong: String?
    let stage: String?
    let viaAirway: String?
    let isSidStar: String?
    let distance: String?
    let trackTrue: String?
    let trackMag: String?
    let headingTrue: String?
    let headingMag: String?
    let altitudeFeet: String?
    let indAirspeed: String?
    let trueAirspeed: String?
    let mach: String?
    let machThousandths: String?
    let windComponent: String?
    let groundspeed: String?
    let timeLeg: String?
    let timeTotal: String?
    let fuelFlow: String?
    let fuelLeg: String?
    let fuelTotalused: String?
    let fuelMinOnboard: String?
    let fuelPlanOnboard: String?
    let oat: String?
    let oatIsaDev: String?
    let windDir: String?
    let windSpd: String?
    let shear: String?
    let tropopauseFeet: String?
    let groundHeight: String?
    let fir: String?
    let firUnits: String?
    let firValidLevels: String?
    let mora: String?
    let windData: SBWindData?
    let firCrossing: SBFirCrossing?

    enum CodingKeys: String, CodingKey {
        case ident, name, type
        case icaoRegion = "icao_region"
        case regionCode = "region_code"
        case frequency, posLat = "pos_lat", posLong = "pos_long", stage
        case viaAirway = "via_airway"
        case isSidStar = "is_sid_star"
        case distance, trackTrue = "track_true", trackMag = "track_mag"
        case headingTrue = "heading_true", headingMag = "heading_mag"
        case altitudeFeet = "altitude_feet"
        case indAirspeed = "ind_airspeed", trueAirspeed = "true_airspeed"
        case mach, machThousandths = "mach_thousandths"
        case windComponent = "wind_component", groundspeed, timeLeg = "time_leg", timeTotal = "time_total"
        case fuelFlow = "fuel_flow", fuelLeg = "fuel_leg", fuelTotalused = "fuel_totalused"
        case fuelMinOnboard = "fuel_min_onboard", fuelPlanOnboard = "fuel_plan_onboard"
        case oat, oatIsaDev = "oat_isa_dev"
        case windDir = "wind_dir", windSpd = "wind_spd", shear, tropopauseFeet = "tropopause_feet"
        case groundHeight = "ground_height", fir, firUnits = "fir_units", firValidLevels = "fir_valid_levels", mora, windData = "wind_data", firCrossing = "fir_crossing"
    }
}

struct SBWindData: Codable {
    let level: [SBWindLevel]?
}

struct SBWindLevel: Codable {
    let altitude: String?
    let windDir: String?
    let windSpd: String?
    let oat: String?

    enum CodingKeys: String, CodingKey {
        case altitude, windDir = "wind_dir", windSpd = "wind_spd", oat
    }
}

struct SBFirCrossing: Codable {
    let fir: SBFir?
}

struct SBFir: Codable {
    let firIcao: String?
    let firName: String?
    let posLatEntry: String?
    let posLongEntry: String?

    enum CodingKeys: String, CodingKey {
        case firIcao = "fir_icao", firName = "fir_name", posLatEntry = "pos_lat_entry", posLongEntry = "pos_long_entry"
    }
}


 struct SBApiParams: Codable {
     let airline: stringOrDict?
     let fltnum: stringOrDict?
     let type: String?
     let orig: String?
     let dest: String?
     let date: String?
     let dephour: String?
     let depmin: String?
     let route: stringOrDict?
     let stehour: stringOrDict?
     let stemin: stringOrDict?
     let reg: stringOrDict?
     let fin: stringOrDict?
     let selcal: stringOrDict?
     let pax: String?
     let altn: String?
     let fl: stringOrDict?
     let cpt: stringOrDict?
     let pid: stringOrDict?
     let fuelfactor: String?
     let manualpayload: String?
     let manualzfw: String?
     let taxifuel: String?
     let minfob: String?
     let minfob_units: String?
     let minfod: String?
     let minfod_units: String?
     let melfuel: String?
     let melfuel_units: String?
     let atcfuel: String?
     let atcfuel_units: String?
     let wxxfuel: String?
     let wxxfuel_units: String?
     let addedfuel: String?
     let addedfuel_units: String?
     let addedfuel_label: String?
     let tankering: String?
     let tankering_units: String?
     let flightrules: String?
     let flighttype: String?
     let contpct: String?
     let resvrule: String?
     let taxiout: stringOrDict?
     let taxiin: stringOrDict?
     let cargo: String?
     let origrwy: String?
     let destrwy: String?
     let climb: stringOrDict?
     let descent: stringOrDict?
     let cruisemode: stringOrDict?
     let cruisesub: stringOrDict?
     let planformat: String?
     let pounds: String?
     let navlog: String?
     let etops: String?
     let stepclimbs: stringOrDict?
     let tlr: String?
     let notams_opt: String?
     let firnot: String?
     let maps: String?
//     let turntoflt: stringOrDict?
//     let turntoapt: [String: String]?
//     let turntotime: [String: String]?
//     let turnfrflt: [String: String]?
//     let turnfrapt: [String: String]?
//     let turnfrtime: [String: String]?
//     let fuelstats: [String: String]?
//     let contlabel: [String: String]?
//     let static_id: [String: String]?
//     let acdata: [String: String]?
     let acdata_parsed: stringOrDict?
}
nonisolated
struct TOPerformanceResponse: Codable {
    let inputs: Inputs
    let airport: Airport
    let runway: Runway
    let aircraft: Aircraft
    let result: ResultData
    let remarks: [Remark]
    let message: String

    struct Inputs: Codable {
        let airport: String
        let runway: String
        let aircraft: String
        let aircraft_data: String?
        let weight: Double
        let runway_shorten: Double?
        let flap_setting: String?
        let thrust_setting: String?
        let enable_flex: String?
        let enable_climb_optimization: String?
        let enable_bleeds: String?
        let enable_anti_ice: String?
        let wind_direction: Double?
        let wind_speed: Double?
        let temperature: Double?
        let altimeter: String?
        let surface_condition: String?
        let weight_units: String?
        let length_units: String?
        let wind_units: String?
        let pressure_units: String?
    }

    struct Airport: Codable {
        let icao: String
        let iata: String?
        let name: String?
        let region: String?
        let latitude: Double?
        let longitude: Double?
        let elevation: Double?
    }

    struct Runway: Codable {
        let identifier: String
        let length: Double?
        let length_tora: Double?
        let length_toda: Double?
        let length_asda: Double?
        let length_lda: Double?
        let width: Double?
        let elevation: Double?
        let gradient: Double?
        let true_course: Double?
        let magnetic_course: Double?
        let threshold_latitude: Double?
        let threshold_longitude: Double?
        let headwind_component: Double?
        let crosswind_component: Double?
        let ils_frequency: String?
    }

    struct Aircraft: Codable {
        let internal_id: String
        let tlr_version: Int?
        let icao: String
        let name: String?
        let engines: String?
        let thrust: stringOrBool?
        let registration: String?
    }

    struct ResultData: Codable {
        let weight: Double?
        let flap_setting: String?
        let thrust_setting: String?
        let bleed_setting: String?
        let anti_ice_setting: String?

        // may be Int or Bool (flex_temperature, max_temperature, max_weight)
        let flex_temperature: intOrBool?
        let max_temperature: intOrBool?
        let climb_optimized: Bool?
        let max_weight: intOrBool?

        let limit_code: String?
        let limit_obstacle: Bool?

        let speeds_v1: intOrBool?
        let speeds_vr: intOrBool?
        let speeds_v2: intOrBool?
        let speeds_v2_id: String?

        let speeds_other: intOrBool?
        let speeds_other_id: stringOrBool?

        let distance_decide: Double?
        let distance_reject: Double?
        let distance_margin: Double?
        let distance_continue: Double?
        let sufficient_runway: Bool?

        let limit_code_short: String?
        let limit_code_long: String?
    }

    struct Remark: Codable {
        let type: String?
        let message: String?
    }
}

nonisolated
struct LDGPerformanceResponse: Codable {
    let inputs: Inputs
    let airport: Airport
    let runway: Runway
    let aircraft: Aircraft
    let result: Result
    let remarks: [Remark]
    let message: String

    struct Inputs: Codable {
        let airport: String
        let runway: String
        let aircraft: String
        let aircraft_data: String?
        let weight: Double
        let runway_shorten: Double?
        let flap_setting: String?
        let brake_setting: String?
        let reverser_credit: String?
        let vref_additive: Int?
        let wind_direction: Double?
        let wind_speed: Double?
        let temperature: Double?
        let altimeter: String?
        let surface_condition: String?
        let weight_units: String?
        let length_units: String?
        let wind_units: String?
        let pressure_units: String?
        let calculation_method: String?
        let margin_method: String?
    }

    struct Airport: Codable {
        let icao: String
        let iata: String?
        let name: String?
        let region: String?
        let latitude: Double?
        let longitude: Double?
        let elevation: Double?
    }

    struct Runway: Codable {
        let identifier: String
        let length: Double?
        let length_tora: Double?
        let length_toda: Double?
        let length_asda: Double?
        let length_lda: Double?
        let width: Double?
        let elevation: Double?
        let gradient: Double?
        let true_course: Double?
        let magnetic_course: Double?
        let threshold_latitude: Double?
        let threshold_longitude: Double?
        let headwind_component: Double?
        let crosswind_component: Double?
        let ils_frequency: String?
    }

    struct Aircraft: Codable {
        let internal_id: String
        let tlr_version: Int?
        let icao: String
        let name: String?
        let engines: String?
        let thrust: String?
        let registration: String?
    }

    struct Result: Codable {
        let weight: Double?
        let flap_setting: String?
        let brake_setting: String?
        let reverser_credit: String?
        let max_weight: Double?
        let limit_code: String?
        let actual_distance: Double?
        let factored_distance: Double?
        let margin_distance: Double?
        let sufficient_runway: Bool?
        let speeds_vref: Int?
        let speeds_vadd: Int?
        let speeds_vapp: Int?
        let limit_code_short: String?
        let limit_code_long: String?
    }

    struct Remark: Codable {
        let type: String?
        let message: String?
    }
}
