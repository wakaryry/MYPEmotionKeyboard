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
    
    /** when we change emotionSet, we must change the isSmallItem. This will update the emotion view*/
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
            
            let numbers = self.isSmallItem ? Int(MYPEmotionSmallLineNumber * MYPEmotionSmallNumber - 1) : Int(MYPEmotionBigLineNumber * MYPEmotionBigNumber - 1)
            
            var page = self.emotions.count / numbers
            page = (self.emotions.count - page * 20) >= 1 ? (page + 1) : page
            self.pageControl.numberOfPages = page
        }
    }
    
    fileprivate var currentSetIndex: Int = 0 {
        didSet {
            self.emotions = self.emotionSetsAll[self.currentSetIndex].emotions
            self.isSmallItem = self.emotionSetsAll[self.currentSetIndex].isSmallType
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
        
        var page = self.emotions.count / Int(MYPEmotionSmallLineNumber * MYPEmotionSmallNumber - 1)
        page = (self.emotions.count - page * 20) >= 1 ? (page + 1) : page
        self.pageControl.numberOfPages = page
        
        // init menu collection view
        let lay = UICollectionViewFlowLayout()
        lay.scrollDirection = .horizontal
        lay.itemSize = CGSize(width: MYPEmotionMenuWidth, height: MYPEmotionMenuHeight)
        lay.minimumLineSpacing = 0
        lay.minimumInteritemSpacing = 0
        lay.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight)
        self.emotionMenuCollection.collectionViewLayout = lay
        self.emotionMenuCollection.register(UINib(nibName: "MYPEmotionCell", bundle: MYPEmotionBundle), forCellWithReuseIdentifier: "MYPEmotionCellMenuId")
        
        self.emotionMenuCollection.reloadData()
    }
}

extension MYPEmotionView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.emotionCollection {
            return self.emotions.count
        }
        else {
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.emotionCollection {
            return self.emotions.count
        }
        else {
            return self.emotionSetsAll.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.emotionCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MYPEmotionCellId", for: indexPath) as! MYPEmotionCell
            if indexPath.row == (isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber) {
                cell.setDeleteCellContnet()
            }
            else {
                cell.setCellContnet(self.emotionForIndexPath(indexPath))
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MYPEmotionCellMenuId", for: indexPath) as! MYPEmotionCell
        cell.setMenuContent(self.emotionSetsAll[indexPath.row].coverName)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.emotionMenuCollection {
            if self.currentSetIndex == indexPath.row {
                return
            }
            self.currentSetIndex = indexPath.row
        }
        else if collectionView == self.emotionCollection {
            // delegate for action
        }
    }
    
    fileprivate func emotionForIndexPath(_ indexPath: IndexPath) -> MYPEmotion? {
        let page = indexPath.section
        var index = page * (self.isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber) + indexPath.row
        
        // new page
        let ip = index / (self.isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber)
        // new index
        let ii = index % (self.isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber)
        // index in data
        let reIndex = (ii % Int(self.isSmallItem ? MYPEmotionSmallLineNumber : MYPEmotionBigLineNumber)) * Int(self.isSmallItem ? MYPEmotionSmallNumber : MYPEmotionBigNumber) + (ii / 3)
        
        index = reIndex + ip * (self.isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber)
        
        if index < self.emotions.count {
            return self.emotions[index]
        }
        
        return nil
    }
    
    
}
