//
//  PermissionListView.swift
//  EyePath
//
//  Created by ck on 2023/4/23.
//

import SwiftUI
import PermissionsKit
import CameraPermission
import LocationWhenInUsePermission

struct PermissionsListView: View {
    @State private var locationAuthorized = false
    @State private var cameraAuthorized = false
    @Binding var isOnboarding: Bool
    
    var body: some View {
        VStack{
        Text("权限获取").font(.largeTitle).fontWeight(.bold).padding()
        List {
            Section(header: Text("Location"),footer: Text("需要位置信息来确定您的位置和方向。")) {
                HStack{
                    Image("location")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFit()
                    Button(action: {
                        requestLocationPermission()
                    }) {
                        Text("获取位置权限").foregroundColor(.accentColor)
                    }
                }
            }
            Section(header: Text("Camera"),footer: Text("需要摄像头权限用于增强现实导航。")) {
                HStack{
                    Image("camera")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFit()
                    Button(action: {
                        requestCameraPermission()
                    }) {
                        Text("获取摄像头权限").foregroundColor(.accentColor)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .frame(width: 350, height: 300)
        .cornerRadius(20)
        .padding(20)
        //.shadow(color: Color.gray, radius: 5, x: 0, y: 5)
            
            Button(action: {
                isOnboarding = false
            }) {
                Text("Get started")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(20)
            }
            
            Spacer()
        }
    }
    
    func requestLocationPermission() {
        // Request location permission
        // ...
        Permission.locationWhenInUse.request {
            
        }
    }
    
    func requestCameraPermission() {
        // Request camera permission
        // ...
        Permission.camera.request {
            
        }
    }
}


//struct PermissionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PermissionsListView()
//    }
//}

