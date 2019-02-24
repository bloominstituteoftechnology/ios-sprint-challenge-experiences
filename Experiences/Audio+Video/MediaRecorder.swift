//
//  MediaRecorder.swift
//  LambdaTimeline
//
//  Created by TuneUp Shop  on 2/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import AVFoundation

protocol RecorderDelegate: AnyObject {
    func recorderDidChangeState(_ recorder: Recorder)
}

class Recorder: NSObject {
    
    private var audioRecorder: AVAudioRecorder?
    
    private(set) var currentFile: URL?
    
    weak var delegate: RecorderDelegate?
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    func toggleRecording() {
        if isRecording {
            stop()
        }else {
            record()
        }
    }
    
    func record(){
        let fm = FileManager.default
        let docs = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let file = docs.appendingPathComponent(name).appendingPathExtension("caf")
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        currentFile = file
        
        audioRecorder?.record()
        notifyDelegate()
        
    }
    
    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        notifyDelegate()
    }
    
    func createCommentFromAudio() {
        guard let audioData = currentFile else {
            NSLog("Audio File Error")
            return
        }
    }
    
    private func notifyDelegate() {
        delegate?.recorderDidChangeState(self)
    }
}
