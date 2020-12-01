//
//  UIViewExt.swift
//  Test
//
//  Created by Galym Anuarbek on 10/18/20.
//  Copyright © 2020 Galym Anuarbek. All rights reserved.
//

import UIKit

extension UIView {
    private static var _extVars = [String:UIView]()
    
    var vSpinner: UIView? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIView._extVars[tmpAddress]
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIView._extVars[tmpAddress] = newValue
        }
    }
    
    func showSpinner() {
        if self.vSpinner == nil {
            let spinnerView = UIView.init(frame: self.bounds)
            spinnerView.backgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
            let ai = UIActivityIndicatorView.init(style: .large)
            ai.startAnimating()
            ai.center = spinnerView.center
            
            DispatchQueue.main.async {
                spinnerView.addSubview(ai)
                self.addSubview(spinnerView)
                spinnerView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            
            vSpinner = spinnerView
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
