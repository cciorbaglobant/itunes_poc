//
//  UIViewModelBindableProtocol.swift
//  itunes-poc
//
//  Created by Cornel on 21/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import Foundation

import ReactiveKit

protocol UIViewModelBindableProtocol where Self: NSObject {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
    
    func setupBindings() -> Void
}
