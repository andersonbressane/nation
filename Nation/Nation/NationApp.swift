//
//  NationApp.swift
//  Nation
//
//  Created by Anderson Bressane on 04/10/2024.
//

import SwiftUI

@main
struct NationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
