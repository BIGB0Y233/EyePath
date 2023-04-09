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
    @State var distance = ""
    @State var deltaNorth = ""
    @State var index: Int = 0
    @State private var result = ""

//MARK: - 路线数据
    let modelPos:[SIMD3<Float>]
    let modelName:[String]
    let pathLength: Int
    let trueNorth:[Double]

        var body: some View {
            NavigationStack{
                ZStack{
                    ARViewContainer(timer: $timer, stopFlag: $stopFlag, arrived: $result, pathLength: pathLength, modelPos: modelPos, modelName: modelName, trueNorth: trueNorth, displayDistance: $distance, index: $index, displayDeltaNorth: $deltaNorth).edgesIgnoringSafeArea(.all)
                        ZStack{
                            blurView(style: .light).frame(width: 300, height: 80,alignment: .top).clipShape(RoundedRectangle(cornerRadius: 8))
                            HStack{
                                VStack{
                                    Text("距离:\(distance)m").frame(maxHeight: 10).foregroundColor(.black).padding(5)
                                    Text("方向差:\(deltaNorth)°").frame(maxHeight: 10 ).foregroundColor(.black).padding(5)
                                    Text("进度:" + String(describing: index)+"/\(pathLength)").frame(maxHeight: 10).foregroundColor(.black).padding(5)
                                }
                                Button(action: {
                                    stopFlag = true
                                    result = "已结束导航"
                                    timer?.invalidate()
                                    timer = nil
                                }){
                                    Text("结束")
                                        .foregroundColor(.white)
                                        .frame(width: 100, height: 50)
                                        .background(Color.red)
                                        .cornerRadius(15.0)
                                        .padding(10)
                                }
                            }
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
                .navigationBarBackButtonHidden(true)
            }
    }

struct arViewer_Previews: PreviewProvider {
    static var previews: some View {
        arViewer(modelPos: [[0.0,0.0,0.0]],modelName: ["startingpoint"], pathLength: 0, trueNorth: [0.0])
    }
}
}
