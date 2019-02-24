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
}

extension CCMNApi: TargetType {
    
    var environmentHeaders: String {
        switch self {
        case .numberOfOnlineUsers:
            let data = "\(ApplicationConstants.cmxUsername):\(ApplicationConstants.cmxPassword)".data(using: .utf8)!
            return "Basic \(data.base64EncodedString())"
        case .gettingAesUID:
            let data = "\(ApplicationConstants.presenceUsername):\(ApplicationConstants.presencePassword)".data(using: .utf8)!
            return "Basic \(data.base64EncodedString())"
        }
    }
    
    var environmentBaseURL: String {
        switch self {
        case .numberOfOnlineUsers:
            return ApplicationConstants.cmxURLString
        case .gettingAesUID:
            return ApplicationConstants.presenceURLString
        }
    }
    
    var baseURL: URL {
        return URL(string: environmentBaseURL)!
    }
    
    var path: String {
        switch self {
        case .gettingAesUID:
            return "/api/config/v1/sites"
        case .numberOfOnlineUsers:
            return "/api/location/v2/clients/count"
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
        case .gettingAesUID, .numberOfOnlineUsers:
            return Task.requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": environmentHeaders,
            "Content-type": "application/json"
        ]
    }
    
    
}
