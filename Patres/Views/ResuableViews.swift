//
//  reusableViews.swift
//  Patres
//
//  Created by Marwa Awad on 22.03.2025.
//

import UIKit

class ResuableViews: UIView {
    
    static let shared:  ResuableViews = ResuableViews()
    
    func showNetworkErrorAlert(from viewController: UIViewController) {
        print("should show the alert")
        let alertController = UIAlertController(title: "Network Error", message: "No internet connection. and you don't have any posts to show! Try again later.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
