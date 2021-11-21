//
//  CollectionViewCell.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/14/21.
//

import UIKit
import SDWebImage

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionViewImage: UIImageView!
    
    var spot: Spot!
    var photo: Photo!{
     
        didSet{
            
            if let url = URL(string: photo.photoURL) {
                self.collectionViewImage.sd_setImage(with: url)
                self.collectionViewImage.sd_imageTransition = .fade
                
                print("Error: the photoURL was found nil in the collectionView cell")
                
            } else {
                
                photo.loadImages(spot: spot) { completion in
                    if completion {
                        self.photo.savePhotoData(spot: self.spot) { success in
                            print("Image got updated with url")
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
    
    
}
