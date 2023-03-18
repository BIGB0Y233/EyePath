//
//  CustomAlertView.swift
//  EyePath
//
//  Created by Allan Shi on 2022/8/8.
//

import SwiftUI

struct alertView: View{
    
    @Binding var text: String
    @Binding var shown: Bool
    @Binding var isDone: Bool
    
    var body: some View{
        ZStack{
            VStack{
                Text("Enter Input").font(.headline).padding()
                TextField("Type text here", text: self.$text).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                Divider()
                HStack{
                    Spacer()
                    Button(action: {
                        self.shown.toggle()
                        self.isDone = true
                        print(self.text)
                    }) {
                        Text("Done")
                    }
                    Spacer()
                    Divider()
                    Spacer()
                    Button(action: {
                        self.shown.toggle()
                        self.isDone = false
                    }) {
                        Text("Cancel")
                    }
                    Spacer()
                }
            }
        }
        .background(Color(white: 0.9))
        .frame(width: 300, height: 200)
        .cornerRadius(20)
        }
}

extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
