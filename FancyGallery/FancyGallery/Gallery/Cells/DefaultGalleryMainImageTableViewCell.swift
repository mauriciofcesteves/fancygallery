//
//  DefaultGalleryMainImageTableViewCell.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-09.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class DefaultGalleryMainImageTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /** Update the cell content with real data. */
    func update(_ image: UIImage) {
        mainImageView.image = image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
