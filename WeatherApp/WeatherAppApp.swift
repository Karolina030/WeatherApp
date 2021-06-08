//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 04/05/2021.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    var viewModel = WeatherViewModel()
    var locationViewModel = LocationViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
