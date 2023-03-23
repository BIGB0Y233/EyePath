//
//  pathFinder.swift
//  EyePath
//
//  Created by Allan Shi on 2022/7/8.
//
import Foundation
import SwiftUI
import RealityKit
import CoreData

struct AddPathView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - create Node paramiters
    @State var displayData = "tap on direction buttons to start"
    @State var timerCounter = 0
    @State var createNode = false
    @State var modelName = "startingpoint"
    @State var pathLength = 0
    
    //MARK: - 进程控制
    @State var timer: Timer?
    @State var stopFlag = false
    @State private var result = ""
    @State private var navigateToNextView = false

    let pathName: String
    
    var body: some View {
        NavigationStack {
            ZStack{
                ZStack{
                    AddPathContainer(timer: $timer, stopFlag: $stopFlag, returndata: $displayData , pathName: pathName, createNode: $createNode, modelName: $modelName,pathLength: $pathLength, timerCounter: $timerCounter).edgesIgnoringSafeArea(.all)
                    ZStack{
                        blurView(style: .light).frame(width: 300, height: 300, alignment: .center).clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack{
                            HStack{
                                Button(action: {createNode=true
                                    modelName = "left"
                                }
                                ){Text("⬅️").padding(20)}//.frame(width: 50, height: 50).background(Color.white)
                                Button(action: {createNode=true
                                    modelName = "straight"
                                }
                                ){Text("⬆️").padding(20)}
                                
                                Button(action: {createNode=true
                                    modelName = "right"
                                }
                                ){Text("➡️").padding(20)}
                            }
                            Button(action: {createNode=true
                                modelName = "destination"
                            }
                            ){Text("🏁").padding(20)}
                            Text(displayData).frame(width: 400, height: 20, alignment: .center)
                            Text("已记录点数：\(pathLength)").frame(width: 400, height: 20, alignment: .center)
                            Text("时间：\(String(timerCounter/2))s").frame(width: 400, height: 20, alignment: .center)
                            
                            Button(action: {
                                stopFlag = true
                                timer?.invalidate()
                                timer = nil
                                if pathLength<1{
                                    //删除文件
                                    do{
                                        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Path")
                                        fetchRequest.predicate = NSPredicate(format: "pathname == %@", pathName)
                                        let deletePath = try viewContext.fetch(fetchRequest).first!
                                        viewContext.delete(deletePath)
                                        try viewContext.save()
                                        result = "路径点小于1,路径无效，已删除❌！"
                                    }
                                    catch let error as NSError {
                                        print("path delete failed!")
                                        fatalError("Unresolved error \(error), \(error.userInfo)")
                                    }
                                }
                                else{
                                    result = "保存成功✅!"
                                }
                            }) {
                                Text("结束").frame(width: 100, height: 50, alignment: .center)
                            }
                        }
                    }
                }.alert(isPresented: $stopFlag) {
                    Alert(title: Text(result), message: Text("记录完毕"), dismissButton: .default(Text("Ok")) {
                        navigateToNextView = true
                    })
                }
//                NavigationLink(destination: ContentView(), isActive: $navigateToNextView) { EmptyView() }
                .navigationDestination(isPresented: $navigateToNextView)
                        {
                             ContentView()
                             EmptyView()
                         }
            }.navigationBarBackButtonHidden(true)
        }
    }
}


struct AddPathView_Previews: PreviewProvider {
    static var previews: some View {
        AddPathView(pathName: "default")
    }
}
