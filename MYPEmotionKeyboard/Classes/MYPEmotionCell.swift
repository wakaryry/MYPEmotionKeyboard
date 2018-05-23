//
//  MYPEmotionCell.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/20.
//

import Foundation

public class MYPEmotionCell: UICollectionViewCell {
    
    @IBOutlet weak var emotionImageView: UIImageView!
    @IBOutlet weak var imageHeightC: NSLayoutConstraint!
    @IBOutlet weak var imageWidthC: NSLayoutConstraint!
    
    internal var isDelete: Bool = false
    var emotion: MYPEmotion? = nil
    // if is default emotion. default: true. from outside: false
    var isSmallType = true
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        self.emotionImageView.image = nil
        self.emotion = nil
    }
    
    func setCellContnet(_ emotion: MYPEmotion? = nil, isSmallType: Bool = true) {
        guard let e = emotion else {
            self.emotionImageView.image = nil
            return
        }
        self.emotion = e
        self.isDelete = false
        if self.isSmallType {
            let path = MYPEmotionBundle?.path(forResource: e.name, ofType: "png")
            self.emotionImageView.image = UIImage(contentsOfFile: path!)
        }
        else {
            self.emotionImageView.image = UIImage(named: e.name)
            self.imageWidthC.constant = MYPEmotionBigHeight
            self.imageWidthC.constant = MYPEmotionBigHeight
        }
        
    }
    
    func setDeleteCellContnet() {
        self.emotion = nil
        self.isDelete = true
        self.emotionImageView.image = UIImage(contentsOfFile: (MYPEmotionBundle?.path(forResource: "delete-emoji", ofType: "png"))!)
    }
    
    func setMenuContent(_ name: String) {
        if self.isSmallType {
            let path = MYPEmotionBundle?.path(forResource: name, ofType: "png")
            self.emotionImageView.image = UIImage(contentsOfFile: path!)
        }
        else {
            self.emotionImageView.image = UIImage(named: name)
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
