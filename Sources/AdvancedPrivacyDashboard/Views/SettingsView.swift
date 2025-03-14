import SwiftUI

struct SettingsView: View {
    @State private var selectedSection: SettingsSection = .general
    @State private var notificationsEnabled = true
    @State private var autoScanEnabled = true
    @State private var scanInterval = 24.0
    @State private var dataRetentionDays = 30.0
    @State private var selectedTheme = Theme.system
    
    var body: some View {
        VStack(spacing: 20) {
            headerSection
            
            HStack(spacing: 20) {
                sectionsList
                Divider()
                settingsDetail
            }
        }
        .padding()
    }
    
    private var headerSection: some View {
        HStack {
            Text("Settings")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
    }
    
    private var sectionsList: some View {
        List(SettingsSection.allCases, selection: $selectedSection) { section in
            Label(section.title, systemImage: section.icon)
                .tag(section)
        }
        .listStyle(SidebarListStyle())
        .frame(width: 200)
    }
    
    private var settingsDetail: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(selectedSection.title)
                    .font(.title2)
                    .bold()
                
                switch selectedSection {
                case .general:
                    generalSettings
                case .notifications:
                    notificationSettings
                case .scanning:
                    scanningSettings
                case .data:
                    dataSettings
                case .updates:
                    updateSettings
                case .about:
                    aboutSection
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
    
    private var generalSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsGroup(title: "Appearance") {
                Picker("Theme", selection: $selectedTheme) {
                    ForEach(Theme.allCases) { theme in
                        Text(theme.rawValue.capitalized).tag(theme)
                    }
                }
            }
            
            SettingsGroup(title: "Startup") {
                Toggle("Launch at Login", isOn: .constant(true))
                Toggle("Show in Menu Bar", isOn: .constant(true))
            }
        }
    }
    
    private var notificationSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsGroup(title: "Notifications") {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                
                if notificationsEnabled {
                    Toggle("Threat Alerts", isOn: .constant(true))
                    Toggle("Privacy Violations", isOn: .constant(true))
                    Toggle("System Updates", isOn: .constant(true))
                }
            }
            
            SettingsGroup(title: "Notification Style") {
                Picker("Alert Style", selection: .constant(0)) {
                    Text("Banner").tag(0)
                    Text("Alert").tag(1)
                }
            }
        }
    }
    
    private var scanningSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsGroup(title: "Automatic Scanning") {
                Toggle("Enable Auto-Scan", isOn: $autoScanEnabled)
                
                if autoScanEnabled {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Scan Interval")
                        HStack {
                            Slider(value: $scanInterval, in: 1...72)
                            Text("\(Int(scanInterval)) hours")
                        }
                    }
                }
            }
            
            SettingsGroup(title: "Scan Options") {
                Toggle("Deep System Scan", isOn: .constant(true))
                Toggle("Network Analysis", isOn: .constant(true))
                Toggle("Background Apps", isOn: .constant(true))
            }
        }
    }
    
    private var dataSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsGroup(title: "Data Retention") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Keep History For")
                    HStack {
                        Slider(value: $dataRetentionDays, in: 7...90)
                        Text("\(Int(dataRetentionDays)) days")
                    }
                }
            }
            
            SettingsGroup(title: "Data Management") {
                Button("Export Data") {
                    // Handle data export
                }
                
                Button("Clear All Data") {
                    // Handle data clearing
                }
                .foregroundColor(.red)
            }
        }
    }
    
    private var updateSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsGroup(title: "Software Updates") {
                Toggle("Check for Updates Automatically", isOn: .constant(true))
                Toggle("Download Updates Automatically", isOn: .constant(true))
            }
            
            SettingsGroup(title: "Update Channel") {
                Picker("Channel", selection: .constant(0)) {
                    Text("Stable").tag(0)
                    Text("Beta").tag(1)
                }
            }
            
            Button("Check for Updates") {
                // Handle update check
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsGroup(title: "Application") {
                LabeledContent("Version") {
                    Text("1.0.0")
                }
                LabeledContent("Build") {
                    Text("2024.1")
                }
            }
            
            SettingsGroup(title: "Legal") {
                Button("Privacy Policy") {
                    // Open privacy policy
                }
                Button("Terms of Service") {
                    // Open terms of service
                }
                Button("Licenses") {
                    // Open licenses
                }
            }
        }
    }
}

struct SettingsGroup<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            content()
                .padding(.leading, 4)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

enum SettingsSection: String, CaseIterable, Identifiable {
    case general
    case notifications
    case scanning
    case data
    case updates
    case about
    
    var id: String { rawValue }
    
    var title: String {
        rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .general: return "gear"
        case .notifications: return "bell"
        case .scanning: return "shield.checkerboard"
        case .data: return "externaldrive"
        case .updates: return "arrow.triangle.2.circlepath"
        case .about: return "info.circle"
        }
    }
}

enum Theme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
} 