//
//  CollectionViewCell.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/14/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionViewImage: UIImageView!
    
    var spot: Spot!
    var photo: Photo!{
        didSet{
            photo.loadImages(spot: spot) { completion in
                if completion {
                    self.collectionViewImage.image = self.photo.image
                } else {
                    print("Error loading the images in collectionviewCell")
                }
            }
            
        }
    }
    
    
    
}
