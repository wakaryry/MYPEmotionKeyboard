//
//  MYPEmotionView.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/20.
//

import Foundation

public class MYPEmotionView: UIView {
    
    @IBOutlet weak var emotionCollection: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var emotionMenuCollection: UICollectionView!
    
    /** user could set outside emotions*/
    public var emotionSets = [MYPEmotionSet]() {
        didSet {
            // reset emotionSetsUsed
            for s in self.emotionSets {
                self.emotionSetsAll.append(s)
            }
        }
    }
    
    fileprivate var isSmallItem = true {
        didSet {
            let number = self.isSmallItem ? MYPEmotionSmallNumber : MYPEmotionBigNumber
            let height = self.isSmallItem ? MYPEmotionSmallHeight : MYPEmotionBigHeight
            
            // calculate width and height
            let itemWidth = (UIScreen.main.bounds.width - 10 * 2) / number
            let padding = (UIScreen.main.bounds.width - number * itemWidth) / 2.0
            let paddingLeft = padding
            let paddingRight = UIScreen.main.bounds.width - paddingLeft - itemWidth * number
            
            // init FlowLayout
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: itemWidth, height: height)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight)
            
            // init emotion collection view
            self.emotionCollection.collectionViewLayout = layout
            
            self.emotionCollection.reloadData()
            
            var page = self.emotions.count / 20
            page = (self.emotions.count - page * 20) >= 1 ? (page + 1) : page
            self.pageControl.numberOfPages = page
        }
    }
    
    /** all the emotionSets including outside configured*/
    fileprivate var emotionSetsAll = [MYPEmotionSet.defaultEmotionSet()]
    fileprivate var emotions = MYPEmotion.defaultEmotions()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom()
    }
    
    private func custom() {
        
    }
    
    public override func awakeFromNib() {
        self.isUserInteractionEnabled = true
        
        // calculate width and height
        // default small item
        let itemWidth = (UIScreen.main.bounds.width - 10 * 2) / MYPEmotionSmallNumber
        let padding = (UIScreen.main.bounds.width - MYPEmotionSmallNumber * itemWidth) / 2.0
        let paddingLeft = padding
        let paddingRight = UIScreen.main.bounds.width - paddingLeft - itemWidth * MYPEmotionSmallNumber
        
        // init FlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: MYPEmotionSmallHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight)
        
        // init emotion collection view
        self.emotionCollection.collectionViewLayout = layout
        self.emotionCollection.register(UINib(nibName: "MYPEmotionCell", bundle: MYPEmotionBundle), forCellWithReuseIdentifier: "MYPEmotionCellId")
        self.emotionCollection.isPagingEnabled = true
        
        self.emotionCollection.reloadData()
    }
}
