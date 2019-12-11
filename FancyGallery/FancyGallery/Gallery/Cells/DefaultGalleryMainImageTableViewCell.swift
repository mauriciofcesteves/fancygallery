//
//  DefaultGalleryMainImageTableViewCell.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-09.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

protocol DefaultGalleryMainImageTableViewCellDelegate: class {
    func didTouchHeartButton(cell: DefaultGalleryMainImageTableViewCell, isFavourite: Bool, indexPath: IndexPath)
}

class DefaultGalleryMainImageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var cellContainerView: UIView!
    
    // MARK: - General Variables
    weak var delegate: DefaultGalleryMainImageTableViewCellDelegate?
    private var indexPath: IndexPath?
    private var isFavourite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.cellContainerView.layer.cornerRadius = 8
        self.cellContainerView.layer.cornerRadius = 8
        self.cellContainerView.applyShadow()
    }
    
    /** Update the cell content with real data. */
    func update(_ image: UIImage, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        mainImageView.image = image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /** Favourite button was touched. */
    @IBAction func heartButtonTouched(_ sender: Any) {
        isFavourite = !isFavourite
        switchHeartButtonStatus()
        
        guard let indexPath = indexPath else {
            return
        }
        
        delegate?.didTouchHeartButton(cell: self, isFavourite: isFavourite, indexPath: indexPath)
    }
    
    /** Switch the favourite button to the active/unactive status. */
    func switchHeartButtonStatus() {
        
        if !isFavourite {
            heartButton.setImage(UIImage(named: "heart"), for: .normal)
        } else {
            heartButton.setImage(UIImage(named: "heartActive"), for: .normal)
        }
    }
}
