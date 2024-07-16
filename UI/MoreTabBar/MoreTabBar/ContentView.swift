//
//  ContentView.swift
//  MoreTabBar
//
//  Created by Balaji Venkatesh on 05/07/24.
//

import SwiftUI

enum TabModel: String, CaseIterable {
    case home = "house.fill"
    case search = "magnifyingglass"
    case notifications = "bell.fill"
    case bookmarks = "bookmark.fill"
    case communities = "person.2.fill"
    case settings = "gearshape.fill"
}

struct ContentView: View {
    @State private var activeTab: TabModel = .home
    @State private var isHidden: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            /// iOS 18+
            if #available(iOS 18, *) {
                TabView(selection: $activeTab) {
                    Tab.init(value: .home) {
                        Text("Home")
                            .toolbarVisibility(.hidden, for: .tabBar)
                            .background {
                                if !isHidden {
                                    RemoveMoreNavigationBar {
                                        isHidden = true
                                    }
                                }
                            }
                    }
                    
                    Tab.init(value: .search) {
                        Text("Search")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    
                    Tab.init(value: .notifications) {
                        Text("Notifications")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    
                    Tab.init(value: .bookmarks) {
                        Text("Bookmarks")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    
                    Tab.init(value: .communities) {
                        Text("Communities")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    
                    Tab.init(value: .settings) {
                        Text("Settings")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                }
            } else {
                /// iOS 16+
                TabView(selection: $activeTab) {
                    Color.green
                        .tag(TabModel.home)
                        .background {
                            if !isHidden {
                                RemoveMoreNavigationBar {
                                    isHidden = true
                                }
                            }
                        }
                    
                    Color.cyan
                        .tag(TabModel.search)
                    
                    Color.pink
                        .tag(TabModel.notifications)
                    
                    Color.yellow
                        .tag(TabModel.bookmarks)
                    
                    Color.black
                        .tag(TabModel.communities)
                    
                    Color.red
                        .tag(TabModel.settings)
                }
                .toolbar(.hidden, for: .tabBar)
            }
            
            CustomTabBar()
        }
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(TabModel.allCases, id: \.rawValue) { tab in
                Button {
                    activeTab = tab
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                        .foregroundStyle(activeTab == tab ? Color.primary : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
            }
        }
        .background(.bar)
    }
}

struct RemoveMoreNavigationBar: UIViewRepresentable {
    var result: () -> ()

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let tabBarController = view.tabBarController {
                tabBarController.moreNavigationController.navigationBar.isHidden = true
                /// Use this only if you want to completely hide the Native Tab Bar
                tabBarController.tabBar.isHidden = true
                result()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

/// Finding Attached UITabBarController from UIView
extension UIView {
    var tabBarController: UITabBarController? {
        if let controller = sequence(first: self, next: { item in
            item.next
        }).first(where: { $0 is UITabBarController }) as? UITabBarController {
            return controller
        }
        
        return nil
    }
}

#Preview {
    ContentView()
}
