//
//  SearchViewController.swift
//  itunes-poc
//
//  Created by Cornel on 21/10/2019.
//  Copyright (c) 2019 Globant. All rights reserved.
//

// MARK: - Imports

import UIKit

// MARK: - SearchViewController

class SearchViewController: UIViewController, ViewControllerDisplayAlertProtocol {
    
    // MARK: - Properties
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    private enum SegueNames:String {
        case displaySearchResults = "displaySearchResults"
    }
    
    private lazy var viewModel: SearchViewModelProtocol = {
        return SearchViewModel(repository: SearchRepository())
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.\
        self.setupBindings()
    }
    
    deinit {
        self.bag.dispose()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let i = segue.identifier else {
            assertionFailure("Segue Identifier is nil")
            return
        }
        guard let s = SegueNames(rawValue: i) else {
            assertionFailure("Segue Identifier is not declared in SegueNames enum")
            return
        }
        
        switch s {
        case .displaySearchResults:
            guard let destVC = segue.destination as? SearchResultsTableViewController else {
                return
            }
            destVC.viewModel.setupForResponseData(data: sender as? [SearchReponseData.Result])
            break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        guard let text = self.searchTextField.text else {
            return
        }
        
        self.viewModel.searchFor(searchString: text)
    }
    
    
    
    // MARK: - Private methods
    
    private func setupBindings() {
        viewModel.navigationCommands.observeNext { [weak self](value) in
            switch value {
            case .goToResults(let results):
                let segueIdentifier = SegueNames.displaySearchResults.rawValue
                self?.performSegue(withIdentifier: segueIdentifier, sender: results)
                break
            
            case .none:
                break
            }
        }.dispose(in: self.bag)
        
        viewModel.searchErrorMessage.observeNext { [weak self] (value) in
            guard let v = value else { return }
            self?.displayOKErrorAlert(message: v)
        }.dispose(in: self.bag)
    }

}
