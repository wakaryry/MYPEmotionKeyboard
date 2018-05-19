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
    
    init(cover: String, emotions: [MYPEmotion]) {
        self.coverName = cover
        self.emotions = emotions
    }
}
