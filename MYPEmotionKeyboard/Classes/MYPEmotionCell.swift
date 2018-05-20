//
//  MYPEmotionCell.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/20.
//

import Foundation

public class MYPEmotionCell: UICollectionViewCell {
    
    @IBOutlet weak var emotionImageView: UIImageView!
    
    internal var isDelete: Bool = false
    var emotion: MYPEmotion? = nil
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        self.emotionImageView.image = nil
        self.emotion = nil
    }
    
    func setCellContnet(_ emotion: MYPEmotion? = nil) {
        guard let e = emotion else {
            self.emotionImageView.image = nil
            return
        }
        self.emotion = emotion
        self.isDelete = false
        if let path = TSConfig.ExpressionBundle!.path(forResource: model.imageString, ofType:"png") {
            self.emotionImageView.image = UIImage(contentsOfFile: path)
        }
    }
    
    func setDeleteCellContnet() {
        self.emotion = nil
        self.isDelete = true
        self.emotionImageView.image = TSAsset.Emotion_delete.image
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
