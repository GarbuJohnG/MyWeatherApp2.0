//
//  OpenStreetMapsService.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation

struct OSMLocation: Codable {
    let lat: String
    let lon: String
    let display_name: String
}

class OpenStreetMapService {
    
    // MARK: - Search Location Name for Coordinates
    
    func searchLocation(named placeName: String, completion: @escaping (Result<[OSMLocation], Error>) -> Void) {
        
        let baseURL = Constants.URLs.osmUrl + Constants.Endpoints.osmSearch
        let query = "?q=\(placeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&format=json"

        guard let url = URL(string: baseURL + query) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let locations = try JSONDecoder().decode([OSMLocation].self, from: data)
                if locations.count > 0 {
                    completion(.success(locations))
                } else {
                    completion(.failure(NSError(domain: "No results found", code: 404, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
        
    }
    
}

