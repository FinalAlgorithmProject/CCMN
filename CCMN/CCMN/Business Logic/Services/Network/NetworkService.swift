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
    
    typealias RepeatedVisitors = [String: RepeatedVisitorsStatisticEntity]?
    typealias DWELLTime = [String: DWELLStatisticEntity]?
    typealias Passerby = [String: Int]?
    
    // Why not?
    static var shared = NetworkManager()
    private init() { }
    
    var siteId: Int { return UserDefaultsService.siteId }
    
    // Custom manager, because unsecure fucking Cisco site and SSL Connection etc ...
    private lazy var manager: Manager = {
        let policies: [String: ServerTrustPolicy] = [
            "cisco-cmx.unit.ua": .disableEvaluation,
            "cisco-presence.unit.ua": .disableEvaluation
        ]
        return Manager(configuration: URLSessionConfiguration.default,
                       serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
    }()
    
    // Provider part
    private lazy var provider = MoyaProvider<CCMNApi>(manager: manager,
                                                      plugins: [NetworkLoggerPlugin(verbose: true)])

    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Unknown Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        (UIApplication.shared.delegate as! AppDelegate).window?
            .rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

/// TODO: Change all try! to try?
extension NetworkManager {
    
    func siteId(completion: @escaping () -> Void) {
        provider.request(.gettingAesUID) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let results = try! response.map([SitesEntity].self)
                if results.isEmpty {
                    self.showAlert("Can't get aesUID :(")
                }
                UserDefaultsService.siteId = results[0].aesUId
                print("site id: \(UserDefaultsService.siteId)")
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
                let result = try! response.map(ClientsCountEntity.self)
                completion(result.count)
            case .failure(let error):
                print(error.errorDescription!)
                completion(0)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
    func todayVisitors(completion: @escaping (Int) -> Void) {
        provider.request(.todayVisitors(siteId: siteId)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let countString = try! response.mapString()
                completion(Int(countString)!)
            case .failure(let error):
                print(error.errorDescription!)
                completion(0)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
    func campusInformation(completion: @escaping (CampusEntity?) -> Void) {
        provider.request(.campusInformation) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(CampusEntity.self)
                completion(result)
            case .failure(let error):
                print(error.errorDescription!)
                completion(nil)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
    func repeatedVisitorsInRange(fromDate startDate: String,
                                 to endDate: String?,
                                 completion: @escaping (RepeatedVisitors) -> Void) {
        provider.request(.repeatedVisitorsInRange(siteId: siteId, startDate: startDate, endDate: endDate)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(RepeatedVisitors.self)
                completion(result)
            case .failure(let error):
                print(error.errorDescription!)
                completion(nil)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
    func repeatedVisitorsForSpecificDate(_ date: String, completion: @escaping (RepeatedVisitors) -> Void) {
        provider.request(.repeatedVisitorsForSpecificDate(siteId: siteId, date: date)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(RepeatedVisitors.self)
                completion(result)
            case .failure(let error):
                print(error.errorDescription!)
                completion(nil)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
    func dwellInRange(fromDate startDate: String,
                      to endDate: String?, completion: @escaping (DWELLTime) -> Void) {
        provider.request(.dwellInRange(siteId: siteId, startDate: startDate, endDate: endDate)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(DWELLTime.self)
                completion(result)
            case .failure(let error):
                print(error.errorDescription!)
                completion(nil)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
    func dwellForSpecificDate(_ date: String, completion: @escaping (DWELLTime) -> Void) {
        provider.request(.dwellForSpecificDate(siteId: siteId, date: date)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(DWELLTime.self)
                completion(result)
            case .failure(let error):
                print(error.errorDescription!)
                completion(nil)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
    func passerbyInRange(fromDate startDate: String,
                         to endDate: String?, completion: @escaping (Passerby) -> Void) {
        provider.request(.passerbyInRange(siteId: siteId, startDate: startDate, endDate: endDate)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(Passerby.self)
                completion(result)
            case .failure(let error):
                print(error.errorDescription!)
                completion(nil)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
    func passerbyForSpecificDate(_ date: String, completion: @escaping (Passerby) -> Void) {
        provider.request(.passerbyForSpecificDate(siteId: siteId, date: date)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(Passerby.self)
                completion(result)
            case .failure(let error):
                print(error.errorDescription!)
                completion(nil)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
}
































