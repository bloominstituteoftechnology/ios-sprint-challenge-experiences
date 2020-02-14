//
//  ExperienceVideoViewController.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import AVFoundation
import UIKit

class ExperienceVideoViewController: UIViewController {
    
    var experience: Experience?
    
    let cameraView: CameraPreviewView = {
        let cameraView = CameraPreviewView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.backgroundColor = .systemBlue
        return cameraView
    }()
    
    let recordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
        button.tintColor = .systemRed
        button.setPreferredSymbolConfiguration(.init(font: .systemFont(ofSize: 80), scale: .default), forImageIn: .normal)
        return button
    }()
    
    private lazy var captureSession = AVCaptureSession()
    private lazy var fileOutput = AVCaptureMovieFileOutput()
    private var videoURL: URL?
    var isRecording: Bool {
        fileOutput.isRecording
    }
    
    override func viewDidLoad() {
        configure()
        setupCamera()
        configureNavigationController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func configureNavigationController() {
        title = "Record a video"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(dismissAndSave))
    }
    
    @objc private func dismissAndSave() {
        guard let experience = experience,
            let videoURL = videoURL,
            let coordinates = LocationManager.shared.getLocation()
            else { return }
        experience.video = videoURL.absoluteString
        experience.latitude = coordinates.latitude as Double
        experience.longitude = coordinates.longitude as Double
        try? CoreDataStack.shared.save()
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupCamera() {
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    }
    
    @objc private func recordTapped() {
        toggleRecordingMode()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(cameraView)
        cameraView.addSubview(recordButton)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func updateViews() {
        let recordButtonImage =  isRecording ? "stop.circle" : "smallcircle.fill.circle"
        recordButton.setImage(UIImage(systemName: recordButtonImage), for: .normal)
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No cameras available on device (or running in the Simulator)")
        
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError()
    }
    
    private func toggleRecordingMode() {
        guard let experience = experience, let title = experience.title else { return }
        if isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: URL.makeNewVideoURL(with: title), recordingDelegate: self)
        }
    }
}

extension ExperienceVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        self.videoURL = outputFileURL
        updateViews()
    }
}