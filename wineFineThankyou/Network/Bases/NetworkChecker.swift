//
//  NWMonitor.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/08.
//

import Foundation
import Network

class NWMonitor {
    static let shared = NWMonitor()
    
    private var isCellCon: Bool = false
    private var isWifiCon: Bool = false
    private var monitor: NWPathMonitor?
    
    internal var isInternetAvailable: Bool {
        if isCellCon { return true }
        else if isWifiCon { return true }
        else { return false }
    }
    
    func start() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] newPath in
            let isInternetAvailable = (newPath.status == .satisfied)
            let isWifiAvailable = (isInternetAvailable && !newPath.isExpensive)
            
            self?.isCellCon = isInternetAvailable
            self?.isWifiCon = isWifiAvailable
        }
        
        let queue = DispatchQueue(label: "NWMonitor", qos: .default)
        monitor.start(queue: queue)
        
        self.monitor = monitor
    }
    
    func stop() {
        self.monitor?.cancel()
    }
}

