//
//  DetailView.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/4/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI
import AVKit


struct DetailView: View {
    
    var name: String
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        VStack{
        Text("导航的路线：\(name)")
        Button(action:
        { self.audioPlayer.play() }) {
                               Image(systemName: "play.circle.fill").resizable()
                                   .frame(width: 50, height: 50)
                                   .aspectRatio(contentMode: .fit)
                           }.onAppear {
                               let sound = Bundle.main.path(forResource: "继续直行", ofType: "wav")
                               self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                           }
        }
        .navigationBarTitle(name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(name: "default")
    }
}
