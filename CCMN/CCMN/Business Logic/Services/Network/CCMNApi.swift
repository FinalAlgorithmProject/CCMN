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
    
    case repeatedVisitorsInRange(model: StatisticRangeEntity)
    case repeatedVisitorsForSpecificDate(model: StatisticDateEntity)
    
    case dwellInRange(model: StatisticRangeEntity)
    case dwellForSpecificDate(model: StatisticDateEntity)

    case passerbyInRange(model: StatisticRangeEntity)
    case passerbyForSpecificDate(model: StatisticDateEntity)

    case connectedVisitorsInRange(model: StatisticRangeEntity)
    case connectedVisitorsForSpecificDate(model: StatisticDateEntity)
    
    
    // ------------------------------------- Custom properties -------------------------------------
    var environmentHeaders: String {
        switch self {
        case .numberOfOnlineUsers, .campusInformation:
            let data = "\(ApplicationConstants.cmxUsername):\(ApplicationConstants.cmxPassword)".data(using: .utf8)!
            return "Basic \(data.base64EncodedString())"
        case .gettingAesUID, .todayVisitors,
             .repeatedVisitorsInRange, .repeatedVisitorsForSpecificDate,
             .dwellForSpecificDate, .dwellInRange,
             .passerbyInRange, .passerbyForSpecificDate,
             .connectedVisitorsInRange, .connectedVisitorsForSpecificDate:
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
             .passerbyInRange, .passerbyForSpecificDate,
             .connectedVisitorsInRange, .connectedVisitorsForSpecificDate:
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
        case .connectedVisitorsInRange:
            return "/api/presence/v1/connected/daily"
        case .connectedVisitorsForSpecificDate:
            return "/api/presence/v1/connected/hourly"
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
        case let .repeatedVisitorsInRange(model),
             let .dwellInRange(model),
             let .passerbyInRange(model),
             let .connectedVisitorsInRange(model):
            
            return Task.requestParameters(parameters: ["siteId": model.siteId, "startDate": model.startDate, "endDate": model.endDate ?? ""],
                                          encoding: URLEncoding.queryString)
        case let .repeatedVisitorsForSpecificDate(model),
             let .dwellForSpecificDate(model),
             let .passerbyForSpecificDate(model),
             let .connectedVisitorsForSpecificDate(model):
            
            return Task.requestParameters(parameters: ["siteId": model.siteId, "date": model.date],
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
