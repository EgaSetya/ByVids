//
//  Coordinator.swift
//  ByVids
//
//  Created by Ega Setya Putra on 03/10/24.
//

import SwiftUI

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var page: Page = .home
    
    // TODO: Shouldn't this be separated per page/scene (?)
    @Published var homepageViewModel = HomepageViewModel(repository: DefaultVideoRepository())
    @Published var selectedResourceViewModel: VideoViewModel?
    @Published var currentPopUpAlertConfiguration: DialogConfiguration?
    
    func showHomePageView() {
        path.removeLast(path.count)
    }
    
    func showVideoPageView(_ viewModel: VideoViewModel) {
        selectedResourceViewModel = viewModel
        path.append(Page.video)
    }
    
    func showAddViewPageView() {
        path.append(Page.addVideo)
    }
    
    // MARK: View Factory
    // TODO: Move this to other file for better separation of concern
    @ViewBuilder
    func createPageView(_ page: Page) -> some View {
        switch page {
        case .home:
            HomePageView(viewModel: homepageViewModel)
        case .video:
            if let selectedResourceViewModel {
                VideoPageView(viewModel: selectedResourceViewModel)
            }
        case .addVideo:
            AddVideoView()
        }
    }
}

enum Page: String, CaseIterable, Identifiable {
    case home, video, addVideo
    
    var id: String { self.rawValue }
}

enum FullScreenCover: String, CaseIterable, Identifiable {
    case popupAlert
    
    var id: String { self.rawValue }
}

enum Sheet: String, CaseIterable, Identifiable {
    case popupAlert
    
    var id: String { self.rawValue }
}
