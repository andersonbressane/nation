//
//  NetworkMonitor.swift
//  Nation
//
//  Created by Anderson Bressane on 05/10/2024.
//

import Network

protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
    func checkConnection() -> Bool
}

class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    var isConnected = false

    init() {
        monitor = NWPathMonitor()
        
        queue = DispatchQueue.global(qos: .background)
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        
        monitor.start(queue: self.queue)
    }
    
    func checkConnection() -> Bool {
        return isConnected
    }
}
