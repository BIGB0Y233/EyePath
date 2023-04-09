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
    let thepath: FetchedResults<Path>.Element
    
    @State var pathLength:Int = 0   //路线长度
    @State var modelPos:[SIMD3<Float>]=[]   //模型坐标
    @State var trueNorth:[Double]=[]    //磁力计角度
    @State var ModelName:[String]=[]    //模型名称
    
    @StateObject private var frameModel = FrameModel()
    
    var body: some View {
        ZStack{
            VStack{
                Text("初始位置校准：\n（调整你面向的方位，使两个画面接近）").frame(
                    maxWidth: .infinity,
                    alignment: .center).multilineTextAlignment(.center)
                Text("👇").font(.largeTitle).onAppear{
                    DispatchQueue.main.async {
                        loadPathData()
                    }}.padding(20)
                HStack{
                    Image(uiImage: loadImageFromPath(path: thepath.pathname!))
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
            let readingPath = thepath
            //路径点位置
            if let fetchingPos = readingPath.value(forKey: "position") as? [[Float]] {
                for eachPos in fetchingPos
                {
                    let posVect3:SIMD3=SIMD3(eachPos)
                    modelPos.append(posVect3)
                }
            }
            trueNorth = readingPath.truenorth!
            ModelName = readingPath.direction!
            pathLength = Int(readingPath.pathlength)
    }


//struct compassView_Previews: PreviewProvider {
//    static var previews: some View {
//        compareView(pathName: "1123")
//    }
}

