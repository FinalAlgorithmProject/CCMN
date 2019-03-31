//
//  Toastable.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

protocol Toastable: class {
    func showToastLabel(with message: String, backgroundColor: UIColor?)
    func showNoInternetLabel()
}

extension Toastable where Self: UIViewController {
    func showToastLabel(with message: String, backgroundColor: UIColor? = UIColor.toastBackground) {
        showToast(with: message, backgroundColor: backgroundColor)
    }
    func showNoInternetLabel() {
        showNoInternetConnectionToast()
    }
}

private extension UIViewController {
    func showToast(with message: String, backgroundColor: UIColor?) {
        if view.viewWithTag(10) != nil { return } // Little hack
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        /// What a hack? it was working with statusBarHeight
        let viewY = statusBarHeight //-navigationBarHeight //
        let viewHeight = navigationBarHeight
        
        let labelY: CGFloat = 0
        let labelHeight = viewHeight
        
        let animationMovingHeight = navigationBarHeight
        
        let toastView = UIView(frame: CGRect(x: 0, y: viewY, width: UIScreen.main.bounds.width, height: viewHeight))
        toastView.backgroundColor = backgroundColor
        toastView.clipsToBounds = true
        let toastLabel = UILabel(frame: CGRect(x: 0, y: labelY, width: UIScreen.main.bounds.width, height: labelHeight))
        toastLabel.tag = 10
        toastLabel.font = NCApplicationConstants.medium17
        toastLabel.backgroundColor = .clear
        toastLabel.textColor = UIColor.white
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.lineBreakMode = .byTruncatingTail
        toastView.addSubview(toastLabel)
        view.addSubview(toastView)
        view.bringSubview(toFront: toastView)
        
        UIView.animate(withDuration: 0.25, delay: 0.25, options: [.curveEaseInOut], animations: {
            toastView.transform = CGAffineTransform(translationX: 0, y: animationMovingHeight)
        }, completion: nil)
        UIView.animate(withDuration: 0.25, delay: 4.0, options: [.curveEaseInOut], animations: {
            toastView.transform = .identity
        }) { _ in toastView.removeFromSuperview() }
    }
    
    func showNoInternetConnectionToast() {
        let backgroundColor = UIColor.warningRedColor.withAlphaComponent(0.9)
        showToast(with: "No Internet connection", backgroundColor: backgroundColor)
    }
}
