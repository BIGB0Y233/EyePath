//
//  BlurView.swift
//  ARLocation
//
//  Created by Allan Shi on 2022/5/9.
//

import SwiftUI

struct blurView:UIViewRepresentable{
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
}
