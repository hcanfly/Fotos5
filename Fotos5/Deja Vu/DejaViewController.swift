//
//  DejaViewController.swift
//  Fotos
//
//  Created by main on 4/5/16.
//  Copyright © 2016 Gary Hanson. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


private extension Selector {
    static let scroll = #selector(DejaViewController.scroll)
    static let doScroll = #selector(DejaViewController.doScroll)
}

let DejaViewReuseIdentifier = "DejaViewCell"

final class DejaViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, Storyboarded {

    weak var coordinator: AppCoordinator?
    private var displayLink: CADisplayLink?
    private var animationRunning = false
    private var imageLayoutFlow: UICollectionViewFlowLayout!
    private var imageManager = PHImageManager()
    private var imageAssets = [PHAsset]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buildDejaVuData()
        
        self.view.backgroundColor = backgroundColor
        self.collectionView.backgroundColor = backgroundColor
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageLayoutFlow = UICollectionViewFlowLayout()
        self.imageLayoutFlow.scrollDirection = .horizontal
        self.collectionView!.collectionViewLayout = self.imageLayoutFlow
    }
    
    private func buildDejaVuData() {
        guard Model.sharedInstance.assetCollection != nil else { return }
    
        for x in 0..<Model.sharedInstance.assetCollection!.count {
            if let modifiedDate = Model.sharedInstance.assetCollection![x].modificationDate {
                //FIXME   use this test in real world when there are plenty of photos
                //        simulator doesn't necessarily have enough photos in the current month
                //if datesAreSameMonth(firstDate: modifiedDate, secondDate: Date()) {
                    self.imageAssets.append(Model.sharedInstance.assetCollection![x])
                //}
            }
            if self.imageAssets.count > 19 {  //FIXME! arbitrary limit that looks good. don't want too many
                break
            }
        }
    }
    
    private func datesAreSameMonth(firstDate: Date, secondDate: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.component(.month, from: firstDate) == calendar.component(.month, from: secondDate)
    }
    
    private func datesAreSameDay(firstDate: Date, secondDate: Date) -> Bool {
        let calendar = Calendar.current
            
        return calendar.component(.day, from: firstDate) == calendar.component(.day, from: secondDate)
    }
    
    func layoutAndStart() {
        self.layoutViews()
        
        self.startScrolling(delay: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.layoutViews()

        let size = self.view.bounds.height - 20
        
        self.imageLayoutFlow.itemSize = CGSize(width: size, height: size)
        self.imageLayoutFlow.minimumInteritemSpacing = 10
    }
    
    private func layoutViews() {
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.frame = frame
    }

    private func startScrolling(delay: Double) {
        Timer.scheduledTimer(timeInterval: delay, target: self, selector: .scroll, userInfo: nil, repeats: false)
    }

    @objc func scroll() {
        self.collectionView.contentOffset = CGPoint.zero
        self.displayLink = CADisplayLink(target: self, selector: .doScroll)
        self.displayLink?.add(to: .current, forMode: .common)
        self.animationRunning = true
    }
    
    @objc func doScroll() {
        self.collectionView.setContentOffset(CGPoint(x: self.collectionView.contentOffset.x + 0.25, y: 0.0), animated: false)
        
        if self.collectionView.contentOffset.x >= (self.collectionView.contentSize.width - self.collectionView.frame.width) {
            self.displayLink?.invalidate()
            self.displayLink = nil
            self.animationRunning = false
            self.startScrolling(delay: 2.0)
        }
    }

}


// MARK: - UICollectionViewDataSource
extension DejaViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard Model.sharedInstance.assetCollection != nil else { return 0 }
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageAssets.count
    }
    
}

// MARK: - UICollectionViewDelegate
extension DejaViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DejaViewReuseIdentifier, for: indexPath as IndexPath) as! DejaViewCell
        
        let asset = self.imageAssets[indexPath.row]
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        self.imageManager.requestImage(for: asset, targetSize: CGSize(width: cell.frame.width, height: cell.frame.height), contentMode: .aspectFit, options: options) {
            (image: UIImage?, info: [AnyHashable : Any]?) -> Void in
            
            cell.setImage(image: image)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        coordinator?.didSelectDejaVuPhoto(assets: self.imageAssets)
    }
}
