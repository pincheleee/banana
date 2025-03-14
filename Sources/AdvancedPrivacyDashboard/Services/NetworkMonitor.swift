import Foundation
import Network
import NetworkExtension

class NetworkMonitor {
    typealias StatsUpdateHandler = (NetworkStats) -> Void
    
    struct SecurityThreat {
        enum ThreatType {
            case suspiciousConnection
            case unusualTraffic
            case potentialMalware
            case dataLeakage
        }
        
        let type: ThreatType
        let description: String
        let severity: Int // 1-5, with 5 being most severe
        let timestamp: Date
        let sourceIP: String?
        let destinationIP: String?
    }
    
    private var pathMonitor: NWPathMonitor?
    private var connections: Set<NWConnection> = []
    private var updateHandler: StatsUpdateHandler?
    private var bytesReceived: UInt64 = 0
    private var bytesSent: UInt64 = 0
    private var lastUpdateTime: Date = Date()
    private var securityThreats: [SecurityThreat] = []
    
    // Store timers to prevent memory leaks
    private var statsTimer: Timer?
    private var performanceTimer: Timer?
    
    func startMonitoring(updateHandler: @escaping StatsUpdateHandler) {
        self.updateHandler = updateHandler
        setupPathMonitor()
        startConnectionMonitoring()
        startPerformanceMonitoring()
    }
    
    func stopMonitoring() {
        pathMonitor?.cancel()
        pathMonitor = nil
        connections.forEach { $0.cancel() }
        connections.removeAll()
        
        // Invalidate timers to prevent memory leaks
        statsTimer?.invalidate()
        statsTimer = nil
        performanceTimer?.invalidate()
        performanceTimer = nil
    }
    
    private func setupPathMonitor() {
        pathMonitor = NWPathMonitor()
        pathMonitor?.pathUpdateHandler = { [weak self] path in
            self?.handlePathUpdate(path)
        }
        pathMonitor?.start(queue: DispatchQueue.global(qos: .utility))
    }
    
    private func handlePathUpdate(_ path: NWPath) {
        // Monitor network path changes
        if path.status == .satisfied {
            startConnectionMonitoring()
        }
    }
    
    private func startConnectionMonitoring() {
        // Invalidate existing timer if any
        statsTimer?.invalidate()
        
        // In a real implementation, we would:
        // 1. Use Network.framework to monitor active connections
        // 2. Track data transfer for each connection
        // 3. Analyze traffic patterns
        
        // For now, we'll simulate some basic monitoring
        statsTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateNetworkStats()
        }
    }
    
    private func startPerformanceMonitoring() {
        // Invalidate existing timer if any
        performanceTimer?.invalidate()
        
        // Monitor network performance metrics
        performanceTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.checkPerformance()
        }
    }
    
    private func updateNetworkStats() {
        let currentTime = Date()
        let interval = currentTime.timeIntervalSince(lastUpdateTime)
        
        // Simulate network activity
        let newBytesReceived = UInt64.random(in: 1000000...5000000)
        let newBytesSent = UInt64.random(in: 500000...2000000)
        
        let downloadSpeed = Double(newBytesReceived) / interval / 1024 / 1024 // MB/s
        let uploadSpeed = Double(newBytesSent) / interval / 1024 / 1024 // MB/s
        
        let stats = NetworkStats(
            downloadSpeed: downloadSpeed,
            uploadSpeed: uploadSpeed,
            activeConnectionsCount: Int.random(in: 5...20),
            totalBytesReceived: bytesReceived + newBytesReceived,
            totalBytesSent: bytesSent + newBytesSent
        )
        
        bytesReceived += newBytesReceived
        bytesSent += newBytesSent
        lastUpdateTime = currentTime
        
        DispatchQueue.main.async {
            self.updateHandler?(stats)
        }
    }
    
    private func checkPerformance() {
        // Analyze network performance and detect potential issues
        if Double.random(in: 0...1) < 0.1 { // 10% chance of detecting an issue
            let threat = SecurityThreat(
                type: .unusualTraffic,
                description: "Unusual spike in network traffic detected",
                severity: Int.random(in: 1...5),
                timestamp: Date(),
                sourceIP: "192.168.1.\(Int.random(in: 2...254))",
                destinationIP: "203.0.113.\(Int.random(in: 2...254))"
            )
            securityThreats.append(threat)
        }
    }
    
    func analyzeSecurityThreats() -> [SecurityThreat] {
        // In a real implementation, we would:
        // 1. Analyze traffic patterns
        // 2. Check for known malicious IPs
        // 3. Monitor for unusual behavior
        return securityThreats
    }
}

struct NetworkStats {
    var downloadSpeed: Double // in MB/s
    var uploadSpeed: Double // in MB/s
    var activeConnectionsCount: Int
    var totalBytesReceived: UInt64
    var totalBytesSent: UInt64
    var activeInterfaces: [NetworkInterface] = []
    
    var formattedDownloadSpeed: String {
        String(format: "%.1f MB/s", downloadSpeed)
    }
    
    var formattedUploadSpeed: String {
        String(format: "%.1f MB/s", uploadSpeed)
    }
} 