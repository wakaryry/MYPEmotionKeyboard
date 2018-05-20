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
    public var isSmallType: Bool
    
    init(cover: String, emotions: [MYPEmotion], isSmall: Bool = true) {
        self.coverName = cover
        self.emotions = emotions
        self.isSmallType = isSmall
    }
    
    class func defaultEmotionSet() -> MYPEmotionSet {
        return MYPEmotionSet(cover: "Expression_1", emotions: MYPEmotion.defaultEmotions())
    }
}
