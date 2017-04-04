
//  ViewController.swift
//  SampleCamera2
//
//  Created by Somi  Ogbozor on 3/9/17.
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
    
    func disPlayCapturedPhoto(capturedPhoto: UIImage) {
        let imagePreviewViewController =  storyboard?.instantiateViewController(withIdentifier:"ImagePreviewViewController")as! ImagePreviewViewController
        imagePreviewViewController.capturedImage = capturedPhoto
        navigationController?.pushViewController(imagePreviewViewController, animated: true)
    }
    
    func takePhoto() {
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
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
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let image = UIImage(data: imageData!)!
                    
                    self.disPlayCapturedPhoto(capturedPhoto: image)
                    
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.takePhoto), userInfo: nil, repeats: false)
                    
                    
                    
                }
            })
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func captureButtonAction(_ sender: UIButton) {
        takePhoto()
    }
    
    
    @IBAction func flashAction(_ sender: Any) {
        if (captureDevice.hasTorch) {
            do {
                try captureDevice.lockForConfiguration()
                if (captureDevice.torchMode == AVCaptureTorchMode.on) {
                    captureDevice.torchMode = AVCaptureTorchMode.off
                } else {
                    do {
                        try captureDevice.setTorchModeOnWithLevel(1.0)
                    } catch {
                        print(error)
                    }
                }
                captureDevice.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        
        
        if captureDevice.torchMode == .on{
            captureDevice.torchMode = .off
        }
        else {
            captureDevice.torchMode = .on
        }
        
    }
    
    
    
    
    
    
    @IBOutlet weak var viewOutlet: UIView!
}

