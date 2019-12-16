//
//  DefaultGalleryMainImageTableViewCell.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-09.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

protocol DefaultGalleryMainImageTableViewCellDelegate: class {
    
    /** Callback for favourite button */
    func didTouchHeartButton(cell: DefaultGalleryMainImageTableViewCell, isFavourite: Bool, indexPath: IndexPath)
    
    /** Callback for share button*/
    func didTouchShareButton(cell: DefaultGalleryMainImageTableViewCell, indexPath: IndexPath)
    
    /** Callback for photo view */
    func didTouchImageView(cell: DefaultGalleryMainImageTableViewCell, indexPath: IndexPath)
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /** Update the cell content with real data. */
    func update(_ image: UIImage, isFavourite: Bool = false, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        mainImageView.image = image
        self.isFavourite = isFavourite
        switchHeartButtonStatus()
    }

    /** Image was touched */
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer?) {
        guard let indexPath = indexPath else {
            return
        }
        
        delegate?.didTouchImageView(cell: self, indexPath: indexPath)
    }

    /** Favourite button was touched. */
    @IBAction func heartButtonTouched(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        
        isFavourite = !isFavourite
        switchHeartButtonStatus()
        
        delegate?.didTouchHeartButton(cell: self, isFavourite: isFavourite, indexPath: indexPath)
    }
    
    /** Share button was touched */
    @IBAction func shareButtonTouched(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        
        delegate?.didTouchShareButton(cell: self, indexPath: indexPath)
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
