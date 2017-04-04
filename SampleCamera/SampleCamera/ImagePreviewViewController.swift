//
//  ImagePreviewViewController.swift
//  SampleCamera
//
//  Created by Somi  Ogbozor on 3/9/17.
//  Copyright © 2017 Somi  Ogbozor. All rights reserved.
//

import Foundation
import UIKit

class ImagePreviewController : UIViewController{

@IBOutlet weak var capturedImageView: UIImageView!
    
    var capturedImage : UIImage?
    
    
    
override func viewDidLoad() {
    super.viewDidLoad()
  
    capturedImageView.image = capturedImage
    
    // Do any additional setup after loading the view, typically from a nib.
}
}
