//
//  soundProcess.swift
//  EyePath
//
//  Created by Allan Shi on 2022/8/10.
//

import Foundation

func getSound(name:String) -> String {
    switch name {
    case "straight":
        return "继续直行"
    case "left":
        return "左转"
    case "right":
        return "右转"
    default:
        return "继续直行"
    }
}
