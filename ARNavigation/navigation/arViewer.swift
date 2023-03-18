//
//  arViewer.swift
//  EyePath
//
//  Created by Allan Shi on 2022/7/3.
//

import SwiftUI
import AVKit
import RealityKit

struct arViewer: View{

//MARK: - 进程控制
    @State var stopFlag = false
    @State var timer: Timer?

//MARK: - 状态显示
    @State var currentCoordinate: SIMD3<Float> = [0.0,0.0,0.0]
    @State var nextCoordinate: SIMD3<Float> = [100.0,100.0,100.0]
    @State var distance: Float = 0.0
    @State var index: Int = 0

//MARK: - 路线数据
    @Binding var modelPos:[SIMD3<Float>]
    @Binding var modelName:[String]
    @Binding var length: Int
    @Binding var deltaNorth:[Float]

        var body: some View {
            ZStack{
                ARViewContainer(timer: $timer, stopFlag: $stopFlag, length: $length, modelPos: $modelPos, modelName: $modelName, deltaNorth: $deltaNorth,currentCoordinate: $currentCoordinate, nextCoordinate: $nextCoordinate, distance: $distance, index: $index).edgesIgnoringSafeArea(.all)
                VStack{
                Text("目前坐标:" + String(describing: currentCoordinate)).frame(width: 250, height: 100, alignment: .center)
                Text("下个点坐标:" + String(describing: nextCoordinate)).frame(width: 250, height: 100, alignment: .center)
                Text("相差距离:" + String(describing: distance)).frame(width: 250, height: 100, alignment: .center)
                Text("index:" + String(describing: index)).frame(width: 250, height: 100, alignment: .center)
                Button("结束") {
                    //self.presentationMode.wrappedValue.dismiss()
                    stopFlag = true
                    timer?.invalidate()
                    timer = nil
                    }
                }
            }.navigate(to: ContentView(), when: $stopFlag).navigationBarBackButtonHidden(true)
    }

struct arViewer_Previews: PreviewProvider {
    static var previews: some View {
        arViewer(modelPos: .constant([[0.0,0.0,0.0]]),modelName: .constant(["straight"]), length: .constant(0), deltaNorth: .constant([0.0]))
    }
}
}
