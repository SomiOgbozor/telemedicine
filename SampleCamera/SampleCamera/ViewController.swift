//
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
    
    
    func captureButtonPressed() {
        
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let image = UIImage(data: imageData!)!
                    
                    // do image saving here
                    
                }
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func captureButtonAction(_ sender: UIButton) {
        captureButtonPressed()
    }
    
    
    
    @IBAction func flashButtonAction(_ sender: UIButton) {
        
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

