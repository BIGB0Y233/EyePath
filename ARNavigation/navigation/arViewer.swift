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
    @State var navigateToNextView = false

//MARK: - 状态显示
    @State var currentCoordinate: SIMD3<Float> = [0.0,0.0,0.0]
    @State var nextCoordinate: SIMD3<Float> = [100.0,100.0,100.0]
    @State var distance: Float = 0.0
    @State var index: Int = 0
    @State private var result = ""

//MARK: - 路线数据
    let modelPos:[SIMD3<Float>]
    let modelName:[String]
    let pathLength: Int
    let deltaNorth:[Float]

        var body: some View {
            NavigationStack{
                ZStack{
                    ARViewContainer(timer: $timer, stopFlag: $stopFlag, arrived: $result, pathLength: pathLength, modelPos: modelPos, modelName: modelName, deltaNorth: deltaNorth,currentCoordinate: $currentCoordinate, nextCoordinate: $nextCoordinate, distance: $distance, index: $index).edgesIgnoringSafeArea(.all)
                    VStack{
                        Text("目前坐标:" + String(describing: currentCoordinate)).frame(width: 250, height: 100, alignment: .center)
                        Text("下个点坐标:" + String(describing: nextCoordinate)).frame(width: 250, height: 100, alignment: .center)
                        Text("相差距离:" + String(describing: distance)).frame(width: 250, height: 100, alignment: .center)
                        Text("index:" + String(describing: index)).frame(width: 250, height: 100, alignment: .center)
                        Button("结束") {
                            stopFlag = true
                            result = "已结束导航"
                            timer?.invalidate()
                            timer = nil
                        }
                    }.alert(isPresented: $stopFlag) {
                        Alert(title: Text("⚠️"), message: Text(result), dismissButton: .default(Text("Ok")) {
                            navigateToNextView = true
                        })
                    }
                    .navigationDestination(isPresented: $navigateToNextView)
                    {
                        ContentView()
                        EmptyView()
                    }
                }.navigationBarBackButtonHidden(true)
            }
    }

struct arViewer_Previews: PreviewProvider {
    static var previews: some View {
        arViewer(modelPos: [[0.0,0.0,0.0]],modelName: ["straight"], pathLength: 0, deltaNorth: [0.0])
    }
}
}
