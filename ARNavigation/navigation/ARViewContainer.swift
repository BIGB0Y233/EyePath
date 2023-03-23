//
//  ARContainer.swift
//  ARLocation
//
//  Created by Allan Shi on 2022/4/28.
//

import SwiftUI
import ARKit
import RealityKit
import AVKit


struct ARViewContainer: UIViewRepresentable{

//MARK: - 进程控制
    @Binding var timer: Timer?
    @Binding var stopFlag: Bool
    @Binding var arrived: String
    
//MARK: - 路线数据
    let pathLength: Int
    let modelPos:[SIMD3<Float>]
    let modelName:[String]
    let trueNorth:[Double]

//MARK: - 状态显示
    @Binding var currentCoordinate: SIMD3<Float>
    @Binding var nextCoordinate: SIMD3<Float>
    @Binding var distance: Float
    @Binding var index: Int
    @Binding var displayTrueNorth: Double

//MARK: - AR启动项
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection=[.horizontal]
        arView.session.run(config)
        let parentEntity = AnchorEntity()
        let originalNorth = trueNorth[1] //初始方向
      //  var player: AVAudioPlayer?
        //MARK: - 加载模型
        for i in 0..<pathLength+1
        {
            let box = try! ModelEntity.load(named: modelName[i])
            box.position = modelPos[i]
            
            if i != 0{
                //以方向角度差旋转模型
                let delta = (trueNorth[i] - originalNorth + 180).truncatingRemainder(dividingBy: 360) - 180
                let deltaNorth = delta < -180 ? delta + 360 : delta
                let radians = -Float(deltaNorth) * Float.pi / 180.0
                box.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 1, z: 0))
                box.transform.scale *= 0.5
            }

            parentEntity.addChild(box)
        }
        arView.scene.addAnchor(parentEntity)
        
        //MARK: -   启动计时器判断当前位置
        DispatchQueue.main.async {
        //var distanceStack:[Float] = []
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if index < pathLength{
                //距下一个点距离判断
                currentCoordinate = arView.cameraTransform.translation
                nextCoordinate = modelPos[index+1]
                distance = (pow(nextCoordinate.x - currentCoordinate.x,2)+pow(nextCoordinate.z - currentCoordinate.z,2)).squareRoot()
                displayTrueNorth = trueNorth[index+1]
                
                // 语音
//                distanceStack.append(distance)
//                if distanceStack.count%50 == 0{
//                    let lastFewNodes = distanceStack.suffix(50)
//                    let aver = lastFewNodes.reduce(0, +)/50
//                    if abs(aver-distance)<0.5{
//                        print("长时间未动")
//                        if let soundURL = Bundle.main.url(forResource: getSound(name: modelName[index+1]), withExtension: "wav") {
//                            do {
//                                player = try AVAudioPlayer(contentsOf: soundURL)
//                                player?.play()
//                            } catch {
//                                print("语音获取出现错误")
//                                print(error.localizedDescription)
//                            }
//                        }
//                    }
//                }
                
                if distance  < 0.5 {
                    self.index += 1
                   // distanceStack = []
                    
                    //到达终点后停止
//                    if index == pathLength{
//                        timer?.invalidate()
//                        timer = nil
//                        stopFlag = true
//                        arrived = "已到达终点🏁"
//                    }
                }
               
            }
        }
    }
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if stopFlag==true {
            uiView.session.pause()
        }

    }
}

