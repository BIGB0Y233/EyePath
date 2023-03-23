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
import CoreData

struct AddPathContainer: UIViewRepresentable
{
    //MARK: - 进程控制
    @Binding var timer: Timer?
    @Binding var stopFlag: Bool
    
    //MARK: - create Node paramiters
    @Binding var returndata: String
    let pathName: String
    @Binding var createNode: Bool
    @Binding var modelName: String
    @Binding var pathLength: Int
    @Binding var timerCounter: Int

    let manager : CLLocationManager = CLLocationManager()
    @Environment(\.managedObjectContext) private var viewContext

    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection=[.horizontal]
        arView.session.run(config)
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingHeading()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Path")
        fetchRequest.predicate = NSPredicate(format: "pathname == %@", pathName)
        //MARK: - 读取路径文件，启动计时器写入记录位置
        DispatchQueue.main.async {
            do {
            let writingPath = try viewContext.fetch(fetchRequest).first!
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                    let trueNorth = manager.heading!.trueHeading
                    timerCounter+=1
                    if timerCounter==2{
                        // 保存图像
                        guard let currentFrame = arView.session.currentFrame else{
                            return}
                        let image = CIImage(cvPixelBuffer: currentFrame.capturedImage)
                        let context = CIContext(options: nil)
                        if let cgImage = context.createCGImage(image, from: image.extent) {
                            let uiImage = UIImage(cgImage: cgImage)
                           // print(uiImage.size)
                            saveImageLocally(image: uiImage, fileName: pathName)
                        }
                        else{
                            print("picture not saved!")
                        }
                    }
                    if createNode{
                        pathLength += 1
                        let Xcoord = arView.cameraTransform.translation.x
                        let Zcoord = arView.cameraTransform.translation.z
                        // let Ycoord = arView.cameraTransform.translation.y     //高度记录
                        
                        //坐标
                        if var coordStack = writingPath.value(forKey: "position") as? [[Float]] {
                            coordStack.append([Xcoord,-0.5,Zcoord])
                            writingPath.setValue(coordStack, forKey: "position")
                        }
                        //指南针度数
                        if var trueNorthStack = writingPath.value(forKey: "truenorth") as? [Double] {
                            trueNorthStack.append(trueNorth)
                            writingPath.setValue(trueNorthStack, forKey: "truenorth")
                        }
                        //路径点方向
                        if var directionStack = writingPath.value(forKey: "direction") as? [String] {
                            directionStack.append(modelName)
                            writingPath.setValue(directionStack, forKey: "direction")
                        }
                        //路径长度
                        if writingPath.value(forKey: "pathlength") is Int {
                            writingPath.setValue(pathLength, forKey: "pathlength")
                        }
                        
                        returndata = "目前坐标:"+String(Xcoord)+" "+String(Zcoord)
                        createNode = false
                    }
                }
            } catch let error as NSError {
                print("path fetching failed!")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if stopFlag==true {
            uiView.session.pause()
            do {
                try viewContext.save()
                manager.stopUpdatingHeading()
            } catch let error as NSError {
                print("writing failed!")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func saveImageLocally(image: UIImage, fileName: String) {
        // 获取文档目录的位置
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // 创建一个指向文件名的URL
        let url = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.pngData() {
            do {
                try data.write(to: url)
            } catch {
                print("Error saving image locally")
            }
        }
    }
    
}

