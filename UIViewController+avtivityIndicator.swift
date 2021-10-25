//
//  UIViewController+avtivityIndicator.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/23/21.
//

import UIKit

fileprivate var aView: UIView?

extension UIViewController {
     
    func showMySpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.25, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let myActivityIndicator = UIActivityIndicatorView(style: .large)
        myActivityIndicator.center = aView!.center
        myActivityIndicator.color = .black
        myActivityIndicator.startAnimating()
        aView?.addSubview(myActivityIndicator)
        self.view.addSubview(aView!)
        
    }
    
    func removeMySpenner() {
        aView?.removeFromSuperview()
        aView = nil
    }
    
    
    
}


