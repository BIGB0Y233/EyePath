//
//  pathFinder.swift
//  EyePath
//
//  Created by Allan Shi on 2022/7/8.
//

import SwiftUI
import RealityKit
import CoreLocation

struct AddPathView: View {
    
//MARK: - create Node paramiters
        @State var displayData = "tap on direction buttons to start"
        @State var createNode = false
        @State var modelName = "straight"
    
        @State var timer: Timer?
        @State var stopFlag = false

        @Binding var pathName: String

        var body: some View {
                ZStack{
                    AddPathContainer(timer: $timer, stopFlag: $stopFlag, returndata: $displayData , pathName: $pathName, createNode: $createNode, modelName: $modelName).edgesIgnoringSafeArea(.all)

                    ZStack{
                        blurView(style: .light).frame(width: 400, height: 300, alignment: .center)
                    VStack{
                        HStack{
                            Button(action: {createNode=true
                                modelName = "left"}
                            ){Image(systemName: "arrow.left")}.frame(width: 50, height: 50).background(Color.white)
                            Button(action: {createNode=true
                                modelName = "straight"}
                            ){Image(systemName: "arrow.up")}.frame(width: 50, height: 50).background(Color.gray)
                            
                            Button(action: {createNode=true
                                modelName = "right"}
                            ){Image(systemName: "arrow.right")}.frame(width: 50, height: 50).background(Color.gray)
                        }
                        Text(displayData).frame(width: 400, height: 200, alignment: .center)
                        Button("结束") {
                            stopFlag = true
                            timer?.invalidate()
                            timer = nil
                            }
                        }
                        }
                }.navigate(to: ContentView(), when: $stopFlag).navigationBarBackButtonHidden(true)
        }
    }

struct AddPathView_Previews: PreviewProvider {
    static var previews: some View {
        AddPathView(pathName: .constant("default"))
    }
}


