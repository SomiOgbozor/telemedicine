//
//  PhotoViewController.swift
//  SampleCamera
//
//  Created by Somi  Ogbozor on 4/2/17.
//  Copyright © 2017 Somi  Ogbozor. All rights reserved.
//
import Foundation
import UIKit

class ImagePreviewViewController : UIViewController{
    
    var capturedImage : UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = capturedImage
        
    }
    
    
    
}

