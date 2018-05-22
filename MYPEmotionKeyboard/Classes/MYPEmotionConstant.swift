//
//  MYPEmotionConstant.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/20.
//

import Foundation

extension NSAttributedStringKey {
    struct MYPEmotionKey {
        static let MYPTextBackedStringAttributeName = NSAttributedStringKey("MYPTextBackedString")
    }
}

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

internal let MYPEmotionSmallLineNumber: CGFloat = 3

internal let MYPEmotionBigLineNumber: CGFloat = 2

internal let MYPEmotionSmallGroupNumber: Int = Int(MYPEmotionSmallNumber) * Int(MYPEmotionSmallLineNumber) - 1

internal let MYPEmotionBigGroupNumber: Int = Int(MYPEmotionBigNumber) * Int(MYPEmotionBigLineNumber) - 1

internal let MYPEmotionMenuHeight: CGFloat = 44

internal let MYPEmotionMenuWidth: CGFloat = 60

public var MYPEmotionKeyboardView: MYPEmotionView = UINib(nibName: "MYPEmotionView", bundle: MYPEmotionBundle).instantiate(withOwner: nil, options: nil).first as! MYPEmotionView
