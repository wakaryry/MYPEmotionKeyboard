//
//  MYPEmotionSet.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/19.
//

import Foundation

public class MYPEmotionSet {
    public var coverName: String
    public var emotions: [MYPEmotion]
    // isSmallType == system default emotions, true
    public var isSmallType: Bool = true
    
    public init(cover: String, emotions: [MYPEmotion]) {
        self.coverName = cover
        self.emotions = emotions
        self.isSmallType = false
    }
    
    class func defaultEmotionSet() -> MYPEmotionSet {
        let e = MYPEmotionSet(cover: "Expression_1@2x", emotions: MYPEmotion.defaultEmotions())
        e.isSmallType = true
        return e
    }
}
