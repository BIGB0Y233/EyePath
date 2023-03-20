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
    @Binding var pathName: String
    @Binding var createNode: Bool
    @Binding var modelName: String
    @Binding var pathLength: Int

    var manager : CLLocationManager = CLLocationManager()
    @Environment(\.managedObjectContext) private var viewContext

    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection=[.horizontal,.vertical]
        arView.session.run(config)
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingHeading()

        //MARK: - 读取路径文件，启动计时器写入记录位置
        DispatchQueue.main.async {
            var originalNorth = 0.0 //初始方向
            var number: Int = 0 //计数
            //创建文件
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Path")
            fetchRequest.predicate = NSPredicate(format: "pathname == %@", pathName)
            do {
                let writingPath = try viewContext.fetch(fetchRequest).first!
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                    let trueNorth = manager.heading!.trueHeading
                    if createNode{
                        number += 1
                        if number == 1 {
                            //保存初始方向
                            originalNorth = trueNorth
                            writingPath.setValue(originalNorth, forKey: "initdirection")
                            if writingPath.value(forKey: "initdirection") is NSNumber {
                                writingPath.setValue(originalNorth, forKey: "initdirection")
                            }
                        }
                        
                        let Xcoord = NSNumber(value:arView.cameraTransform.translation.x)
                        let Zcoord = NSNumber(value:arView.cameraTransform.translation.z)
                        // let Ycoord = NSNumber(value:arView.cameraTransform.translation.y)     //高度记录
                        
                        //方向角度差
                        let delta = (trueNorth - originalNorth + 180).truncatingRemainder(dividingBy: 360) - 180
                        let deltaNorth = delta < -180 ? delta + 360 : delta
                        let nsNorth = NSNumber(value: deltaNorth)
                        //坐标
                        if var coordStack = writingPath.value(forKey: "position") as? [[NSNumber]] {
                            coordStack.append([Xcoord,-0.5,Zcoord])
                            writingPath.setValue(coordStack, forKey: "position")
                        }
                        //角度偏差
                        if var angleStack = writingPath.value(forKey: "anglediff") as? [NSNumber] {
                            angleStack.append(nsNorth)
                            writingPath.setValue(angleStack, forKey: "anglediff")
                        }
                        //路径点方向
                        if var directionStack = writingPath.value(forKey: "direction") as? [String] {
                            directionStack.append(modelName)
                            writingPath.setValue(directionStack, forKey: "direction")
                        }

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
                print("保存成功")
            } catch let error as NSError {
                print("writing failed!")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
}

}

