//
// Created by HM on 2021/04/12.
// Copyright (c) 2021 HM. All rights reserved.
//

import SwiftUI

struct SoundChooser: View {
    @Binding var sheetIsShowing: Bool

    @State var normal = "normal"
    @State var approach = "approach"
    @State var imminent = "imminent"

    @State var info = "info"
    @State var caution = "caution"
    @State var warning = "warning"

    @State var basic = "basic"
    @State var simple = "simple"

    @State var normalBtn = "Normal"
    @State var approachBtn = "30 sec"
    @State var imminentBtn = "3 sec"

    @State var infoBtn = "1 min"
    @State var cautionBtn = "30 sec"
    @State var warningBtn = "10 sec"

    @State var basicBtn = "Default"
    @State var simpleBtn = "Simple"

    var body: some View {
        VStack {
            Text("Choose Sounds".localized()).bold().padding().fixedSize().font(.largeTitle)
            Text("Timer Sound".localized())
            Group {
                Chooser(viewModel: UpdateAudioName(), forKey: $normal, sourceBtn: $normalBtn)
                Chooser(viewModel: UpdateAudioName(), forKey: $approach, sourceBtn: $approachBtn)
                Chooser(viewModel: UpdateAudioName(), forKey: $imminent, sourceBtn: $imminentBtn)
            }
            Text("Alert Sound".localized())
            Group {
                Chooser(viewModel: UpdateAudioName(), forKey: $info, sourceBtn: $infoBtn)
                Chooser(viewModel: UpdateAudioName(), forKey: $caution, sourceBtn: $cautionBtn)
                Chooser(viewModel: UpdateAudioName(), forKey: $warning, sourceBtn: $warningBtn)
            }
            Text("Timer End Sound".localized())
            Group {
                Chooser(viewModel: UpdateAudioName(), forKey: $basic, sourceBtn: $basicBtn)
                Chooser(viewModel: UpdateAudioName(), forKey: $simple, sourceBtn: $simpleBtn)
            }
            Spacer()
            Button(action: {
                sheetIsShowing = false
            }, label: { Text("OK".localized()) })
        }.padding().frame(width: 380, height: 420)
    }
}

private struct Chooser: View {
    @ObservedObject var viewModel: UpdateAudioName
    @Binding var forKey: String
    @Binding var sourceBtn: String
    var body: some View {
        HStack {
            switch forKey {
            case "normal": Text(viewModel.normal)
            case "approach": Text(viewModel.approach)
            case "imminent": Text(viewModel.imminent)
            case "info": Text(viewModel.info)
            case "caution": Text(viewModel.caution)
            case "warning": Text(viewModel.warning)
            case "basic": Text(viewModel.basic)
            case "simple": Text(viewModel.simple)
            default: Text("N/A".localized())
            }
            Spacer()
            Button(action: {
                AudioController.shared.audioSelector(forKey: forKey)
                viewModel.checkForUpdate(forKey: forKey)
            }, label: { Text(sourceBtn.localized()) })
            Button(action: {
                AudioController.shared.audioDeleteSource(forKey: forKey)
                viewModel.checkForUpdate(forKey: forKey)
            }, label: {
                Text("CLR".localized())
            }).disabled(AudioController.shared.isAudioSourceEmpty(forKey: forKey))
        }
    }
}

private class UpdateAudioName: ObservableObject {
    @Published var normal: String = AudioController.shared.getAudioName(forKey: "normal") ?? "Empty".localized()
    @Published var approach: String = AudioController.shared.getAudioName(forKey: "approach") ?? "Empty".localized()
    @Published var imminent: String = AudioController.shared.getAudioName(forKey: "imminent") ?? "Empty".localized()

    @Published var info: String = AudioController.shared.getAudioName(forKey: "info") ?? "Empty".localized()
    @Published var caution: String = AudioController.shared.getAudioName(forKey: "caution") ?? "Empty".localized()
    @Published var warning: String = AudioController.shared.getAudioName(forKey: "warning") ?? "Empty".localized()

    @Published var basic: String = AudioController.shared.getAudioName(forKey: "basic") ?? "Empty".localized()
    @Published var simple: String = AudioController.shared.getAudioName(forKey: "simple") ?? "Empty".localized()

    func checkForUpdate(forKey: String) {
        switch forKey {
        case "normal": normal = AudioController.shared.getAudioName(forKey: forKey) ?? "Empty".localized()
        case "approach": approach = AudioController.shared.getAudioName(forKey: forKey) ?? "Empty".localized()
        case "imminent": imminent = AudioController.shared.getAudioName(forKey: forKey) ?? "Empty".localized()
        case "info": info = AudioController.shared.getAudioName(forKey: forKey) ?? "Empty".localized()
        case "caution": caution = AudioController.shared.getAudioName(forKey: forKey) ?? "Empty".localized()
        case "warning": warning = AudioController.shared.getAudioName(forKey: forKey) ?? "Empty".localized()
        case "basic": basic = AudioController.shared.getAudioName(forKey: forKey) ?? "Empty".localized()
        case "simple": simple = AudioController.shared.getAudioName(forKey: forKey) ?? "Empty".localized()
        default: NSLog("Not valid forKey: \(forKey)")
        }
    }
}
