//
//  ViewController.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-09.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

/* BaseViewController is responsible to have common implementatinos that would be used from different view controllers. */
public class BaseViewController: UIViewController {
    
    /* Activity indicator responsible to present the loading status while requesting data.*/
    let activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator    = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color  = UIColor.darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
    }
    
    /* Show/hide activity indicator. */
    func displayActivityIndicator(_ display: Bool) {
        if display {
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
