//
//  PhotoDialogViewController.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-12.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class PhotoDialogViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        photoImageView.applyShadow()
    }

    @IBAction func closeButtonWasTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
