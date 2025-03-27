//
//  MovieService.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 25/03/2025.
//

import Network
import Combine

final class NetworkMonitor {
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue(label: "NetworkMonitorQueue", qos: .background)
    private let subject = CurrentValueSubject<Bool, Never>(true)

    var publisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }

    init() {
        startMonitoring()
    }

    private func startMonitoring() {
        let newMonitor = NWPathMonitor()
        monitor = newMonitor

        newMonitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            
            
            DispatchQueue.main.async {
                self?.subject.send(isConnected)
            }
            
        }
        newMonitor.start(queue: queue)
    }

}


