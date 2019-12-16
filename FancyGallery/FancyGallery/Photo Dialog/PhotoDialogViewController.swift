//
//  PhotoDialogViewController.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-12.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class PhotoDialogViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageContainerView: UIView!
    
    fileprivate var originalImageCenter: CGPoint?
    
    fileprivate var enablePanGesture = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinch.delegate = self
        self.imageContainerView.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        pan.delegate = self
        self.imageContainerView.addGestureRecognizer(pan)
    }
    
    /**
     * Allow the user to pan the image inside the view frame.
     * To enable the pan gesture, the user has to zoom in (pinch) the image first.
     */
    @objc func pan(sender: UIPanGestureRecognizer) {
        
        if enablePanGesture {
            if sender.state == .began {
                
                if self.originalImageCenter == nil {
                    self.originalImageCenter = sender.view?.center
                }
                
            } else if sender.state == .changed {
                
                guard let originalImageCenter = originalImageCenter else {
                    return
                }
                
                let translation = sender.translation(in: self.imageContainerView)
                
                if let view = sender.view {
                    let y = view.center.y + translation.y
                    let x = view.center.x + translation.x
                    
                    //If the image is going out of the frame, then center it
                    if y > 900 || y < -30 || x < originalImageCenter.x - 320 || x > originalImageCenter.x + 300 {
                        let imageView = sender.view
                        let targetY = CGFloat(imageView!.frame.minY)
                        let currentScale = self.photoImageView.frame.size.width / self.photoImageView.bounds.size.width
                        
                        if currentScale > 1.3, targetY > 300 {
                            //If the image is scaled, Center the image according to the top
                            UIView.animate(withDuration: 0.3, animations: {
                                view.center = CGPoint(x: originalImageCenter.x,
                                                      y: originalImageCenter.y + 300)
                            })
                        } else if currentScale > 1.3, targetY < 0 {
                            //If the image is scaled, Center the image according to the bottom
                            UIView.animate(withDuration: 0.3, animations: {
                                view.center = CGPoint(x: originalImageCenter.x,
                                                      y: originalImageCenter.y - 300)
                            })
                        } else {
                            //If the image is not scaled, center the image according to the whole view
                            UIView.animate(withDuration: 0.3, animations: {
                                view.center = CGPoint(x: originalImageCenter.x,
                                                      y: originalImageCenter.y)
                            })
                        }
                    } else {
                        //Let the user pan the image inside the frame
                        view.center = CGPoint(x: x, y: y)
                    }
                }
                
                sender.setTranslation(CGPoint.zero, in: self.photoImageView.superview)
                
            }
        } else {
            
            //When the user did zoom out and returns the image to the original size, then center it
            if let originalImageCenter = self.originalImageCenter, let view = sender.view {
                view.center = CGPoint(x: originalImageCenter.x,
                                      y: originalImageCenter.y)
            }
            
            sender.setTranslation(CGPoint.zero, in: self.photoImageView.superview)
        }
    }
    
    /**
     * Allow the user to pinch the image (Zoom in and Zoom out).
     */
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        
        if sender.state == .began {
            
            let currentScale = self.photoImageView.frame.size.width / self.photoImageView.bounds.size.width
            
            let newScale = currentScale*sender.scale
            if newScale > 1 {
                enablePanGesture = true
            }
            
        } else if sender.state == .changed {
            
            if sender.state == .began || sender.state == .changed {
                
                let currentScale = self.photoImageView.frame.size.width / self.photoImageView.bounds.size.width
                
                var newScale = currentScale*sender.scale
                
                if newScale <= 1 {
                    newScale = 1
                } else {
                    enablePanGesture = true
                }
                
                if newScale > 1.8 {
                    newScale = 1.8
                }
                
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                
                self.photoImageView.transform = transform
                
                sender.scale = 1
                
            }
            
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            
            let currentScale = self.photoImageView.frame.size.width / self.photoImageView.bounds.size.width
            if currentScale == 1 {
                enablePanGesture = false
            }
        }
        
    }

    @IBAction func closeButtonWasTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
