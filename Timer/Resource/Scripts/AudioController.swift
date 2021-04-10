//
// Created by HM on 2021/04/09.
// Copyright (c) 2021 HM. All rights reserved.
//

import SwiftUI
import AVFoundation

class AudioController {
    static let shared = AudioController()

    public func audioSelector(forKey: String) {
        let dialog = NSOpenPanel()

        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = false

        if (dialog.runModal() != NSApplication.ModalResponse.OK) { return }

        do {
            let documentDir = Utility.shared.getDocumentsDir()
            try Utility.shared.copyAudioSource(origin: dialog.url!, target: documentDir.appendingPathComponent(dialog.url!.lastPathComponent))
            UserDefaults.standard.set(dialog.url!.lastPathComponent, forKey: forKey)
        } catch {
            NSLog("Failed copy audioSource: \(error)")
        }
    }

    public func audioDeleteSource(forKey: String) {
        do {
            let source = getAudioSource(forKey: forKey)
            try FileManager.default.removeItem(at: source!)
            UserDefaults.standard.removeObject(forKey: forKey)
        } catch {
            NSLog("Failed delete audioSource: \(error)")
            if UserDefaults.standard.string(forKey: forKey) != nil {
                UserDefaults.standard.removeObject(forKey: forKey)
            }
        }
    }

    public func controlAudio(forKey: String?, enable: Bool) {
        if (isAudioSourceEmpty()) { return }

        switch forKey {
        case "normal": do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "normal")!) } catch { NSLog("No audio source.") }
        case "approach": do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "approach")!) } catch { NSLog("No audio source.") }
        case "imminent": do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "imminent")!) } catch { NSLog("No audio source.") }
        case "info": do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "info")!) } catch { NSLog("No audio source.") }
        case "caution": do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "caution")!) } catch { NSLog("No audio source.") }
        case "warning": do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "warning")!) } catch { NSLog("No audio source.") }
        case "basic": do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "basic")!) } catch { NSLog("No audio source.") }
        case "simple": do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "simple")!) } catch { NSLog("No audio source.") }
        default: if !enable { sound.stop() } else { NSLog("Audio not imported: \(forKey!)") }
        }
        if enable {
            if sound.isPlaying { sound.stop() }
            sound.prepareToPlay()
            sound.play()
        }
    }

    public func isAudioSourceEmpty() -> Bool {
        getAudioSource(forKey: "normal")?.path.isEmpty ?? true ||
        getAudioSource(forKey: "approach")?.path.isEmpty ?? true ||
        getAudioSource(forKey: "imminent")?.path.isEmpty ?? true ||
        getAudioSource(forKey: "info")?.path.isEmpty ?? true ||
        getAudioSource(forKey: "caution")?.path.isEmpty ?? true ||
        getAudioSource(forKey: "warning")?.path.isEmpty ?? true ||
        getAudioSource(forKey: "simple")?.path.isEmpty ?? true
    }

    public func isAudioSourceEmpty(forKey: String) -> Bool {
        getAudioSource(forKey: forKey)?.path.isEmpty ?? true
    }

    private func getAudioSource(forKey: String) -> URL? {
        let source = UserDefaults.standard.string(forKey: forKey)
        return Utility.shared.getRealPath(file: source)
    }

    public func getAudioName(forKey: String) -> String? {
        let source = UserDefaults.standard.string(forKey: forKey)
        return Utility.shared.getRealPath(file: source)?.lastPathComponent
    }
}
