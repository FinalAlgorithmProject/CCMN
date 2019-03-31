//
//  NetworkService.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Alamofire
import Moya
import UIKit

final class NCNetworkManager {
    
    typealias RepeatedVisitors = [String: NCRepeatedVisitorsStatisticEntity]
    typealias DWELLTime = [String: NCDWELLStatisticEntity]
    typealias StringIntDictinary = [String: Int]
    
    // Why not?
    static var shared = NCNetworkManager()
    
    static var isHostReachable: Bool {
        let reachablitity = NetworkReachabilityManager(host: "http://captive.apple.com")!
        return reachablitity.isReachable
    }
    
    private init() { }
    
    private var siteId: Int { return NCUserDefaultsService.siteId }
    
    // Custom manager, because unsecure fucking Cisco site and SSL Connection etc ...
    private lazy var manager: Manager = {
        let policies: [String: ServerTrustPolicy] = [
            "cisco-cmx.unit.ua": .disableEvaluation,
            "cisco-presence.unit.ua": .disableEvaluation
        ]
        return Manager(configuration: URLSessionConfiguration.default,
                       serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
    }()
    
    private lazy var provider = MoyaProvider<NCApi>(manager: manager)
    
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        (UIApplication.shared.delegate as! AppDelegate).appCoordinator.window.rootViewController?
            .present(alertController, animated: true, completion: nil)
    }
    
    private func defaultFailureCase(_ error: MoyaError) {
        print(error.errorDescription!)
        showAlert(error.localizedDescription)
    }
}

/// TODO: Change all try! to try?
extension NCNetworkManager {
    
    func siteId(completion: @escaping () -> Void) {
        provider.request(.gettingAesUID) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let results = try! response.map([NCSitesEntity].self)
                if results.isEmpty {
                    self.showAlert("Can't get aesUID :(")
                }
                NCUserDefaultsService.siteId = results[0].aesUId
                print("site id: \(NCUserDefaultsService.siteId)")
                completion()
            case .failure(let error):
                completion()
                self.defaultFailureCase(error)
            }
        }
    }
    
    func allClients(completion: @escaping ([NCClientEntity]?) -> Void) {
        provider.request(.allClients) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map([NCClientEntity].self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func usersOnline(completion: @escaping (Int?) -> Void) {
        provider.request(.numberOfOnlineUsers) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(NCClientsCountEntity.self)
                completion(result?.count)
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
                let countString = try? response.mapString()
                completion(Int(countString ?? ""))
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func campusInformation(completion: @escaping (NCCampusEntity?) -> Void) {
        provider.request(.campusInformation) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(NCCampusEntity.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func repeatedVisitorsInRange(model: NCStatisticRangeEntity,
                                 completion: @escaping (RepeatedVisitors?) -> Void) {
        provider.request(.repeatedVisitorsInRange(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(RepeatedVisitors.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                 self.defaultFailureCase(error)
            }
        }
    }
    
    func repeatedVisitorsForSpecificDate(_ model: NCStatisticDateEntity, completion: @escaping (RepeatedVisitors?) -> Void) {
        provider.request(.repeatedVisitorsForSpecificDate(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(RepeatedVisitors.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func dwellInRange(model: NCStatisticRangeEntity, completion: @escaping (DWELLTime?) -> Void) {
        provider.request(.dwellInRange(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(DWELLTime.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func dwellForSpecificDate(_ model: NCStatisticDateEntity, completion: @escaping (DWELLTime?) -> Void) {
        provider.request(.dwellForSpecificDate(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(DWELLTime.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func passerbyInRange(model: NCStatisticRangeEntity, completion: @escaping (StringIntDictinary?) -> Void) {
        provider.request(.passerbyInRange(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(StringIntDictinary.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func passerbyForSpecificDate(_ model: NCStatisticDateEntity, completion: @escaping (StringIntDictinary?) -> Void) {
        provider.request(.passerbyForSpecificDate(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(StringIntDictinary.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func connectedInRange(model: NCStatisticRangeEntity, completion: @escaping (StringIntDictinary?) -> Void) {
        provider.request(.connectedVisitorsInRange(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(StringIntDictinary.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func connectedForSpecificDate(_ model: NCStatisticDateEntity, completion: @escaping (StringIntDictinary?) -> Void) {
        provider.request(.connectedVisitorsForSpecificDate(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(StringIntDictinary.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func visitorsInRange(model: NCStatisticRangeEntity, completion: @escaping (StringIntDictinary?) -> Void) {
        provider.request(.visitorsInRange(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(StringIntDictinary.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func visitorsForSpecificDate(_ model: NCStatisticDateEntity, completion: @escaping (StringIntDictinary?) -> Void) {
        provider.request(.visitorsForSpecificDate(model: model)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map(StringIntDictinary.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func todayKPI(completion: @escaping (NCKpiStatisticEntity?) -> Void) {
        provider.request(.todayKPI(siteId: siteId)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try! response.map(NCKpiStatisticEntity.self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
   
    func searchUser(byMacAddress macAddress: String, completion: @escaping ([NCClientEntity]?) -> Void) {
        provider.request(.searchUserByMacAddress(macAddress: macAddress)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map([NCClientEntity].self) // nil if not found
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func searchUser(byUsername username: String, completion: @escaping ([NCClientEntity]?) -> Void) {
        provider.request(.searchUserByName(name: username)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let result = try? response.map([NCClientEntity].self)
                completion(result)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
    
    func floorImageName(by campusInfo: NCCampusImportantInfo, floorName: String, completion: @escaping (UIImage?) -> Void) {
        let floorImageCase = NCApi.floorImageName(campusName: campusInfo.campusName,
                                                  buildingName: campusInfo.buildingName,
                                                  floorName: floorName)
        provider.request(floorImageCase) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let image = try? response.mapImage()
                completion(image)
            case .failure(let error):
                completion(nil)
                self.defaultFailureCase(error)
            }
        }
    }
}
































