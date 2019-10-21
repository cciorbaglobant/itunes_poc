//
//  SearchResultsTableViewController.swift
//  itunes-poc
//
//  Created by Cornel on 21/10/2019.
//  Copyright (c) 2019 Globant. All rights reserved.
//

// MARK: - Imports

import UIKit
import AVKit

// MARK: - SearchResultsTableViewController

class SearchResultsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private enum SegueNames: String {
        case displayPlayer = "displayPlayer"
    }
    
    lazy var viewModel: SearchResultsViewModelProtocol = {
        return SearchResultsViewModel(repository: SearchResultsRepository())
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
        case .displayPlayer:
            guard let destVC = segue.destination as? AVPlayerViewController else { return }
            let m = sender as? SearchResultsTableViewCellModel
            
            let player = AVPlayer(url: m!.previewUrl!)
            destVC.player = player
            destVC.player?.play()
            break
        }
    }
    
    // MARK: - Private methods
    
    private func setupBindings() {
        viewModel.navigationCommands.observeNext { (value) in
            switch value {
            case .none:
                break
            }
        }.dispose(in: self.bag)
        
        viewModel.resultModels.observeNext { [weak self] (value) in
            self?.tableView.reloadData()
        }.dispose(in: self.bag)
    }
}

// MARK: - UITableView Delegate and DataSource

extension SearchResultsTableViewController {
    
    // DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! SearchResultsTableViewCell
        cell.viewModel = viewModel.resultModels.value![indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.resultModels.value?.count ?? 0
    }
    
    // Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.resultModels.value![indexPath.row]
        
        self.performSegue(withIdentifier: SegueNames.displayPlayer.rawValue, sender: model)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
