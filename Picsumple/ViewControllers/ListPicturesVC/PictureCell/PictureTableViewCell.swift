//
//  PictureTableViewCell.swift
//  Picsumple
//
//  Created by Dilz Osmani on 18/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit
import Kingfisher

class PictureTableViewCell: UITableViewCell {

    // MARK: - Properties
    private var photo: PhotoMasterCell?
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPhoto(_ photo: PhotoMasterCell) {
        self.photo = photo
        
        self.authorName.text = photo.author
        self.photoView.kf.setImage(with: photo.thumbnailAddress,
                                   placeholder: nil)
    }
    
}
