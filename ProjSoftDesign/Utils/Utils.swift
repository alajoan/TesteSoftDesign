//
//  Utils.swift
//  ProjSoftDesign
//
//  Created by Admin on 11/08/21.
//

import Foundation
import UIKit

public struct ScreenSize {

    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLenght = max(ScreenSize.width, ScreenSize.height)
    static let minLenght = min(ScreenSize.width, ScreenSize.height)
    static let isLarge: Bool = ScreenSize.width > 320
}
