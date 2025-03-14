import SwiftUI

struct PrivacyManagementView: View {
    @State private var selectedCategory: PrivacyCategory = .applications
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            headerSection
            
            HStack(spacing: 20) {
                categoriesSection
                Divider()
                detailSection
            }
        }
        .padding()
    }
    
    private var headerSection: some View {
        HStack {
            Text("Privacy Management")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            TextField("Search", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Categories")
                .font(.headline)
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(PrivacyCategory.allCases) { category in
                        CategoryRow(
                            category: category,
                            isSelected: category == selectedCategory,
                            action: { selectedCategory = category }
                        )
                    }
                }
            }
        }
        .frame(width: 200)
    }
    
    private var detailSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(selectedCategory.title)
                .font(.title2)
                .bold()
            
            ScrollView {
                VStack(spacing: 16) {
                    switch selectedCategory {
                    case .applications:
                        applicationsList
                    case .camera:
                        cameraSettings
                    case .microphone:
                        microphoneSettings
                    case .location:
                        locationSettings
                    case .cookies:
                        cookieSettings
                    case .analytics:
                        analyticsSettings
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var applicationsList: some View {
        VStack(spacing: 16) {
            ForEach(sampleApps) { app in
                AppPrivacyRow(app: app)
            }
        }
    }
    
    private var cameraSettings: some View {
        PrivacySettingsGroup(
            title: "Camera Access",
            description: "Manage which applications can access your camera",
            icon: "camera.fill",
            items: sampleApps
        )
    }
    
    private var microphoneSettings: some View {
        PrivacySettingsGroup(
            title: "Microphone Access",
            description: "Manage which applications can access your microphone",
            icon: "mic.fill",
            items: sampleApps
        )
    }
    
    private var locationSettings: some View {
        PrivacySettingsGroup(
            title: "Location Services",
            description: "Manage which applications can access your location",
            icon: "location.fill",
            items: sampleApps
        )
    }
    
    private var cookieSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cookie Management")
                .font(.headline)
            
            Toggle("Block Third-party Cookies", isOn: .constant(true))
            Toggle("Clear Cookies on Exit", isOn: .constant(false))
            Toggle("Accept Essential Cookies Only", isOn: .constant(true))
            
            Divider()
            
            Button("Clear All Cookies") {
                // Handle cookie clearing
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
    
    private var analyticsSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Analytics & Tracking")
                .font(.headline)
            
            Toggle("Block Analytics Tracking", isOn: .constant(true))
            Toggle("Block Ad Tracking", isOn: .constant(true))
            Toggle("Send Do Not Track Requests", isOn: .constant(true))
            
            Divider()
            
            Button("Reset Tracking Prevention") {
                // Handle tracking reset
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

struct CategoryRow: View {
    let category: PrivacyCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundColor(isSelected ? .blue : .secondary)
                
                Text(category.title)
                    .foregroundColor(isSelected ? .primary : .secondary)
                
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

struct AppPrivacyRow: View {
    let app: PrivacyApp
    @State private var isEnabled: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "app.badge")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(app.name)
                    .font(.headline)
                Text(app.bundleId)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

struct PrivacySettingsGroup: View {
    let title: String
    let description: String
    let icon: String
    let items: [PrivacyApp]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            ForEach(items) { item in
                AppPrivacyRow(app: item)
            }
        }
    }
}

enum PrivacyCategory: String, CaseIterable, Identifiable {
    case applications
    case camera
    case microphone
    case location
    case cookies
    case analytics
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .applications: return "Applications"
        case .camera: return "Camera"
        case .microphone: return "Microphone"
        case .location: return "Location"
        case .cookies: return "Cookies"
        case .analytics: return "Analytics"
        }
    }
    
    var icon: String {
        switch self {
        case .applications: return "app.badge"
        case .camera: return "camera.fill"
        case .microphone: return "mic.fill"
        case .location: return "location.fill"
        case .cookies: return "shield.lefthalf.filled"
        case .analytics: return "chart.bar.fill"
        }
    }
}

struct PrivacyApp: Identifiable {
    let id = UUID()
    let name: String
    let bundleId: String
}

// Sample data
let sampleApps = [
    PrivacyApp(name: "Safari", bundleId: "com.apple.Safari"),
    PrivacyApp(name: "Mail", bundleId: "com.apple.Mail"),
    PrivacyApp(name: "Messages", bundleId: "com.apple.Messages"),
    PrivacyApp(name: "Photos", bundleId: "com.apple.Photos")
] 