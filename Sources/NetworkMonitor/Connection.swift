//
//  NetworkMonitor.swift
//  NetworkMonitor
//
//  Created by Ina Štatkić on 2025/5/31.
//


import Foundation
import Network

@Observable @MainActor
class NetworkMonitor {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    public var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            Task {
                await MainActor.run {
                    self.isConnected = path.status == .satisfied
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
