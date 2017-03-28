//
//  AudioPlayer.swift
//  TreePlantingAudio
//
//  Created by Cris Uy on 27/03/2017.
//  Copyright © 2017 Ecosia. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

public protocol AudioPlayerDelegate : NSObjectProtocol {
    
    func audioPlayerDidFinishPlaying()
    
}

class AudioPlayer: NSObject {
    
    var audioPlayer         = AVAudioPlayer()
    var currentAudioIndex   = 0
    var audioLength         = 0.0
    var audioItemList       = [AudioItem]()
    
    var currentAudioItem:AudioItem!
    var delegate:AudioPlayerDelegate?
    
    func prepareAudio() {
        
        currentAudioItem = audioItemList[currentAudioIndex]
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer = AVAudioPlayer(contentsOf: currentAudioItem.audioURL as URL)
            audioPlayer.delegate = self
            audioLength = audioPlayer.duration
            audioPlayer.prepareToPlay()
            
        } catch {
            
        }
    }
    
    func playPauseAudio() {
        
        if audioPlayer.isPlaying {
            pauseAudio()
        } else {
            playAudio()
        }
    }
    
    func playAudio(){
        audioPlayer.play()
    }
    
    func stopAudio() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
    }
    
    func pauseAudio() {
        audioPlayer.pause()
    }
    
    func nextAudio() {
        currentAudioIndex += 1
        
        if currentAudioIndex > audioItemList.count - 1 {
            currentAudioIndex -= 1
            
            return
        }
        
        prepareAudio()
        playAudio()
    }
    
    func previousAudio() {
        currentAudioIndex -= 1
        
        if currentAudioIndex < 0 {
            currentAudioIndex += 1
            return
        }
        
        prepareAudio()
        playAudio()
        
    }
    
    func playAudioWithIndex(index: Int) {
        
        currentAudioIndex = index
        
        prepareAudio()
        playAudio()
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            currentAudioIndex += 1
            if currentAudioIndex > audioItemList.count - 1 {
                currentAudioIndex -= 1
                return
            }
            
            prepareAudio()
            playAudio()
            
            delegate?.audioPlayerDidFinishPlaying()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
    
}
