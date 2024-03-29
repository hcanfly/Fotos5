//
//  Model.swift
//  Fotos5
//
//  Created by Gary on 6/4/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit
import Photos


final class Model {
    
    var photos = [UIImage]()                            // for images in bundle
    var assetCollection: PHFetchResult<PHAsset>?        // camera roll photos
    private var cachingImageManager: PHCachingImageManager?

    
    static let sharedInstance: Model = {
         let instance = Model()
        
        instance.cachingImageManager = PHCachingImageManager()
        
        instance.accessAndLoadCollection()
        
        instance.loadPhotos()
        
        return instance
    }()
    
    private init() {}
    
    private func loadPhotos() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! + "/Sample Pictures"
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.lowercased().hasSuffix(".jpg") {
                if let image = UIImage(named: "Sample Pictures/" + item) {
                    self.photos.append(image)
                }
            }
        }
    }
    
    private func accessAndLoadCollection() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == PHAuthorizationStatus.authorized {
            self.loadCollection()
            return
        }
            
        else if status == PHAuthorizationStatus.denied {
            // Access has been denied.
            // Tell user to authorize in Settings
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            PHPhotoLibrary.requestAuthorization() { status in
                if (status == PHAuthorizationStatus.authorized) {
                    DispatchQueue.main.async {
                        self.loadCollection()
                        //FIXME!! send a notification that we now have some data. only needed for first time
                    }
                } else {
                    // Access has been denied. Oh, well ...
                }
            }
        } else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
    
    private func loadCollection() {
        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        if collections.count > 0 {
            let collection = collections[0]
            let options = PHFetchOptions()
            options.fetchLimit = 200        // For sample. we don't want to load thousands of photos. that is a different issue.
            options.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
            let assets = PHAsset.fetchAssets(in: collection, options: options)
            if assets.count > 0 {
                self.assetCollection = assets
            }
        }
    }

}
