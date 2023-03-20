//
//  pathFinder.swift
//  EyePath
//
//  Created by Allan Shi on 2022/7/8.
//
import Foundation
import SwiftUI
import RealityKit
import CoreLocation

struct AddPathView: View {
    
    //MARK: - create Node paramiters
    @State var displayData = "tap on direction buttons to start"
    @State var createNode = false
    @State var modelName = "straight"
    @State var pathLength = 0
    
    //MARK: - 进程控制
    @State var timer: Timer?
    @State var stopFlag = false
    @State private var showAlert = false
    @State private var result = "Nothing Saved!"
    @State private var navigateToNextView = false
    
    @Binding var pathName: String
    
    var body: some View {
        ZStack{
            AddPathContainer(timer: $timer, stopFlag: $stopFlag, returndata: $displayData , pathName: $pathName, createNode: $createNode, modelName: $modelName).edgesIgnoringSafeArea(.all)
            
            ZStack{
                blurView(style: .light).frame(width: 400, height: 300, alignment: .center)
                VStack{
                    HStack{
                        Button(action: {createNode=true
                            modelName = "left"
                            pathLength+=1
                        }
                        ){Image(systemName: "arrow.left")}.frame(width: 50, height: 50).background(Color.gray)
                        Button(action: {createNode=true
                            modelName = "straight"
                            pathLength+=1
                        }
                        ){Image(systemName: "arrow.up")}.frame(width: 50, height: 50).background(Color.gray)
                        
                        Button(action: {createNode=true
                            modelName = "right"
                            pathLength+=1
                        }
                        ){Image(systemName: "arrow.right")}.frame(width: 50, height: 50).background(Color.gray)
                    }
                    Text(displayData).frame(width: 400, height: 200, alignment: .center)
                    Button("结束") {
                        stopFlag = true
                        timer?.invalidate()
                        timer = nil
                        showAlert = true
                        if pathLength<2{
                            result = "路径点小于2，保存失败!!!"
                            let fileManager = FileManager.default
                            let folderPath = NSHomeDirectory()+"/Documents/\(pathName)"
                            do {
                                try fileManager.removeItem(atPath: folderPath)
                                print("成功删除")
                            } catch {
                                print("Error deleting folder: \(error.localizedDescription)")
                            }
                        }
                        else{
                            result = "保存成功!"
                        }
                    }
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text(result), message: Text("记录完毕"), dismissButton: .default(Text("ok")) {
                        navigateToNextView = true
                    })
                }
                NavigationLink(destination: ContentView(), isActive: $navigateToNextView) { EmptyView() }
            }
        }
    }
}


struct AddPathView_Previews: PreviewProvider {
    static var previews: some View {
        AddPathView(pathName: .constant("default"))
    }
}


