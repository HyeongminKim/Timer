//
//  ContentView.swift
//  Timer
//
//  Created by HM on 2020/04/12.
//  Copyright © 2020 HM. All rights reserved.
//

import SwiftUI
import AVFoundation

var now = Date()
var sound = AVAudioPlayer()

struct ContentView: View {
    @State private var setTimer = false
    @State private var setTime = 0
    @State private var startTime = 0
    @State private var pause = false
    @State private var timer: Timer?
    @State private var hour = 0
    @State private var minute = 0
    @State private var second = 0
    @State private var muteSound = UserDefaults.standard.bool(forKey: "muteCount")

    @State private var sheetIsShowing = false

    let h = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
    let m = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
    let s = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    
    var body: some View {
        VStack {
            if !setTimer {
                Text("Timer set".localized()).bold().padding().fixedSize().font(.largeTitle)
                Text(Utility.shared.convertTime(inputTime: startTime, dotEnable: true)).font(.title).foregroundColor(.gray)
                HStack {
                    Picker(selection: $hour.onChange({ (Int) -> Void in
                            now = Date()
                            startTime = hour * 3600 + minute * 60 + second
                        }), label: Text("h".localized())) {
                        ForEach(h, id: \.self) { h_set in
                            Text("\(h_set)").tag(h_set + 1000)
                        }
                    }.fixedSize()
                    Picker(selection: $minute.onChange({ (Int) -> Void in
                            now = Date()
                            startTime = hour * 3600 + minute * 60 + second
                        }), label: Text("m".localized())) {
                        ForEach(m, id: \.self) { m_set in
                            Text("\(m_set)").tag(m_set + 100)
                        }
                    }.fixedSize()
                    Picker(selection: $second.onChange({ (Int) -> Void in
                            now = Date()
                            startTime = hour * 3600 + minute * 60 + second
                        }), label: Text("s".localized())) {
                        ForEach(s, id: \.self) { s_set in
                            Text("\(s_set)").tag(s_set)
                        }
                    }.fixedSize()
                }
                HStack {
                    Text("ETA: ".localized())
                    startTime == 0 ? Text("N/A".localized()) : Text(Utility.shared.convertDate(inputTime: startTime, secEnable: false))
                }
                Toggle("Silent count".localized(), isOn: $muteSound.onChange({ (Bool) -> Void in
                    UserDefaults.standard.set(muteSound, forKey: "muteCount")
                })).padding()
                HStack {
                    Button(action: {
                        setTimer = true
                        if !pause {
                            setTime = startTime
                        } else {
                            pause = false
                        }
                        now = Date()
                        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                            guard startTime > 0 else {
                                timer?.invalidate()
                                return
                            }
                            startTime -= 1
                            if startTime == 0 {
                                !muteSound ? AudioController.shared.controlAudio(source: 4, enable: true) : AudioController.shared.controlAudio(source: 5, enable: true)
                            } else if startTime <= 10 {
                                AudioController.shared.controlAudio(source: 3, enable: !muteSound)
                            } else if startTime <= 30 {
                                AudioController.shared.controlAudio(source: 2, enable: !muteSound)
                            } else if startTime <= 60 {
                                AudioController.shared.controlAudio(source: 1, enable: !muteSound)
                            } else {
                                AudioController.shared.controlAudio(source: 0, enable: !muteSound)
                            }
                        })
                    }, label: { Text("Start".localized()) }).disabled(startTime == 0)
                    Button(action: {
                        startTime = 0
                        hour = 0
                        minute = 0
                        second = 0
                        pause = false
                        AudioController.shared.controlAudio(source: nil, enable: false)
                    }, label: { Text("Reset".localized())}).disabled(startTime == 0)
                }
                HStack {
                    Button(action: {
                        sheetIsShowing = true
                    }, label: {
                        Text("Choose Sounds...".localized())
                    }).sheet(isPresented: $sheetIsShowing, onDismiss: didDismiss) {
                        VStack {
                            Text("Choose Sounds".localized()).bold().padding().fixedSize().font(.largeTitle)
                            HStack {
                                Text(AudioController.shared.getAudioName(forKey: "normal") ?? "N/A")
                                Spacer()
                                Button(action: {
                                    AudioController.shared.audioSelector(forKey: "normal")
                                }, label: { Text("Normal Count".localized())})
                            }
                            HStack {
                                Text(AudioController.shared.getAudioName(forKey: "approach") ?? "N/A")
                                Spacer()
                                Button(action: {
                                    AudioController.shared.audioSelector(forKey: "approach")
                                }, label: { Text("1 min less".localized())})
                            }
                            HStack {
                                Text(AudioController.shared.getAudioName(forKey: "imminent") ?? "N/A")
                                Spacer()
                                Button(action: {
                                    AudioController.shared.audioSelector(forKey: "imminent")
                                }, label: { Text("30 sec less".localized())})
                            }
                            HStack {
                                Text(AudioController.shared.getAudioName(forKey: "countDown") ?? "N/A")
                                Spacer()
                                Button(action: {
                                    AudioController.shared.audioSelector(forKey: "countDown")
                                }, label: { Text("10 sec less".localized())})
                            }
                            HStack {
                                Text(AudioController.shared.getAudioName(forKey: "basic") ?? "N/A")
                                Spacer()
                                Button(action: {
                                    AudioController.shared.audioSelector(forKey: "basic")
                                }, label: { Text("Timer End Default".localized())})
                            }
                            HStack {
                                Text(AudioController.shared.getAudioName(forKey: "simple") ?? "N/A")
                                Spacer()
                                Button(action: {
                                    AudioController.shared.audioSelector(forKey: "simple")
                                }, label: { Text("Timer End Simple".localized())})
                            }
                            Spacer()
                            Button(action: {
                                sheetIsShowing = false
                            }, label: { Text("OK".localized()) })
                        }.padding().frame(width: 350, height: 350)
                    }
                }
                .padding()
            } else {
                if startTime != 0 {
                    Text("Timer start".localized()).bold().padding().fixedSize().font(.largeTitle)
                } else {
                    Text("Timer done".localized()).bold().padding().fixedSize().font(.largeTitle)
                }
                if startTime % 2 == 0 {
                    if 62 > startTime && startTime > 54 {
                        Text(Utility.shared.convertTime(inputTime: startTime, dotEnable: true)).font(.title).foregroundColor(.red)
                    } else if 32 > startTime && startTime > 24 {
                        Text(Utility.shared.convertTime(inputTime: startTime, dotEnable: true)).font(.title).foregroundColor(.red)
                    } else if 12 > startTime && startTime > 4 {
                        Text(Utility.shared.convertTime(inputTime: startTime, dotEnable: true)).font(.title).foregroundColor(.red)
                    } else if startTime == 0 {
                        Text(Utility.shared.convertTime(inputTime: startTime, dotEnable: true)).font(.title).background(Color.red)
                    } else {
                        if 15 > startTime && startTime > 0 {
                            Text(Utility.shared.convertTime(inputTime: startTime, dotEnable: true)).font(.title).foregroundColor(.orange)
                        } else {
                            Text(Utility.shared.convertTime(inputTime: startTime, dotEnable: true)).font(.title)
                        }
                    }
                } else {
                    if 16 > startTime && startTime > 0 {
                        Text(Utility.shared.convertTime(inputTime: startTime, dotEnable: false)).font(.title).foregroundColor(.orange)
                    } else {
                        Text(Utility.shared.convertTime(inputTime: startTime, dotEnable: false)).font(.title)
                    }
                }
                HStack {
                    Text("ETA: ")
                    if (startTime == 0) {
                        Text(Utility.shared.convertDate(inputTime: setTime, secEnable: true)).strikethrough(true).foregroundColor(Color.gray)
                    } else {
                        Text(Utility.shared.convertDate(inputTime: setTime, secEnable: true)).strikethrough(false)
                    }
                }
                Toggle("Silent count".localized(), isOn: $muteSound.onChange({ (Bool) -> Void in
                    UserDefaults.standard.set(muteSound, forKey: "muteCount")
                })).disabled(startTime == 0).padding()
                HStack {
                    Button(action: {
                        setTimer = false
                        startTime = setTime
                        hour = setTime / 60 / 60
                        minute = setTime / 60 % 60
                        second = setTime % 60
                        timer?.invalidate()
                        now = Date()
                        AudioController.shared.controlAudio(source: nil, enable: false)
                    }, label: { startTime != 0 ? Text("Stop".localized()) : Text("Back".localized()) })
                    Button(action: {
                        setTimer = false
                        pause = true
                        hour = startTime / 60 / 60
                        minute = startTime / 60 % 60
                        second = startTime % 60
                        timer?.invalidate()
                        now = Date()
                        AudioController.shared.controlAudio(source: nil, enable: false)
                    }, label: { Text("Pause".localized()) }).disabled(startTime == 0)
                    Button(action: {
                        setTimer = false
                        hour = 0
                        minute = 0
                        second = 0
                        startTime = 0
                        pause = false
                        timer?.invalidate()
                        AudioController.shared.controlAudio(source: nil, enable: false)
                    }, label: { Text("Reset".localized()) })
                }
                .padding()
            }
        }.padding()
    }
}

private func didDismiss() {

}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { wrappedValue },
            set: { selection in
                wrappedValue = selection
                handler(selection)
        })
    }
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "ContentView") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
