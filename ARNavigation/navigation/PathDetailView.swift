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
        VStack {
            Image(uiImage: loadImageFromPath(path: name))
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(name)
                .font(.largeTitle)
                .bold()
//            Text(price)
//                .font(.title2)
        }
        .padding()
    }
    
    func loadImageFromPath(path: String) -> UIImage {
        
        let urlString=NSHomeDirectory()+"/Documents/\(path)"
        guard let image = UIImage(contentsOfFile: urlString) else {
            print("missing image at: \(path)")
            let size = CGSize(width: 100, height: 100)
            let renderer = UIGraphicsImageRenderer(size: size)
            let whiteImage = renderer.image { context in
                UIColor.yellow.setFill()
                context.fill(CGRect(origin: .zero, size: size))
            }
            return whiteImage
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
    }
}



struct PathDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PathDetailView(name: "untitled")
    }
}
