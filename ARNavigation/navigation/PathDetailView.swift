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
                    .aspectRatio(contentMode: .fit)
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
    
    func loadImageFromPath(path: String) -> UIImage {
        let urlString=NSHomeDirectory()+"/Documents/\(path)"
        guard let image = UIImage(contentsOfFile: urlString) else {
            let size = CGSize(width: 100, height: 100)
            let renderer = UIGraphicsImageRenderer(size: size)
            let whiteImage = renderer.image { context in
                UIColor.yellow.setFill()
                context.fill(CGRect(origin: .zero, size: size))
            }
            return whiteImage
        }
        let result = image.rotate(radians: .pi/2)
        return result
    }
}

struct PathDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PathDetailView(name: "untitled")
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y,
                            y: -origin.x,
                            width: size.width,
                            height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        return self
    }
}
