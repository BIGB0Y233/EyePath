//
//  ModeSelectionView.swift
//  ARNavigation
//
//  Created by ck on 2023/3/24.
//

import SwiftUI
import AudioToolbox

struct ModeSelectionView: View {
    @AppStorage("addMode") var selectedMode = 0
    @AppStorage("isVoiceOn") var voiceOn = false
    let items = ["自动标记","手动标记"]
    
    var body: some View {
        NavigationStack {
                Form {
                    Section(header: Text("语音导航")) {
                        Toggle(isOn: $voiceOn) {
                            Text("语音")
                        }
                    }
                    Section(header: Text("路线标记方式"),footer: Text("手动标记下，您需要在制作路线时标出行走方向。自动标记下，您只需正常走完路线即可。")) {
                        List {
                            ForEach(items.indices, id: \.self) { index in
                                HStack {
                                    Text(items[index])
                                    Spacer()
                                    if selectedMode == index {
                                            Image(systemName: "checkmark")
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
                }
                .navigationTitle("偏好设置")
                .navigationBarTitleDisplayMode(.inline)
        }


    }
}

struct ModeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSelectionView()
    }
}
