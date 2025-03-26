//
//  MovieService.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 25/03/2025.
//

import Network
import Combine

final class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private let subject = CurrentValueSubject<Bool, Never>(true) // נניח שחיבור התחלתי הוא קיים

    var publisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.subject.send(isConnected)
        }
        monitor.start(queue: queue)
    }
}
