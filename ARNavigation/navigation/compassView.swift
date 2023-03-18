//
//  compassView.swift
//  EyePath
//
//  Created by Allan Shi on 2022/8/8.
//

import SwiftUI
import CoreLocation
import ARKit
import RealityKit


struct compassView: View {
    
    @State var timer: Timer?
    @State var manager : CLLocationManager = CLLocationManager()
    
    //MARK: -判断是否开始
    @State var currentHeading = 0.0
    @State var diff = 0.0
    @State var shouldStart = false
    
    //MARK: - 路线数据
    @Binding var pathName : String  //路线名称
    @State var length = 5   //路线长度
    @State var modelPos:[SIMD3<Float>]=[]   //模型坐标
    @State var deltaNorth:[Float]=[]    //磁力计角度差
    @State var ModelName:[String]=[]    //模型名称


    var body: some View {
        ZStack{

            NavigationLink(destination: arViewer(modelPos: $modelPos, modelName: $ModelName, length: $length, deltaNorth: $deltaNorth), isActive: $shouldStart) {
                EmptyView()
            }

        Text(String(diff)).onAppear{
            self.manager.requestWhenInUseAuthorization()
            self.manager.startUpdatingHeading()
            
//MARK: - 读取路线数据
            let urlString=NSHomeDirectory()+"/Documents/"+pathName
            let fileUrl = URL(fileURLWithPath: urlString)
            let data1=readTxt(name:"direction.txt", fileBaseUrl: fileUrl)
            let data2=readTxt(name:"Nodes.txt", fileBaseUrl: fileUrl)
            let savedHeading=Double(data1)!
            let myline:[String]=data2.components(separatedBy: "\n")
            //记录长度
            var num=1
            for _ in myline{
                num+=1
            }
            var temp=1
            for line in myline
            {
                temp+=1
                if temp>num-1{
                    break
                }
                let myword:[String]=line.components(separatedBy: " ")
                var num=0
                var data_now:[Float]=[]
                for num_now in myword
                {
                    num+=1
                    //1，2，3为坐标
                    if num<4{
                        let now:Float
                        now=Float(num_now) ?? 1.0
                        data_now.append(now)
                    }
                    //4为磁力计方向
                    if(num==4)
                    {
                        let now:Float
                        now=Float(num_now) ?? 1.0
                        deltaNorth.append(now)
                    }
                    //5为导航方向
                    if num>4
                    {
                        ModelName.append(num_now)
                    }
                }
                let testVect4:SIMD3=SIMD3(data_now)
                modelPos.append(testVect4)
            }
            length = num-2
            
//MARK: -// 启动计时器判断是否开始
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                //print("????????????????????????????")
                currentHeading = manager.heading?.trueHeading ?? 0.0
                //目前的磁力计角度与第一个点的角度之差
                let delta = (currentHeading - savedHeading + 180).truncatingRemainder(dividingBy: 360) - 180
                diff = delta < -180 ? delta + 360 : delta
                //判断开始依据
                if abs(diff)<0.5 {
                    shouldStart = true
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
        }.onDisappear
        {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func readTxt(name:String, fileBaseUrl:URL) -> String{
        let manager = FileManager.default
        let file = fileBaseUrl.appendingPathComponent(name)
        let exist = manager.fileExists(atPath: file.path)
        if exist {
            let data = manager.contents(atPath: file.path)
            let readString = String(data: data!, encoding: String.Encoding.utf8)
            let data_back=readString!
            return data_back        }
        return " "
    }
}

struct compassView_Previews: PreviewProvider {
    static var previews: some View {
        compassView(pathName: .constant("default"))
    }
}
