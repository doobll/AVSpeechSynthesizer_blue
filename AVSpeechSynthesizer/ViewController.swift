//
//  ViewController.swift
//  AVSpeechSynthesizer
//
//  Created by Judy chen on 2022/1/3.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {


    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    
    
    @IBOutlet weak var volumeShuffleButton: UIButton!
    
    @IBOutlet weak var rateShuffleButton: UIButton!
    
    @IBOutlet weak var pitchShuffleButton: UIButton!
    
    
    @IBOutlet weak var volumeSwitch: UISwitch!
    @IBOutlet weak var rateSwitch: UISwitch!
    @IBOutlet weak var pitchSwitch: UISwitch!
    
    var volumeValue = 0.5
    var rateValue = 0.5
    var pitchValue = 1.0
    let language = ["zh-TW","en-US","ja-JP"]
    var index = 0
    
    let synthesizer = AVSpeechSynthesizer()
    
    //自訂function區
    func speak(language:String){
        let speechUtterance = AVSpeechUtterance(string: textView.text!)
        volumeValue = Double(volumeSlider.value)
        rateValue = Double(rateSlider.value)
        pitchValue = Double(pitchSlider.value)
        speechUtterance.volume = volumeSlider.value
        speechUtterance.rate = rateSlider.value
        speechUtterance.pitchMultiplier = pitchSlider.value
        speechUtterance.voice = AVSpeechSynthesisVoice(language:language)
        synthesizer.speak(speechUtterance)

    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateAllValue(self)
    }
    
    
    
    @IBAction func play(_ sender: UIButton) {
        if synthesizer.isSpeaking == false{
            index = languageSegmentedControl.selectedSegmentIndex
            let selectedVoice = language[index]
            speak(language: selectedVoice)
        }else{
            synthesizer.continueSpeaking()
        }
        print("languageIndex:",index)
        print("play volume: \(volumeValue), rate: \(rateValue),pitch: \(pitchValue)")
        view.endEditing(true)  //點選播放鍵後收鍵盤
        
    }
    
    //點選後馬上暫停播放 (之後點播放鍵會從暫停的地方繼續播放)
    @IBAction func pause(_ sender: UIButton) {
        if synthesizer.isSpeaking{
            synthesizer.pauseSpeaking(at: .immediate)
        }
    }

    
    //點選後馬上停止播放 (之後點播放鍵會從頭播放)
    @IBAction func stop(_ sender: Any) {
        if synthesizer.isSpeaking{
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    
    //滑動全部slider數值時，讓Label數值跟著變動
    @IBAction func changeLabelValue(_ sender: Any) {
        volumeValue = Double(volumeSlider.value)
        rateValue = Double(rateSlider.value)
        pitchValue = Double(pitchSlider.value)
        volumeLabel.text = String(format: "%.2f", volumeSlider.value)
        rateLabel.text = String(format: "%.2f", rateSlider.value)
        pitchLabel.text = String(format: "%.2f", pitchSlider.value)
        
    }
    
    //隨機設定音量slider數值，讓音量Label數值跟著變動
    @IBAction func volumeShuffleValue(_ sender: Any) {
        volumeValue = Double.random(in: 0...1)
        volumeSlider.value = Float(volumeValue)
        print("volumeRandom:\(volumeValue)")
        volumeLabel.text = String(format:"%.2f",volumeSlider.value)

    }

    //隨機設定速度slider數值，讓速度Label數值跟著變動
    @IBAction func rateShuffleValue(_ sender: Any) {
        rateValue = Double.random(in: 0...1)
        rateSlider.value = Float(rateValue)
        print("rateRandom:",rateValue)
        rateLabel.text = String(format:"%.2f",rateSlider.value)
    }
    
    //隨機設定音高slider數值，讓音高Label數值跟著變動
    @IBAction func pitchShuffleValue(_ sender: Any) {
        pitchValue = Double.random(in: 0.5...2)
        pitchSlider.value = Float(pitchValue)
        print("pitchRandom:",pitchValue)
        pitchLabel.text = String(format:"%.2f",pitchSlider.value)
    }
    
    // 隨機設定全部slider數值，讓Label數值跟著變動
    @IBAction func setAllValueRandomly(_ sender: UIButton) {
        if volumeSwitch.isOn == false{
            self.volumeShuffleValue(self)
        }
        if rateSwitch.isOn == false{
            self.rateShuffleValue(self)
        }
        if pitchSwitch.isOn == false{
            self.pitchShuffleValue(self)
        }

        print("All Randomly set volume:\(volumeValue),rate:\(rateValue),pitch:\(pitchValue)")
    }

    
    //switch初始是off,如果on了就無法操作slider和隨機鈕(固定住volumeSlider的值)
    @IBAction func volumeIsSwitchedOn(_ sender: UISwitch) {
        if sender.isOn{
            volumeSlider.isEnabled = false
            volumeShuffleButton.isEnabled = false
        }else{
            volumeSlider.isEnabled = true
            volumeShuffleButton.isEnabled = true
        }
    }
    
    //switch初始是off,如果on了就無法操作slider和隨機鈕(固定住rateSlider的值)
    @IBAction func rateIsSwitchedOn(_ sender: UISwitch) {
        if sender.isOn{
            rateSlider.isEnabled = false
            rateShuffleButton.isEnabled = false
        }else{
            rateSlider.isEnabled = true
            rateShuffleButton.isEnabled = true
        }
    }
    
    //switch初始是off,如果on了就無法操作slider和隨機鈕(固定住pitchSlider的值)
    @IBAction func pitchIsSwitchedOn(_ sender: UISwitch) {
        if sender.isOn{
            pitchSlider.isEnabled = false
            pitchShuffleButton.isEnabled = false
        }else{
            pitchSlider.isEnabled = true
            pitchShuffleButton.isEnabled = true
        }
    }
    
    //1. 將全部slider和Label數值回歸初始值
    //2. 如果有任何switch是on的狀態，全部回關off (slider數值才能變動)
    //3. 讓各slider的隨機鈕回歸可選取狀態
    @IBAction func updateAllValue(_ sender: Any) {
        volumeValue = 0.5
        rateValue = 0.5
        pitchValue = 1.0
        
        volumeSlider.value = Float(volumeValue)
        rateSlider.value = Float(rateValue)
        pitchSlider.value = Float(pitchValue)
        volumeLabel.text = String(format: "%.2f", volumeValue)
        rateLabel.text = String(format:"%.2f",rateValue)
        pitchLabel.text = String(format:"%.2f",pitchValue)
        
        languageSegmentedControl.selectedSegmentIndex = index
        
        if volumeSwitch.isOn{
            volumeSwitch.isOn = false
            volumeSlider.isEnabled = true
            volumeShuffleButton.isEnabled = true
            
        }
        if rateSwitch.isOn{
            rateSwitch.isOn = false
            rateSlider.isEnabled = true
            rateShuffleButton.isEnabled = true
            
        }
            
        if pitchSwitch.isOn{
            pitchSwitch.isOn = false
            pitchSlider.isEnabled = true
            pitchShuffleButton.isEnabled = true
        }
        print("updated volume:\(volumeValue),rate:\(rateValue),pitch:\(pitchValue)")
            
    }
    
   


}




