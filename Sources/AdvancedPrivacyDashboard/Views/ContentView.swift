import SwiftUI

struct ContentView: View {
    @State private var selectedTab: DashboardTab = .overview
    
    var body: some View {
        NavigationView {
            sidebar
            
            mainContent
        }
    }
    
    private var sidebar: some View {
        List(DashboardTab.allCases, id: \.self, selection: $selectedTab) { tab in
            NavigationLink(destination: tab.destination) {
                Label(tab.title, systemImage: tab.icon)
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 200)
    }
    
    private var mainContent: some View {
        selectedTab.destination
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }
}

enum DashboardTab: String, CaseIterable {
    case overview
    case networkMonitoring
    case threatDetection
    case privacyManagement
    case settings
    
    var title: String {
        switch self {
        case .overview: return "Overview"
        case .networkMonitoring: return "Network Monitoring"
        case .threatDetection: return "Threat Detection"
        case .privacyManagement: return "Privacy Management"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .overview: return "shield.lefthalf.filled"
        case .networkMonitoring: return "network"
        case .threatDetection: return "exclamationmark.shield"
        case .privacyManagement: return "lock.shield"
        case .settings: return "gear"
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .overview:
            OverviewView()
        case .networkMonitoring:
            NetworkMonitoringView()
        case .threatDetection:
            ThreatDetectionView()
        case .privacyManagement:
            PrivacyManagementView()
        case .settings:
            SettingsView()
        }
    }
} 