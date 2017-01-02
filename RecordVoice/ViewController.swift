//
//  ViewController.swift
//  RecordVoice
//
//  Created by Majid iqbal on 27/07/2016.
//  Copyright © 2016 AppDeveloper. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate {

    @IBOutlet var recordingInProgress: UILabel!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillAppear(_ animated: Bool) {
    
        recordingInProgress.isHidden = true
        stopButton.isEnabled = false
     
    
    }
    @IBAction func recordAudio(_ sender: AnyObject) {
        
        recordingInProgress.isHidden = false
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        
        let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),
                              AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),
                              AVNumberOfChannelsKey : NSNumber(value: 1 as Int32),
                              AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue) as Int32)]

        //Audio Session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(url: self.directoryURL()!,
                                                settings: recordSettings)
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
        } catch {
            
            print("audioRecording error")
        }
        
        
        //Audio Recording
        
        if !audioRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch {
            }
        }
      
        
}
    
    
    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        return soundURL
    }

    
    
    @IBAction func stopAudio(_ sender: AnyObject) {
        
        recordButton.isEnabled = true
        stopButton.isEnabled = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
        }
    }

   
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
        }
        else{
            print("unsuccessful")
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let playSoundVC = segue.destination as! PlaySoundsViewController
        
        let recordedAudio = audioRecorder.url
        
        playSoundVC.recordedAudioUrl = recordedAudio
        
        
        
        
    }
    
    
        
}

