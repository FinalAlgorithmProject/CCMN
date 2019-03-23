//
//  FloorModel.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/16/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit.UIImage

final class FloorModel {
    
    let network: NCNetworkManager
    let floorName: String
    let campusInfo: NCCampusImportantInfo?
    
    init(network: NCNetworkManager, floorName: String, campusInfo: NCCampusImportantInfo?) {
        self.network = network
        self.floorName = floorName
        self.campusInfo = campusInfo
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        guard let campus = campusInfo else { completion(nil); return }
        network.floorImageName(by: campus, floorName: floorName, completion: completion)
    }
}
