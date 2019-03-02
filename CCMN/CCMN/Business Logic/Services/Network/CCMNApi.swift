//
//  CCMNApi.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation
import Moya

enum CCMNApi {
    case gettingAesUID
    case numberOfOnlineUsers
    case todayVisitors(siteId: Int)
    case campusInformation
    
    case repeatedVisitorsInRange(siteId: Int, startDate: String, endDate: String?)
    case repeatedVisitorsForSpecificDate(siteId: Int, date: String)
    
    case dwellInRange(siteId: Int, startDate: String, endDate: String?)
    case dwellForSpecificDate(siteId: Int, date: String)
    
    case passerbyInRange(siteId: Int, startDate: String, endDate: String?)
    case passerbyForSpecificDate(siteId: Int, date: String)
    
    
    // ------------------------------------- Custom properties -------------------------------------
    var environmentHeaders: String {
        switch self {
        case .numberOfOnlineUsers, .campusInformation:
            let data = "\(ApplicationConstants.cmxUsername):\(ApplicationConstants.cmxPassword)".data(using: .utf8)!
            return "Basic \(data.base64EncodedString())"
        case .gettingAesUID, .todayVisitors,
             .repeatedVisitorsInRange, .repeatedVisitorsForSpecificDate,
             .dwellForSpecificDate, .dwellInRange,
             .passerbyInRange, .passerbyForSpecificDate:
            let data = "\(ApplicationConstants.presenceUsername):\(ApplicationConstants.presencePassword)".data(using: .utf8)!
            return "Basic \(data.base64EncodedString())"
        }
    }
    
    var environmentBaseURL: String {
        switch self {
        case .numberOfOnlineUsers, .campusInformation:
            return ApplicationConstants.cmxURLString
        case .gettingAesUID, .todayVisitors,
             .repeatedVisitorsInRange, .repeatedVisitorsForSpecificDate,
             .dwellInRange, .dwellForSpecificDate,
             .passerbyInRange, .passerbyForSpecificDate:
            return ApplicationConstants.presenceURLString
        }
    }
}

extension CCMNApi: TargetType {
    
    // Protocols properties
    var baseURL: URL {
        return URL(string: environmentBaseURL)!
    }
    
    var path: String {
        switch self {
        case .gettingAesUID:
            return "/api/config/v1/sites"
        case .numberOfOnlineUsers:
            return "/api/location/v2/clients/count"
        case .todayVisitors:
            return "/api/presence/v1/connected/count/today"
        case .campusInformation:
            return "/api/config/v1/maps/count"
        case .repeatedVisitorsInRange:
            return "/api/presence/v1/repeatvisitors/daily"
        case .repeatedVisitorsForSpecificDate:
            return "/api/presence/v1/repeatvisitors/hourly"
        case .dwellInRange:
            return "/api/presence/v1/dwell/daily"
        case .dwellForSpecificDate:
            return "/api/presence/v1/dwell/hourly"
        case .passerbyInRange:
            return "/api/presence/v1/passerby/daily"
        case .passerbyForSpecificDate:
            return "/api/presence/v1/passerby/hourly"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .gettingAesUID, .numberOfOnlineUsers, .campusInformation:
            return Task.requestPlain
        case .todayVisitors(let siteId):
            return Task.requestParameters(parameters: ["siteId": siteId], encoding: URLEncoding.queryString)
        case let .repeatedVisitorsInRange(siteId, startDate, endDate),
             let .dwellInRange(siteId, startDate, endDate),
             let .passerbyInRange(siteId, startDate, endDate):
            return Task.requestParameters(parameters: ["siteId": siteId, "startDate": startDate, "endDate": endDate ?? ""],
                                          encoding: URLEncoding.queryString)
        case let .repeatedVisitorsForSpecificDate(siteId, date),
             let .dwellForSpecificDate(siteId, date),
             let .passerbyForSpecificDate(siteId, date):
            return Task.requestParameters(parameters: ["siteId": siteId, "date": date],
                                          encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": environmentHeaders,
            "Content-Type": "application/json"
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
