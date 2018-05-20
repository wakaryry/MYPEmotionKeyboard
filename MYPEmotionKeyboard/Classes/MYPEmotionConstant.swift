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

/** big emotion item*/
internal let MYPEmotionBigHeight: CGFloat = 75.0

/** small emotion item*/
internal let MYPEmotionSmallHeight: CGFloat = 50.0

/** number of emotion items in one line*/
internal let MYPEmotionSmallNumber: CGFloat = 7

internal let MYPEmotionBigNumber: CGFloat = 4

internal let MYPEmotionMenuHeight: CGFloat = 44

internal let MYPEmotionMenuWidth: CGFloat = 60
