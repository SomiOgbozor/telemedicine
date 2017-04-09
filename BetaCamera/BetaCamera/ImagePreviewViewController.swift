//
//  ImagePreviewViewController.swift
//  BetaCamera
//
//  Created by Somi  Ogbozor on 4/9/17.
//  Copyright © 2017 Somi  Ogbozor. All rights reserved.
//

import Foundation
import UIKit

class ImagePreviewViewController : UIViewController{
    
    var capturedImage : UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = capturedImage
        
    }
    
}

