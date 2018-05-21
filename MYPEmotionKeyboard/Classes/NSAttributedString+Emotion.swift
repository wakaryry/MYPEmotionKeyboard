//
//  NSAttributedString+Emotion.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/21.
//

import Foundation

extension NSAttributedString {
    /** 匹配给定attributedString中的所有emoji，如果匹配到的emoji有本地图片的话会直接换成本地的图片*/
    public func translateAttributedTextIntoEmotionText(with font: UIFont?) {
        if self.length == 0 || font == nil {
            return
        }
    }
}
