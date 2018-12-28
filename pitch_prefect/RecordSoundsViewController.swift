//
//  RecordSoundsViewController.swift
//  pitch_prefect
//
//  Created by mohamed on 12/26/18.
//  Copyright © 2018 mohamed. All rights reserved.
//
import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    var audiorecorde : AVAudioRecorder!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var recordAudio: UIButton!
    @IBOutlet weak var recordinglabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecording.isEnabled=false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillapearcall")
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordinglabel.text = "Recording in progress"
        stopRecording.isEnabled = true
        recordAudio.isEnabled = false
       
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audiorecorde = AVAudioRecorder(url: filePath!, settings: [:])
        audiorecorde.delegate=self
        audiorecorde.isMeteringEnabled = true
        audiorecorde.prepareToRecord()
        audiorecorde.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordAudio.isEnabled = true
        stopRecording.isEnabled = false
        recordinglabel.text = "Tap to Record"
        audiorecorde.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier:"StopRecording", sender:audiorecorde.url)
        }else{
            print("The Recording faild...")
        }
    }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="StopRecording"{
            let playSoundVC=segue.destination as! PlaySoundsViewController
            let recordedAudioURL=sender as!URL
            playSoundVC.recordedAudioURL=recordedAudioURL
        }
    }
  
}


