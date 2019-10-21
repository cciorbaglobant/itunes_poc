//
//  SearchViewModel.swift
//  itunes-poc
//
//  Created by Cornel on 21/10/2019.
//  Copyright (c) 2019 Globant. All rights reserved.
//

// MARK: - Imports

import Foundation
import Bond

protocol SearchViewModelProtocol {
    init(repository: SearchRepositoryProtocol)
    var navigationCommands: Observable<SearchViewModel.NavigationCommand> { get }
    var searchErrorMessage: Observable<String?> { get }
    
    func searchFor(searchString:String) -> Void
}

class SearchViewModel: SearchViewModelProtocol {
    
    // MARK: - Init
    
    private var repository: SearchRepositoryProtocol
    required init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Navigation
    
    enum NavigationCommand {
        case none
        case goToResults(results:[SearchReponseData.Result])
    }
    let navigationCommands = Observable<SearchViewModel.NavigationCommand>(.none)
    let searchErrorMessage = Observable<String?>(nil)
    
    // MARK: - Public methods
    
    func searchFor(searchString:String) -> Void {
        guard searchString.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            self.searchErrorMessage.value = "Please enter at least one character"
            return
        }
        
        self.repository.searchFor(searchTerm: searchString) { [weak self] (success, message, data) in
            guard let s = self else { return }
            
            if success {
                if let r = data?.results, r.count > 0 {
                    s.navigationCommands.value = SearchViewModel.NavigationCommand.goToResults(results: r)
                } else {
                    s.searchErrorMessage.value = "No matches found. Please try again."
                }
            } else {
                s.searchErrorMessage.value = message
            }
        }
    }
}
