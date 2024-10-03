//
//  MainPageView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 03/10/24.
//

import SwiftUI

struct MainPageView: View {
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.createPageView(Page.home)
                .navigationDestination(for: Page.self) { page in
                    coordinator.createPageView(page)
                }
        }
        .environmentObject(coordinator)
    }
}
