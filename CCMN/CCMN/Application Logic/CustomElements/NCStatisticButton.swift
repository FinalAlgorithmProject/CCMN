//
//  NCStatisticButton.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/17/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

class NCStatisticButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    private func customInit() {
        layer.cornerRadius = 10
        backgroundColor = NCApplicationConstants.mainRedColor
        
        setTitleColor(.white, for: .normal)
        titleLabel?.font = NCApplicationConstants.medium21
    }


}
