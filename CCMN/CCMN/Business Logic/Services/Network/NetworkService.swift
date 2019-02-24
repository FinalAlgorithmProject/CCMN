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

enum ApiEnvironment {
    case cmx
    case presence
}

final class NetworkManager {
    
    // Why not?
    static var shared = NetworkManager()
    private init() { }
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
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
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Unknown Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        (UIApplication.shared.delegate as! AppDelegate).window?
            .rootViewController?.present(alertController, animated: true, completion: nil)
    }
}


extension NetworkManager: NetworkManagerProtocol {
    
    func getAesUID(completion: @escaping () -> Void) {
        provider.request(.gettingAesUID) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let results = try! self.decoder.decode([SitesEntity].self, from: response.data)
                if results.isEmpty {
                    self.showAlert("Can't get aesUID :(")
                }
                UserDefaultsService.aesUID = results[0].aesUidString
                completion()
            case .failure(let error):
                completion()
                self.showAlert(error.localizedDescription)
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
                print(error.errorDescription!)
                completion(0)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
    
}

