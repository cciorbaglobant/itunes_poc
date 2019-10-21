//
//  SearchResultsTableViewCell.swift
//  itunes-poc
//
//  Created by Cornel on 21/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import UIKit
import Bond
import AlamofireImage

class SearchResultsTableViewCell: UITableViewCell, UIViewModelBindableProtocol {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Lifecycle
    
    deinit {
        bag.dispose()
    }
    
    //MARK: - UIViewModelBindableProtocol
    
    typealias ViewModel = SearchResultsTableViewCellModel
    var viewModel: SearchResultsTableViewCellModel? {
        didSet {
            self.bag.dispose()
            setupBindings()
        }
    }
    
    func setupBindings() {
        guard let vm = viewModel else { return }
        
        vm.leftImageURL.observeNext { [weak self] (value) in
            if let v = value {
                self?.leftImageView.af_setImage(withURL: v)
            } else {
                // Placeholder image
            }
        }.dispose(in: self.bag)
        
        vm.title.observeNext { [weak self] (value) in
            self?.titleLabel.text = value
        }.dispose(in: self.bag)
        
        vm.subtitle.observeNext { [weak self] (value) in
            self?.subtitleLabel.text = value
        }.dispose(in: self.bag)
    }
}

class SearchResultsTableViewCellModel {
    let leftImageURL = Observable<URL?>(nil)
    let title = Observable<String?>(nil)
    let subtitle = Observable<String?>(nil)
    var previewUrl:URL?
}
