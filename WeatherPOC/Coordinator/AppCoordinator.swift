//
//  AppCoordinator.swift
//  WeatherPOC
//
//  Created by Jatin Patel on 9/22/24.
//

import Foundation
import SwiftUI

enum AppPages: Hashable {
    case dashboard
    case dashboardDetail
}

enum Sheet: Identifiable {
    var id: String {
        switch self {
        case .locationSearch:
            return ""
        }
    }
    
    case locationSearch
}

class AppCoordinator: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: Sheet?
    var dismissSheetCallback: ((Any?) -> Void)?
    
    func push(page: AppPages) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    // Present a sheet and pass a callback with a generic argument
    func presentSheet<T>(_ sheet: Sheet, onDismiss: @escaping (T?) -> Void) {
        self.sheet = sheet
        self.dismissSheetCallback = { value in
            onDismiss(value as? T)
        }
    }
    
    // Dismiss the sheet and trigger the callback with the argument
    func dismissSheet<T>(_ result: T? = nil) {
        self.sheet = nil
        dismissSheetCallback?(result)
    }
    
    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .dashboard: DashboardView()
        case .dashboardDetail: DashboardWeatherDetailView()
        }
    }
    
    @ViewBuilder
    func buildSheet(sheet: Sheet) -> some View {
        switch sheet {
        case .locationSearch: LocationSearchView()
        }
    }
}

