//
//  NetworkMonitor.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 13/01/2025.
//

import Foundation
import Network

class NetworkStatus: ObservableObject {
    
    static let shared = NetworkManager()
    
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
    
}
