//
//  CameraPreviewViewController.swift
//  SC13-Experiences
//
//  Created by Andrew Dhan on 10/19/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewControlDelegate: class {
    func didFinishRecording(atURL url: URL)
}

class CameraViewController: UIViewController,AVCaptureFileOutputRecordingDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.setupCaptureSession()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupCaptureSession()
                }
            }
            
        case .denied: // The user has previously denied access.
            return
        case .restricted: // The user can't grant access due to restrictions.
            return
        }
    }
    
    @IBAction func record(_ sender: Any) {
        if recordOutput.isRecording{
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: URL.newRecordingURL(mediaType: .video), recordingDelegate: self)
        }
    }
    
    func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video, position: .unspecified)
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        captureSession.addInput(videoDeviceInput)
      
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        previewView.videoPreviewLayer.session = captureSession
    }
    //MARK: Delegate Method
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        recordButton.setImage(UIImage(named: "Start"), for: .normal)
        
    }
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        recordButton.setImage(UIImage(named: "Stop"), for: .normal)
        delegate?.didFinishRecording(atURL: outputFileURL)
    }
    //MARK: - Properties
    
    weak var delegate:CameraViewControlDelegate?
    
    private var captureSession: AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var recordButton: UIButton!
}
