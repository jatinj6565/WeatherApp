//
//  LocationSearchViewModel.swift
//  WeatherPOC
//
//  Created by Jatin Patel on 8/21/24.
//

import Foundation
import SwiftUI
import Combine

class LocationSearchViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var searchData : [SearchResponse] = []
    @Published var selectedSearchData : SearchResponse?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManagerProtocol
    
    // Dependency Injection through the initializer
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    func setSelectedLocation(selectedSearchData : SearchResponse?){
        self.selectedSearchData = selectedSearchData
    }
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var str = ""
        for val in country.unicodeScalars {
            str.unicodeScalars.append(UnicodeScalar(base + val.value)!)
        }
        return String(str)
    }
    
    func searchCities(_ text:String?) async{
        
        let request = SearchRequest(keyword: text ?? "")
       await networkManager.makeNetworkCall(endpoint: Endpoint.place, httpMethod: .GET, parameters: request.toJSON,type: [SearchResponse].self).sink { completion in
            switch completion {
            case .failure(let err):
                print("Error is \(err.localizedDescription)")
            case .finished:
                print("Finished")
            }
            
        } receiveValue: { [weak self] data  in
            self?.searchData = data
        }
        .store(in: &cancellables)
        
    }
}
