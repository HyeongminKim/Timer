//
// Created by HM on 2021/04/09.
// Copyright (c) 2021 HM. All rights reserved.
//

import SwiftUI

public extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
                get: { wrappedValue },
                set: { selection in
                    wrappedValue = selection
                    handler(selection)
                })
    }
}

public extension String {
    func localized(bundle: Bundle = .main, tableName: String = "ContentView") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

class Utility {
    static let shared = Utility()

    public func convertTime(inputTime: Int, dotEnable: Bool) -> String {
        let hour = inputTime / 3600
        let min = inputTime / 60 % 60
        let sec = inputTime % 60

        return String(format: dotEnable ? "%02i:%02i:%02i" : "%02i %02i %02i", hour, min, sec)
    }

    public func convertDate(inputTime: Int, secEnable: Bool) -> String {
        let date = DateFormatter()
        let convertedTime = now + TimeInterval(inputTime) as Date
        date.dateFormat = secEnable ? "HH:mm:ss" : "HH:mm"
        return String(date.string(from: convertedTime))
    }

    public func getDocumentsDir() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDir = paths.first!
        return documentsDir
    }

    public func getRealPath(file: String?) -> URL? {
        if file == nil { return nil }
        return getDocumentsDir().appendingPathComponent(file!)
    }

    public func copyAudioSource(origin: URL, target: URL) throws {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: target.path) {
            try fileManager.copyItem(at: origin, to: target)
        } else {
            try fileManager.removeItem(at: target)
            try fileManager.copyItem(at: origin, to: target)
        }
    }
}
