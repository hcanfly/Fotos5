//
//  DigestViewCell.swift
//  LCFotos
//
//  Created by main on 5/14/16.
//  Copyright © 2016 Gary Hanson. All rights reserved.
//

import UIKit


final class DigestViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView(frame: CGRect.zero)

    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }
    
    func setImage(_ image: UIImage?) {
        
        self.imageView.frame = self.bounds
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.image = image
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    
    private func commonInit() {
        self.imageView.frame = self.bounds
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.masksToBounds = true
        self.contentView.addSubview(self.imageView)
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5
        //self.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
}
