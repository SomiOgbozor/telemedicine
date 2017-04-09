//
//  ViewController.swift
//  BetaCamera
//
//  Created by Somi  Ogbozor on 4/8/17.
//  Copyright © 2017 Somi  Ogbozor. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private var captureDevice: AVCaptureDevice!
    private var captureSession: AVCaptureSession!
    private var stillImageOutput: AVCaptureStillImageOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var timer : Timer!
    
    




    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func setupCamera() {
        
        captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo))
        } catch  {
            input = nil
        }
        
        captureSession!.addInput(input)
        captureSession!.addOutput(stillImageOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.viewOutlet.frame
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.viewOutlet.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
        
    }
    
    func takePhoto() {
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let image = UIImage(data: imageData!)!
                    
                    self.disPlayCapturedPhoto(capturedPhoto: image)
                    
                }
            })
            
        }
        
    }
    
    func disPlayCapturedPhoto(capturedPhoto: UIImage) {
        let imagePreviewViewController =  storyboard?.instantiateViewController(withIdentifier:"ImagePreviewViewController")as! ImagePreviewViewController
        imagePreviewViewController.capturedImage = capturedPhoto
        navigationController?.pushViewController(imagePreviewViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func captureButtonAction(_ sender: Any) {
        if (self.captureDevice.hasTorch) {
            do {
                try self.captureDevice.lockForConfiguration()
                if (self.captureDevice.torchMode == AVCaptureTorchMode.on) {
                    self.captureDevice.torchMode = AVCaptureTorchMode.off
                } else {
                    do {
                        try self.captureDevice.setTorchModeOnWithLevel(1.0)
                    } catch {
                        print(error)
                    }
                }
                self.captureDevice.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(takePhoto), userInfo: nil, repeats: false)
        
        takePhoto()
    }
    

    @IBOutlet weak var viewOutlet: UIImageView!
    

}

