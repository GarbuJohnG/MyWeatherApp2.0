//
//  NetworkManager.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import Foundation
import Combine

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    // MARK: - Fetch Data using URLSession GET 
    
    func fetchData<T: Decodable>(urlStr: String, responseType: T.Type) -> AnyPublisher<T, Error> {
            
            guard let url = URL(string: urlStr) else {
                return Fail(error: URLError(.badURL))
                    .eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: responseType, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    
}
