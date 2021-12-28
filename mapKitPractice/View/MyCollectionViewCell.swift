//
//  CollectionViewCell.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/14/21.
//

import UIKit
import SDWebImage

class MyCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var collectionViewImage: UIImageView!
    
    var spot: Spot!
    var photo: Photo!{
        didSet{
            // Load the images using SDWebImage
            if let url = URL(string: photo.photoURL) {
                collectionViewImage.sd_setImage(with: url)
                collectionViewImage.sd_imageTransition = .fade
                print("Error: the photoURL was found nil in the collectionView cell") // <-- why this is here?
            } else {
                // use the old loadImages function (for legacy images)
                photo.loadImages(spot: spot) { [weak self] completion in
                    guard let self = self else {return}
                    if completion {
                        // save the photo data so it would be transitioned to the url based image loading system
                        self.photo.savePhotoData(spot: self.spot) { success in
                            print("Image got updated with url")
                        }
                    }
                }
            }
        }
    }
}
