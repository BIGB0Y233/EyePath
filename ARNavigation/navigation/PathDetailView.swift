//
//  PathDetailView.swift
//  ARNavigation
//
//  Created by ck on 2023/3/21.
//

import SwiftUI
struct PathDetailView: View {
    
    let name: String
    
    var body: some View {
        ScrollView{
                VStack {
                    Image(uiImage: loadImageFromPath(path: name))
                        .resizable()
                        .scaledToFit()
                    Text(name)
                        .font(.largeTitle)
                        .bold()
                    NavigationLink(destination: compareView(pathName: name))
                    {        Text("开始导航")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.blue)
                        .cornerRadius(15.0) }
                    Spacer()
                    //            Text(price)
                    //                .font(.title2)
                }
                .padding()
        }
    }
}

struct PathDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PathDetailView(name: "untitled")
    }
}


