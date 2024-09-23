//
//  CoordinatorView.swift
//  WeatherPOC
//
//  Created by Jatin Patel on 9/22/24.
//

import Foundation
import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .dashboard)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.build(page: page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.buildSheet(sheet: sheet)
                }
        }
        .environmentObject(coordinator)
    }
}

