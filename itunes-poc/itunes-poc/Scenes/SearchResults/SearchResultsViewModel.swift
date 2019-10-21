//
//  SearchResultsViewModel.swift
//  itunes-poc
//
//  Created by Cornel on 21/10/2019.
//  Copyright (c) 2019 Globant. All rights reserved.
//

// MARK: - Imports

import Foundation
import Bond

protocol SearchResultsViewModelProtocol {
    init(repository: SearchResultsRepositoryProtocol)
    var navigationCommands: Observable<SearchResultsViewModel.NavigationCommand> { get }
    
    func setupForResponseData(data:[SearchReponseData.Result]?)
    var resultModels: Observable<[SearchResultsTableViewCellModel]?> { get }
}

class SearchResultsViewModel: SearchResultsViewModelProtocol {
    
    // MARK: - Init
    
    private var repository: SearchResultsRepositoryProtocol
    required init(repository: SearchResultsRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Navigation
    
    enum NavigationCommand {
        case none
    }
    var navigationCommands = Observable<SearchResultsViewModel.NavigationCommand>(.none)
    
    func setupForResponseData(data:[SearchReponseData.Result]?) {
        self.resultModels.value = data?.map({ (result) -> SearchResultsTableViewCellModel in
            let model = SearchResultsTableViewCellModel()
            model.leftImageURL.value = result.artworkUrl60
            model.title.value = result.artistName
            model.subtitle.value = result.trackName
            model.previewUrl = result.previewUrl
            return model
        })
    }
    var resultModels = Observable<[SearchResultsTableViewCellModel]?>(nil)
}
