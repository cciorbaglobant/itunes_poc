//
//  ViewControllerDisplayAlertProtocol.swift
//  itunes-poc
//
//  Created by Cornel on 21/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import Foundation
import UIKit

private let errorTitleString = NSLocalizedString("Error", comment: "Alert error title")
private let okBtnString = NSLocalizedString("Ok", comment: "Alert OK button")

protocol ViewControllerDisplayAlertProtocol where Self:UIViewController {
    func displayOKAlert(title:String, message:String)
    func displayOKErrorAlert(message:String)
}

extension ViewControllerDisplayAlertProtocol {
    // Simple OK Alert
    func displayOKAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okBtnString, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    // OK Alert with default error title
    func displayOKErrorAlert(message:String) {
        self.displayOKAlert(title: errorTitleString, message: message)
    }
}
