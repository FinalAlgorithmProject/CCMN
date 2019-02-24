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
    
    
    // Custom properties
    var environmentHeaders: String {
        switch self {
        case .numberOfOnlineUsers, .campusInformation:
            let data = "\(ApplicationConstants.cmxUsername):\(ApplicationConstants.cmxPassword)".data(using: .utf8)!
            return "Basic \(data.base64EncodedString())"
        case .gettingAesUID, .todayVisitors:
            let data = "\(ApplicationConstants.presenceUsername):\(ApplicationConstants.presencePassword)".data(using: .utf8)!
            return "Basic \(data.base64EncodedString())"
        }
    }
    
    var environmentBaseURL: String {
        switch self {
        case .numberOfOnlineUsers, .campusInformation:
            return ApplicationConstants.cmxURLString
        case .gettingAesUID, .todayVisitors:
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
        }
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": environmentHeaders,
            "Content-type": "application/json"
        ]
    }
}
