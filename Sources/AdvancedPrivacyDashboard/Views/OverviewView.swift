import SwiftUI

struct OverviewView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    StatusCard(
                        title: "Network Security",
                        status: .secure,
                        icon: "network",
                        details: "All connections are secure"
                    )
                    
                    StatusCard(
                        title: "Privacy Protection",
                        status: .warning,
                        icon: "eye.slash",
                        details: "2 apps requesting camera access"
                    )
                    
                    StatusCard(
                        title: "Threat Detection",
                        status: .secure,
                        icon: "shield.checkerboard",
                        details: "No threats detected"
                    )
                    
                    StatusCard(
                        title: "System Status",
                        status: .secure,
                        icon: "cpu",
                        details: "System is optimized"
                    )
                }
                .padding()
                
                recentActivitySection
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Security Overview")
                .font(.largeTitle)
                .bold()
            
            Text("Last scan: 5 minutes ago")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ForEach(1...5, id: \.self) { _ in
                ActivityRow()
            }
        }
    }
}

struct StatusCard: View {
    let title: String
    let status: SecurityStatus
    let icon: String
    let details: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Spacer()
                status.icon
            }
            
            Text(title)
                .font(.headline)
            
            Text(details)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

struct ActivityRow: View {
    var body: some View {
        HStack {
            Image(systemName: "bell")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text("Privacy Check Completed")
                    .font(.headline)
                Text("No issues found")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("2m ago")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

enum SecurityStatus {
    case secure
    case warning
    case critical
    
    var icon: some View {
        Image(systemName: iconName)
            .foregroundColor(color)
    }
    
    private var iconName: String {
        switch self {
        case .secure: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .critical: return "xmark.circle.fill"
        }
    }
    
    private var color: Color {
        switch self {
        case .secure: return .green
        case .warning: return .yellow
        case .critical: return .red
        }
    }
} 