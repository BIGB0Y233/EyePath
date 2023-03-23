//
//  compassView.swift
//  EyePath
//
//  Created by Allan Shi on 2022/8/8.
//

import SwiftUI
import CoreData

struct compareView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    //MARK: -判断是否开始
    @State var shouldStart = false
    //MARK: - 路线数据
    let pathName : String  //路线名称
    @State var pathLength = 0   //路线长度
    @State var modelPos:[SIMD3<Float>]=[]   //模型坐标
    @State var trueNorth:[Double]=[]    //磁力计角度
    @State var ModelName:[String]=[]    //模型名称
    
    @StateObject private var frameModel = FrameModel()
    
    var body: some View {
        ZStack{
            VStack{
                Text("调整你所站位置和面向的方位\n（两个画面越接近越好）")
                Text("👇").font(.largeTitle).onAppear{
                    DispatchQueue.main.async {
                        loadPathData()
                    }}.padding(20)
                HStack{
                    Image(uiImage: loadImageFromPath(path: pathName))
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 150,
                            height: 200,
                            alignment: .center)
                    if let image = frameModel.frame {
                        Image(image, scale: 1.0, orientation: .up, label: Text("Video Capture"))
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: 150,
                                height: 200,
                                alignment: .center)
                    } else {
                        EmptyView()
                    }
                }.padding(30)
                Button("已对齐，开始导航"){
                    frameModel.stopSubscriptions()
                    shouldStart = true
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.blue)
            .cornerRadius(15.0)
                Spacer()
            }
            ErrorView(error: frameModel.error)
            .navigationDestination(isPresented: $shouldStart)
            {
                arViewer(modelPos: modelPos, modelName: ModelName, pathLength: pathLength, trueNorth: trueNorth)
                EmptyView()
            }
        }.onDisappear{
            frameModel.stopSubscriptions()
        }
    }
    
    //MARK: - 读取路线数据
    func loadPathData(){
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
            if let fetchingTrueNorth = readingPath.value(forKey: "truenorth") as? [Double] {
                for eachTrueNorth in fetchingTrueNorth
                {
                    trueNorth.append(eachTrueNorth)
                }
            }
            //路径点箭头方向
            if let fetchingDirection = readingPath.value(forKey: "direction") as? [String] {
                for eachDirection in fetchingDirection
                {
                    ModelName.append(eachDirection)
                }
            }
            
            if let fetchingPathLength = readingPath.value(forKey: "pathlength") as? Int {
                    pathLength = fetchingPathLength
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
        compareView(pathName: "1123")
    }
}

