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
        stopMonitoring() // נוודא שכל מוניטור קודם נסגר
        let newMonitor = NWPathMonitor()
        monitor = newMonitor

        newMonitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            
            print("📶 NetworkMonitor - מצב חיבור: \(isConnected ? "מחובר" : "מנותק")")
            
            DispatchQueue.main.async {
                self?.subject.send(isConnected)
            }
            
            // נאתחל מחדש כדי למנוע תקיעות
            self?.startMonitoring()
        }
        newMonitor.start(queue: queue)
    }

    private func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
}


