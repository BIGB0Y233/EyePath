//
//  AutoAddPathView.swift
//  ARNavigation
//
//  Created by ck on 2023/3/24.
//

import Foundation
import SwiftUI
import RealityKit
import CoreData
import AudioToolbox

struct AutoAddPathView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - create Node paramiters
    @State var displayData = "tap on direction buttons to start"
    @State var timerCounter = 0
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
                    AutoAddPathContainer(timer: $timer, stopFlag: $stopFlag, returndata: $displayData , pathName: pathName, pathLength: $pathLength, timerCounter: $timerCounter).edgesIgnoringSafeArea(.all)
                    ZStack{
                        blurView(style: .light).frame(width: 320, height: 200, alignment: .center).clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack{
                            Text("记录坐标:\(displayData)").foregroundColor(.black).frame(width: 400, height: 20, alignment: .center)
                            Text("已记录点数：\(pathLength)").foregroundColor(.black).frame(width: 400, height: 20, alignment: .center)
                            Text("时间：\(String(timerCounter/2))s").foregroundColor(.black).frame(width: 400, height: 20, alignment: .center)
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
                                    Text("结束")
                                        .foregroundColor(.white)
                                        .frame(width: 100, height: 50)
                                        .background(Color.red)
                                        .cornerRadius(15.0)
                                        .padding(10)
                                }
                        }
                    }
                }.alert(isPresented: $stopFlag) {
                    Alert(title: Text(result), message: Text("记录完毕"), dismissButton: .default(Text("Ok")) {
                        navigateToNextView = true
                    })
                }
                .navigationDestination(isPresented: $navigateToNextView)
                        {
                             ContentView()
                             EmptyView()
                         }
            }.navigationBarBackButtonHidden(true)
        }
    }
}

struct AutoAddPathView_Previews: PreviewProvider {
    static var previews: some View {
        AutoAddPathView(pathName: "untitled")
    }
}
