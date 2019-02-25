//
//  NetworkService.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import Moya

final class NetworkManager {
    
    // Why not?
    static var shared = NetworkManager()
    private init() { }
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    var siteId: Int {
        return UserDefaultsService.siteId
    }
    
    // Provider part
    private lazy var provider = MoyaProvider<CCMNApi>(manager: manager,
                                                      plugins: [NetworkLoggerPlugin(verbose: true)])

    // Custom manager, because unsecure fucking Cisco site and SSL Connection etc ...
    private lazy var manager: Manager = {
        let policies: [String: ServerTrustPolicy] = [
            "cisco-cmx.unit.ua": .disableEvaluation,
            "cisco-presence.unit.ua": .disableEvaluation
        ]
        return Manager(configuration: URLSessionConfiguration.default,
                       serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
    }()
    
    private func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Unknown Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        (UIApplication.shared.delegate as! AppDelegate).window?
            .rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func defaultFailureCase(_ error: MoyaError) {
        showAlert(error.localizedDescription)
    }
}


extension NetworkManager: NetworkManagerProtocol {
    
    func siteId(completion: @escaping () -> Void) {
        provider.request(.gettingAesUID) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let results = try! self.decoder.decode([SitesEntity].self, from: response.data)
                if results.isEmpty {
                    self.showAlert("Can't get aesUID :(")
                }
                UserDefaultsService.siteId = results[0].aesUId
                completion()
            case .failure(let error):
                completion()
                self.defaultFailureCase(error)
            }
        }
    }
    
    func usersOnline(completion: @escaping (Int) -> Void) {
        provider.request(.numberOfOnlineUsers) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! self.decoder.decode(ClientsCountEntity.self, from: response.data)
                completion(result.count)
            case .failure(let error):
                completion(0)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func todayVisitors(completion: @escaping (Int) -> Void) {
        provider.request(.todayVisitors(siteId: siteId)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let countString = String(bytes: response.data, encoding: .utf8) ?? "0"
                completion(Int(countString)!)
            case .failure(let error):
                completion(0)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func campusInformation(completion: @escaping (CampusEntity?) -> Void) {
        provider.request(.campusInformation) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? self.decoder.decode(CampusEntity.self, from: response.data)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    
    
    
}

