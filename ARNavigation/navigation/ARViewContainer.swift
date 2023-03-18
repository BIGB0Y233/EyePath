//
//  ARContainer.swift
//  ARLocation
//
//  Created by Allan Shi on 2022/4/28.
//

import SwiftUI
import ARKit
import RealityKit
import Combine


struct ARViewContainer: UIViewRepresentable{

//MARK: - 进程控制
    @Binding var timer: Timer?
    @Binding var stopFlag: Bool
    
//MARK: - 路线数据
    @Binding var length: Int
    @Binding var modelPos:[SIMD3<Float>]
    @Binding var modelName:[String]
    @Binding var deltaNorth:[Float]

//MARK: - 状态显示
    @Binding var currentCoordinate: SIMD3<Float>
    @Binding var nextCoordinate: SIMD3<Float>
    @Binding var distance: Float
    @Binding var index: Int

//MARK: - AR启动项
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection=[.horizontal,.vertical]
        arView.session.run(config)
        //let parentEntity = ModelEntity()
        
//MARK: - 加载模型
        for i in 0..<length
        {
//            let cubee = try! ModelEntity.load(named: word[i])
//            cubee.position = modelPos[i]
//            parentEntity.addChild(cubee)
            let box = customEntity(color: .green, position: modelPos[i])
            
            //旋转模型
            let radians = deltaNorth[i] * Float.pi / 180.0
            box.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 1, z: 0))
            box.transform.scale *= 0.5

            arView.scene.addAnchor(box)
        }
        
//MARK: -   启动计时器判断当前位置
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if index < length{
            //语音
//                        if counter % 5 == 0 {
//                            let sound = Bundle.main.path(forResource: getSound(name: word[index]), ofType: "wav")
//                            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
//                            self.audioPlayer.play()
//                        }
        
        currentCoordinate = arView.cameraTransform.translation
        nextCoordinate = modelPos[index]
        distance = (pow(nextCoordinate.x - currentCoordinate.x,2)+pow(nextCoordinate.z - currentCoordinate.z,2)).squareRoot()

        if distance  < 0.5 {
            self.index += 1
            if index == length{
                //print("arrived")
                        timer?.invalidate()
                        timer = nil
                }
              }
            }
        }

//            let anchor = AnchorEntity(plane: .horizontal)
//            anchor.addChild(parentEntity)
//            arView.scene.addAnchor(anchor)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if stopFlag==true {
            uiView.session.pause()
        }

    }
}

class customEntity:Entity,HasModel,HasAnchoring{
    var subs:[Cancellable]=[]
    required init(color:UIColor) {
        super.init()
        self.components[ModelComponent]=ModelComponent(mesh: .generateBox(width: 0.1, height: 0.1, depth: 0.1), materials: [SimpleMaterial(color: color, isMetallic: false)])
        }
    convenience init(color:UIColor,position:SIMD3<Float>)
    {
        self.init(color: color)
        self.position = position
    }
    required init() {
        fatalError("initialize failed!")
    }
}
