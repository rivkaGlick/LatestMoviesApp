//
//  NetworkFeature.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 25/03/2025.
//

import ComposableArchitecture
import Dependencies


struct NetworkFeature: Reducer {
    struct State: Equatable {
        var isConnected: Bool = true // מצב התחלתי - יש אינטרנט
    }

    enum Action {
        case startMonitoring
        case connectionChanged(Bool)
    }

    @Dependency(\.networkMonitor) var networkMonitor: NetworkMonitor

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .startMonitoring:
            return .run { send in
                for await isConnected in networkMonitor.publisher.values {
                    await send(.connectionChanged(isConnected))
                }
            }

        case .connectionChanged(let isConnected):
            state.isConnected = isConnected
            print("📡 מצב רשת השתנה: \(isConnected)")
            return .none
        }
    }
}

extension DependencyValues {
    var networkMonitor: NetworkMonitor {
        get { self[NetworkMonitorKey.self] }
        set { self[NetworkMonitorKey.self] = newValue }
    }
}

private enum NetworkMonitorKey: DependencyKey {
    static let liveValue: NetworkMonitor = NetworkMonitor()
}

