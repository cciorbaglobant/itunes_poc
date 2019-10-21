//
//  SearchServiceProtocol.swift
//  itunes-poc
//
//  Created by Cornel on 21/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import Foundation
import Alamofire

class SearchReponseData: Decodable {
    let results: [Result]?
    
    class Result: Decodable {
        let artistName: String?
        let trackName: String?
        let previewUrl: URL?
        let artworkUrl60: URL?
    }
}

protocol SearchServiceProtocol {
    func searchFor(searchTerm:String, completion: @escaping(_ success:Bool, _ message:String?, _ data: SearchReponseData?) -> Void) -> Void
}

extension SearchServiceProtocol {
    func searchFor(searchTerm:String, completion: @escaping(_ success:Bool, _ message:String?, _ data: SearchReponseData?) -> Void) -> Void {
        
        /*
         Documentation: https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/
         */
        let endpoint = "https://itunes.apple.com/search?"
        
        let terms = searchTerm.replacingOccurrences(of: " ", with: "+")
        
        let params:Parameters = ["term":terms,
                                 "limit":"25"]
        
        Alamofire.request(endpoint,
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    do {
                        let searchResponse = try JSONDecoder().decode(SearchReponseData.self, from: response.data!)
                        completion(true, nil, searchResponse)
                    } catch let error {
                         completion(false, error.localizedDescription, nil)
                    }
                    break
                case .failure:
                    completion(false, response.error?.localizedDescription, nil)
                    break
                }
        }
        
    }
}
