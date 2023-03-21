//
//  compassView.swift
//  EyePath
//
//  Created by Allan Shi on 2022/8/8.
//

import SwiftUI
import CoreLocation
import CoreData

struct compareView: View {
    
    @State var timer: Timer?
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: -判断是否开始
    @State var diff:Double = 0.0
    @State var shouldStart = false
//    @State var saved:Double = 0.0
//    @State var current:Double = 0.0
    
    //MARK: - 路线数据
    let pathName : String  //路线名称
    @State var pathLength = 0   //路线长度
    @State var modelPos:[SIMD3<Float>]=[]   //模型坐标
    @State var deltaNorth:[Float]=[]    //磁力计角度差
    @State var ModelName:[String]=[]    //模型名称
    
    
    var body: some View {
            VStack{
                Text("调整你面向的方位使直到以下数值接近0\n（越接近越好）")
                Text("👇").font(.largeTitle)
//                Text(String(saved))
//                Text(String(current))
                Text(String(diff)).onAppear{
                        loadPathData()
                    }
                .navigationDestination(isPresented: $shouldStart)
                        {
                            arViewer(modelPos: modelPos, modelName: ModelName, pathLength: pathLength, deltaNorth: deltaNorth)
                             EmptyView()
                         }
                }.onDisappear{
            timer?.invalidate()
            timer = nil
        }
    }
    
    //MARK: - 读取路线数据
    func loadPathData(){
        var savedHeading:Double = 0.0   //初始方向
        let manager : CLLocationManager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingHeading()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Path")
        fetchRequest.predicate = NSPredicate(format: "pathname == %@", pathName)
        do {
            let readingPath = try viewContext.fetch(fetchRequest).first!
            //路径点位置
            if let fetchingPos = readingPath.value(forKey: "position") as? [[Float]] {
                for eachPos in fetchingPos
                {
                    let posVect3:SIMD3=SIMD3(eachPos)
                    modelPos.append(posVect3)
                }
            }
            //路径点角度差
            if let fetchingDiff = readingPath.value(forKey: "anglediff") as? [Float] {
                for eachDiff in fetchingDiff
                {
                    deltaNorth.append(eachDiff)
                }
            }
            //路径点箭头方向
            if let fetchingDirection = readingPath.value(forKey: "direction") as? [String] {
                for eachDirection in fetchingDirection
                {
                    ModelName.append(eachDirection)
                }
            }
            //起点方向
            if let fetchingInitDire = readingPath.value(forKey: "initdirection") as? Double {
                savedHeading = fetchingInitDire
               // saved = savedHeading
            }
            //路线长度
            if let fetchingLength = readingPath.value(forKey: "pathlength") as? Int {
                pathLength = fetchingLength
            }
            //MARK: -// 启动计时器判断是否开始
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    let currentHeading = manager.heading?.trueHeading ?? 0.0
                   // print(currentHeading)
                    //目前的磁力计角度与第一个点的角度之差
                    let delta = (currentHeading - savedHeading + 180).truncatingRemainder(dividingBy: 360) - 180
                    diff = delta < -180 ? delta + 360 : delta
               //     current = currentHeading
                    //判断开始依据
                    if abs(diff)<0.5 {
                        shouldStart = true
                        timer?.invalidate()
                        timer = nil
                    }
                }
        }
        catch let error as NSError {
            print("path fetching failed!")
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
        
}

struct compassView_Previews: PreviewProvider {
    static var previews: some View {
        compareView(pathName: "default")
    }
}
