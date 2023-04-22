//
//  ModeSelectionView.swift
//  ARNavigation
//
//  Created by ck on 2023/3/24.
//

import SwiftUI
import AudioToolbox

struct PrefrenceView: View {
    @AppStorage("addMode") var selectedMode = 0
    @AppStorage("isVoiceOn") var voiceOn = false
    let items = ["自动标记","手动标记"]
    
    var body: some View {
                Form {
                    Section(header: Text("路线标记方式"),footer: Text("自动标记下，您只需拿着手机行走即可。手动标记下，您需要手动标出行走方向。")) {
                        List {
                            ForEach(items.indices, id: \.self) { index in
                                HStack {
                                    Text(items[index])
                                    Spacer()
                                    if selectedMode == index {
                                        Image(systemName: "checkmark").foregroundColor(.gray)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedMode = index
                                    AudioServicesPlaySystemSound(1519)
                                }
                            }
                        }
                    }
//                    Section(header: Text("语音导航")) {
//                        Toggle(isOn: $voiceOn) {
//                            Text("语音")
//                        }
//                    }
                }
                .navigationTitle("偏好设置")
    }
}

struct PrefrenceView_Previews: PreviewProvider {
    static var previews: some View {
        PrefrenceView()
    }
}
