//
//  MYPEmotionInputDelegate.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/21.
//

import Foundation

public protocol MYPEmotionInputDelegate {
    func emotionView(_ emotionView: MYPEmotionView, didClickEmotion emotion: MYPEmotion, isDefault: Bool)
    func emotionViewdidClickDelete(_ emotionView: MYPEmotionView)
}
