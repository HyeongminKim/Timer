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

    public func controlAudio(source: Int?, enable: Bool) {
        if (isAudioSourceEmpty()) { return }

        switch source {
        case 0: do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "normal")!) } catch { NSLog("No audio source.") }
        case 1: do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "approach")!) } catch { NSLog("No audio source.") }
        case 2: do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "imminent")!) } catch { NSLog("No audio source.") }
        case 3:
            do {
                sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "countDown")!)
                sound.currentTime = 7
            } catch { NSLog("No audio source.") }
        case 4: do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "basic")!) } catch { NSLog("No audio source.") }
        case 5: do { sound = try AVAudioPlayer(contentsOf: getAudioSource(forKey: "simple")!) } catch { NSLog("No audio source.") }
        default: if !enable { sound.stop() } else { NSLog("Audio not imported: \(source!)") }
        }
        if enable {
            if sound.isPlaying { sound.stop() }
            sound.prepareToPlay()
            sound.play()
        }
    }

    private func isAudioSourceEmpty() -> Bool {
        getAudioSource(forKey: "normal")?.path.isEmpty ?? true || getAudioSource(forKey: "approach")?.path.isEmpty ?? true || getAudioSource(forKey: "imminent")?.path.isEmpty ?? true ||
                getAudioSource(forKey: "countDown")?.path.isEmpty ?? true || getAudioSource(forKey: "basic")?.path.isEmpty ?? true || getAudioSource(forKey: "simple")?.path.isEmpty ?? true
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
