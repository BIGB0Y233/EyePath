//
//  ARContainer.swift
//  ARLocation
//
//  Created by Allan Shi on 2022/4/28.
//

import SwiftUI
import ARKit
import RealityKit
import CoreLocation

struct AddPathContainer: UIViewRepresentable
{
    //MARK: - 进程控制
    @Binding var timer: Timer?
    @Binding var stopFlag: Bool
    
    //MARK: - create Node paramiters
    @Binding var returndata: String
    @Binding var pathName: String
    @Binding var createNode: Bool
    @Binding var modelName: String

    var manager : CLLocationManager = CLLocationManager()

    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection=[.horizontal,.vertical]
        arView.session.run(config)
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingHeading()

        //创建文件
        let urlString=NSHomeDirectory()+"/Documents/\(pathName)"
        createFolder(baseUrl: urlString)
        let fileUrl = URL(fileURLWithPath: urlString)
        createTxt(name:"Nodes.txt", fileBaseUrl: fileUrl)
        createTxt(name:"direction.txt", fileBaseUrl: fileUrl)

        var originalNorth = 0.0 //初始方向
        var number: Int = 0
        //MARK: -// 启动计时器记录位置
        DispatchQueue.main.async {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            let trueNorth = manager.heading!.trueHeading
            if createNode{
                number += 1
                if number == 1 {
                    originalNorth = trueNorth
                    write(string: String(format: "%f",originalNorth), name: "direction.txt",docPath: fileUrl)
                }
                let Xcoord = arView.cameraTransform.translation.x
               // let Ycoord = arView.cameraTransform.translation.y     //高度记录
                let Zcoord = arView.cameraTransform.translation.z
                
                //方向角度差
                let delta = (trueNorth - originalNorth + 180).truncatingRemainder(dividingBy: 360) - 180
                let deltaNorth = delta < -180 ? delta + 360 : delta

                returndata = String(Xcoord)+" "+String(-0.5)+" "+String(Zcoord)+" "+String(format: "%f",deltaNorth)+" "+modelName+"\n"
                write(string: returndata, name: "Nodes.txt",docPath: fileUrl)
                createNode = false
            }
        }
        }
        return arView
    }

    func createTxt(name:String, fileBaseUrl:URL){
        let manager = FileManager.default
        let file = fileBaseUrl.appendingPathComponent(name)
        print("文件: \(file)")
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let data = Data(base64Encoded:"",options:.ignoreUnknownCharacters)
            let createSuccess = manager.createFile(atPath: file.path,contents:data,attributes:nil)
            print("文件创建结果: \(createSuccess)")
        }
    }

    func createFolder(baseUrl:String)
    {   let manager = FileManager.default
        let exist = manager.fileExists(atPath: baseUrl)
        if !exist{
        do {try manager.createDirectory(atPath: baseUrl, withIntermediateDirectories: true, attributes: nil)}
        catch{print("error to create folder!")}
    }
    }

    func write(string:String,name:String,docPath:URL){
        let file = docPath.appendingPathComponent(name)
        let appendedData = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let writeHandler = try? FileHandle(forWritingTo:file)
        writeHandler?.seekToEndOfFile()
        writeHandler?.write(appendedData!)
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if stopFlag==true {
            uiView.session.pause()
        }
}


}

