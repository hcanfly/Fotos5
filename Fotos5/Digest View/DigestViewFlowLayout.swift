//
//  DigestViewFlowLayout.swift
//  Fotos
//
//  Created by main on 5/14/16.
//  Copyright © 2016 Gary Hanson. All rights reserved.
//

import UIKit

final class DigestViewFlowLayout: UICollectionViewFlowLayout {

    let META_SQ_WIDTH: CGFloat = 0.38
    let META_SQ_HEIGHT: CGFloat = 0.33

    var layoutAttributes = [String: UICollectionViewLayoutAttributes]()
    var contentSize = CGSize.zero
    
    
    override init() {
        super.init()
        
        self.commonInit()
    }
    
    private func commonInit() {
        let horizontalInset:CGFloat = 26.0
        self.sectionInset = UIEdgeInsets(top: 30.0, left: horizontalInset, bottom: 30.0, right: horizontalInset)
        self.minimumInteritemSpacing = 20.0
        self.minimumLineSpacing = 20.0
        self.scrollDirection = .vertical
        self.headerReferenceSize = CGSize.zero
        self.footerReferenceSize = CGSize.zero
    }
    
    override func prepare() {
        super.prepare()
        
        let width: CGFloat = self.collectionView!.frame.width - self.sectionInset.left - self.sectionInset.right
        let adjustedWidth = width * META_SQ_WIDTH
        let height: CGFloat = UIScreen.main.bounds.height * 0.40        // usually a nice size for a section
        let adjustedHeight = height * META_SQ_HEIGHT
        let sectionBreak: CGFloat = self.sectionInset.top
        let xOffset = self.sectionInset.left
        
        var rectsForSection = [[CGRect]]()
       
        if self.collectionView!.numberOfSections > 0 {
           rectsForSection.append(self.rectsForFiveItemsPlusA(width: width, adjustedWidth: adjustedWidth, xOffset: xOffset, height: height, adjustedHeight: adjustedHeight))
        }
        
        var yOffset = height + sectionBreak
        if self.collectionView!.numberOfSections > 1 {
            rectsForSection.append(self.rectsForFiveItemsPlusB(width: width, adjustedWidth: adjustedWidth, xOffset: xOffset, height: height, adjustedHeight: adjustedHeight, yOffset: yOffset))
        }
        
        if self.collectionView!.numberOfSections > 2 {
            yOffset += height + sectionBreak
            rectsForSection.append(self.rectsForFiveItemsPlusC(width: width, adjustedWidth: adjustedWidth, xOffset: xOffset, height: height, adjustedHeight: adjustedHeight, yOffset: yOffset))
        }

        if self.collectionView!.numberOfSections > 3 {
            yOffset += height + sectionBreak
            rectsForSection.append(self.rectsForFourItems(width: width, adjustedWidth: adjustedWidth, xOffset: xOffset, height: height, adjustedHeight: adjustedHeight, yOffset: yOffset))
        }
        
        for section in 0..<rectsForSection.count {
            for item in 0..<rectsForSection[section].count {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = rectsForSection[section][item]
                let key = self.layoutKeyForIndexPath(indexPath)
                self.layoutAttributes[key] = attributes
            }
        }
        
        let contentWidth = Int(self.collectionView!.bounds.width)
        let contentHeight = Int(height) * self.collectionView!.numberOfSections + (self.collectionView!.numberOfSections - 1) * Int(sectionBreak)
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    private func layoutKeyForIndexPath(_ indexPath : IndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
    
    private func layoutKeyForHeaderAtIndexPath(_ indexPath : IndexPath) -> String {
        return "s_\(indexPath.section)_\(indexPath.row)"
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let key = layoutKeyForIndexPath(indexPath)
        
        return self.layoutAttributes[key]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        return self.layoutAttributes.filter { rect.intersects($0.1.frame) }.map { $1 }
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        let oldBounds = self.collectionView!.bounds
        
        if oldBounds.width != newBounds.width {
            return true
        }
        
        return false
    }
    
    override var collectionViewContentSize : CGSize {
        
        return self.contentSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       self.commonInit()
    }
    
}

// MARK: - extension for calculating rects
extension DigestViewFlowLayout {
/*
     Here are 3 layouts for five items and one for four items. We have found that a max of five items provides
     some unique layouts which are quite clean. In most situations there will usually be a lot of sections with
     more than five items, so best to have a bunch to use. The design pattern is that if there are more than five
     items then you can see all of them by clicking in the section and opening the group photo collections.
     It is left as an exercise for the user to create sections for 1, 2 and three items
 */
    private func rectsForFiveItemsPlusA(width: CGFloat, adjustedWidth: CGFloat, xOffset: CGFloat, height: CGFloat, adjustedHeight: CGFloat) -> [CGRect] {
        var sectionRects = [CGRect]()
        
        var rect = CGRect(x: adjustedWidth + xOffset,
                          y: adjustedHeight,
                          width: width - adjustedWidth,
                          height: height - adjustedHeight)
        sectionRects.append(rect)
        
        rect = CGRect(x: adjustedWidth + xOffset,
                      y: 0,
                      width: width - adjustedWidth,
                      height: adjustedHeight)
        sectionRects.append(rect)
        
        rect = CGRect(x: 0 + xOffset,
                      y: adjustedHeight,
                      width: adjustedWidth,
                      height: height * 0.35)
        sectionRects.append(rect)
        
        rect = CGRect(x: 0 + xOffset,
                      y: adjustedHeight + (height * 0.35),
                      width: adjustedWidth,
                      height: height - (adjustedHeight + (height * 0.35)))
        sectionRects.append(rect)
        
        rect = CGRect(x: 0 + xOffset,
                      y: 0,
                      width: adjustedWidth,
                      height: adjustedHeight)
        sectionRects.append(rect)
        
        return sectionRects
    }
    
    private func rectsForFiveItemsPlusB(width: CGFloat, adjustedWidth: CGFloat, xOffset: CGFloat, height: CGFloat, adjustedHeight: CGFloat, yOffset: CGFloat) -> [CGRect] {
        var sectionRects = [CGRect]()
        
        var rect = CGRect(x: 0 + xOffset,
                          y: 0 + yOffset,
                          width: width - adjustedWidth,
                          height: height * 0.5)
        sectionRects.append(rect)
        
        rect = CGRect(x: 0 + xOffset,
                      y: height * 0.5 + yOffset,
                      width: width - adjustedWidth,
                      height: height - (height * 0.5))
        sectionRects.append(rect)
        
        rect = CGRect(x: width - adjustedWidth + xOffset,
                      y: 0 + yOffset,
                      width: adjustedWidth,
                      height: height * 0.35)
        sectionRects.append(rect)
        
        rect = CGRect(x: width - adjustedWidth + xOffset,
                      y: (height * 0.35) + adjustedHeight + yOffset,
                      width: adjustedWidth,
                      height: height - ((height * 0.35) + adjustedHeight))
        sectionRects.append(rect)
        
        rect = CGRect(x: width - adjustedWidth + xOffset,
                      y: height * 0.35 + yOffset,
                      width: adjustedWidth,
                      height: adjustedHeight)
        sectionRects.append(rect)
        
        return sectionRects
    }
    
    private func rectsForFiveItemsPlusC(width: CGFloat, adjustedWidth: CGFloat, xOffset: CGFloat, height: CGFloat, adjustedHeight: CGFloat, yOffset: CGFloat) -> [CGRect] {
        var sectionRects = [CGRect]()
        
        var rect = CGRect(x: 0 + xOffset,
                          y: 0 + yOffset,
                          width: adjustedWidth,
                          height: height - adjustedHeight)
        sectionRects.append(rect)
        
        rect = CGRect(x: adjustedWidth + xOffset,
                      y: height - adjustedHeight + yOffset,
                      width: width - adjustedWidth,
                      height: adjustedHeight)
        sectionRects.append(rect)
        
        rect = CGRect(x: adjustedWidth + xOffset,
                      y: 0 + yOffset,
                      width: width - adjustedWidth,
                      height: adjustedHeight)
        sectionRects.append(rect)
        
        rect = CGRect(x: adjustedWidth + xOffset,
                      y: adjustedHeight + yOffset,
                      width: width - adjustedWidth,
                      height: height - (adjustedHeight + adjustedHeight))
        sectionRects.append(rect)
        
        rect = CGRect(x: 0 + xOffset,
                      y: height - adjustedHeight + yOffset,
                      width: adjustedWidth,
                      height: adjustedHeight)
        sectionRects.append(rect)
        
        return sectionRects
    }
    
    private func rectsForFourItems(width: CGFloat, adjustedWidth: CGFloat, xOffset: CGFloat, height: CGFloat, adjustedHeight: CGFloat, yOffset: CGFloat) -> [CGRect] {
        var sectionRects = [CGRect]()
        
        var rect = CGRect(x: 0 + xOffset,
                          y: 0 + yOffset,
                          width: width - adjustedWidth,
                          height: height * 0.6);
        sectionRects.append(rect)
        
        rect = CGRect(x: 0 + xOffset,
                      y: height * 0.6 + yOffset,
                      width: width - adjustedWidth,
                      height: height - (height * 0.6));
        sectionRects.append(rect)
        
        rect = CGRect(x: width - adjustedWidth + xOffset,
                      y: adjustedHeight + yOffset,
                      width: adjustedWidth,
                      height: height - adjustedHeight)
        sectionRects.append(rect)
        
        rect = CGRect(x: width - adjustedWidth + xOffset,
                      y: 0 + yOffset,
                      width: adjustedWidth,
                      height: adjustedHeight)
        sectionRects.append(rect)
        
        return sectionRects
    }
}
