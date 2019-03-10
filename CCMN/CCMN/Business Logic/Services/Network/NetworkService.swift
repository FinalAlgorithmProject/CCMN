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
    typealias StringIntDictinary = [String: Int]?
    
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
                                                      plugins: [])

    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        (UIApplication.shared.delegate as! AppDelegate).window?
            .rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func defaultFailureCase(_ error: MoyaError) {
        print(error.errorDescription!)
        showAlert(error.localizedDescription)
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
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion()
                self.defaultFailureCase(error)
            }
        }
    }
    
    func usersOnline(completion: @escaping (Int?) -> Void) {
        provider.request(.numberOfOnlineUsers) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(ClientsCountEntity.self)
                completion(result.count)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func todayVisitors(completion: @escaping (Int?) -> Void) {
        provider.request(.todayVisitors(siteId: siteId)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let countString = try! response.mapString()
                completion(Int(countString)!)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
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
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func repeatedVisitorsInRange(model: StatisticRangeEntity,
                                 completion: @escaping (RepeatedVisitors) -> Void) {
        provider.request(.repeatedVisitorsInRange(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(RepeatedVisitors.self)
                completion(result)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                 self.defaultFailureCase(error)
            }
        }
    }
    
    func repeatedVisitorsForSpecificDate(_ model: StatisticDateEntity, completion: @escaping (RepeatedVisitors) -> Void) {
        provider.request(.repeatedVisitorsForSpecificDate(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(RepeatedVisitors.self)
                completion(result)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func dwellInRange(model: StatisticRangeEntity, completion: @escaping (DWELLTime) -> Void) {
        provider.request(.dwellInRange(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(DWELLTime.self)
                completion(result)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func dwellForSpecificDate(_ model: StatisticDateEntity, completion: @escaping (DWELLTime) -> Void) {
        provider.request(.dwellForSpecificDate(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(DWELLTime.self)
                completion(result)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func passerbyInRange(model: StatisticRangeEntity, completion: @escaping (StringIntDictinary) -> Void) {
        provider.request(.passerbyInRange(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(StringIntDictinary.self)
                completion(result)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func passerbyForSpecificDate(_ model: StatisticDateEntity, completion: @escaping (StringIntDictinary) -> Void) {
        provider.request(.passerbyForSpecificDate(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(StringIntDictinary.self)
                completion(result)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func connectedInRange(model: StatisticRangeEntity, completion: @escaping (StringIntDictinary) -> Void) {
        provider.request(.connectedVisitorsInRange(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(StringIntDictinary.self)
                completion(result)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func connectedForSpecificDate(_ model: StatisticDateEntity, completion: @escaping (StringIntDictinary) -> Void) {
        provider.request(.connectedVisitorsForSpecificDate(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(StringIntDictinary.self)
                completion(result)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func visitorsInRange(model: StatisticRangeEntity, completion: @escaping (StringIntDictinary) -> Void) {
        provider.request(.visitorsInRange(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(StringIntDictinary.self)
                completion(result)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func visitorsForSpecificDate(_ model: StatisticDateEntity, completion: @escaping (StringIntDictinary) -> Void) {
        provider.request(.visitorsForSpecificDate(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(StringIntDictinary.self)
                completion(result)
                print("Request ✅ SUCCESS")
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func todayKPI(completion: @escaping () -> Void) {
        provider.request(.todayKPI(siteId: siteId)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(KpiStatisticEntity.self)
                print("Request ✅ SUCCESS")
                completion()
            case .failure(let error):
                completion()
                self.defaultFailureCase(error)
            }
        }
    }
    
    func searchUser(byMacAddress macAddress: String, completion: @escaping () -> Void) {
        provider.request(.searchUserByMacAddress(macAddress: macAddress)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.mapJSON() // nil if not found
                print("Request ✅ SUCCESS")
                completion()
            case .failure(let error):
                completion()
                self.defaultFailureCase(error)
            }
        }
    }
    
    func searchUser(byUsername username: String, completion: @escaping () -> Void) {
        provider.request(.searchUserByName(name: username)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.mapJSON() // empty if not found
                print("Request ✅ SUCCESS")
                completion()
            case .failure(let error):
                completion()
                self.defaultFailureCase(error)
            }
        }
    }
    
}
































