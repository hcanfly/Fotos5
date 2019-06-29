//
//  DigestViewController.swift
//  Fotos
//
//  Created by main on 5/14/16.
//  Copyright © 2016 Gary Hanson. All rights reserved.
//

import UIKit
import Photos


let DigestViewCellId = "DigestViewCell"


final class DigestViewController: UICollectionViewController, Storyboarded {

    weak var coordinator: AppCoordinator?
    let imageManager = PHImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()

            // done in the storyboard
//        self.collectionView!.registerClass(DigestViewCell.self, forCellWithReuseIdentifier: DigestViewCellId)
//        self.collectionView!.collectionViewLayout = DigestViewFlowLayout()

        self.view.backgroundColor = backgroundColor
        self.collectionView.backgroundColor = backgroundColor

        self.layoutViews()
    }

    private func layoutViews() {
        if let layout = self.collectionView!.collectionViewLayout as? DigestViewFlowLayout {
            layout.prepare()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.layoutViews()
    }
    
/*
     The Digest View should have a function like buildDejaVuData in the DejaVu controller that builds groups of
     photos to display in a series of sections. There are so many ways to organize photos that I chose to just
     show some possible layouts and leave the organization to the developer.
     The usual pattern for the items is to create an array of arrays. That is, an array of items for each section.
     There will frequently / usually be more than the recommended max of five items displayed per section, which is
     why tapping on a section will open the section in the group collection view where you can see all of the items.
*/
    
}

// MARK: - UICollectionViewDataSource
extension DigestViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // see how many sections can be shown. in real life there will be a lot of photos and this will be cleaner
        guard Model.sharedInstance.assetCollection != nil else { return 0 }
        
        if Model.sharedInstance.assetCollection!.count > 18 { return 4 }
        
        return Model.sharedInstance.assetCollection!.count / 5
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section > 2 {
            return 4
        }
        
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DigestViewCellId, for: indexPath) as! DigestViewCell
    
        let index = (indexPath.section * 5) + indexPath.row
        let asset = Model.sharedInstance.assetCollection![index]
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 150,height: 150), contentMode: .aspectFit, options: options) {
            (image: UIImage?, info: [AnyHashable : Any]?) -> Void in
            
            cell.setImage(image)
        }
    
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DigestViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let startIndex = (indexPath.section * 5)
        self.collectionView!.numberOfItems(inSection: indexPath.section)
        var assets = [PHAsset]()
        for x in 0 ..< self.collectionView!.numberOfItems(inSection: indexPath.section) {
            assets.append(Model.sharedInstance.assetCollection![startIndex + x])
        }
        coordinator?.didSelectDigestPhoto(assets: assets)
    }
}
