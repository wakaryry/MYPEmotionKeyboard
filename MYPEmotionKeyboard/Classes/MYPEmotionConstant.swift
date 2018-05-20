//
//  MYPEmotionConstant.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/20.
//

import Foundation

internal var MYPEmotionBundle: Bundle? {
    let bundlePath = Bundle(for: MYPEmotion.self).path(forResource: "MYPEmotionKeyboard", ofType: "bundle")
    
    let bundle: Bundle?
    
    // Load bundle
    if let bundlePath = bundlePath {
        bundle = Bundle(path: bundlePath)
    } else {
        bundle = nil
    }
    return bundle
}

