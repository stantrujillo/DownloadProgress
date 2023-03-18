//
//  Date.swift
//  DownloadProgress
//
//  Created by Stan Trujillo on 13/08/2023.
//

import Foundation

extension Date {
    func secondsHaveElapsedSince(interval: Double) -> Bool {
        let diff = Double(Date.now.timeIntervalSince1970 - self.timeIntervalSince1970)

        return diff >= interval
    }
}
