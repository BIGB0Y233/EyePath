//
//  PathDetailView.swift
//  ARNavigation
//
//  Created by ck on 2023/3/21.
//

import SwiftUI
import CoreData

struct PathDetailView: View {
    let thePath: FetchedResults<Path>.Element
    var body: some View {
            ScrollView{
                VStack {
                    Image(uiImage: loadImageFromPath(path: thePath.pathname!))
                        .resizable()
                        .scaledToFit()
                    Text(thePath.pathname!)
                        .font(.largeTitle)
                        .bold()
                    Text(thePath.timestamp!, formatter:itemFormatter)
                        .font(.title2)
                    Text(thePath.pathdescription ?? "无")
                        .font(.body)
                    NavigationLink(destination: compareView(thepath: thePath))
                    {        Text("开始导航")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.blue)
                        .cornerRadius(15.0) }
                    .isDetailLink(false)
                    .navigationTitle("路线详情")
                    .navigationBarTitleDisplayMode(.inline)
                    Spacer()
                }
                .padding()
            }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//struct PathDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PathDetailView(name: "untitled")
//    }
//}


