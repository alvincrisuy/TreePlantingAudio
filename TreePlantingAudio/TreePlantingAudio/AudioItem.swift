//
//  AudioItem.swift
//  TreePlantingAudio
//
//  Created by Cris Uy on 27/03/2017.
//  Copyright © 2017 Ecosia. All rights reserved.
//

import UIKit
import AVFoundation

class AudioItem: NSObject {
    
    let audioType = "mp3"
    
    var title:String?
    var album:String?
    var artist:String?
    var author:String?
    
    var audioURL:URL!
    var audioItem:AVPlayerItem!
    
    var totalSeconds:Int!
    var hours:Int!
    var minutes:Int!
    var seconds:Int!
    
    public init(filename: String) {
        super.init()
        
        audioURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: audioType)!) as URL!
        audioItem = AVPlayerItem(url: audioURL)
        
        parseMetadata(items: audioItem.asset.metadata)
        duration(asset: audioItem.asset)
    }
    
    func parseMetadata(items:[AVMetadataItem]) {
        
        items.forEach { (item) in
            if let commonKey = item.commonKey {
                switch commonKey {
                case AVMetadataCommonKeyTitle:
                    title = item.value as! String?
                    break
                case AVMetadataCommonKeyArtist:
                    artist = item.value as! String?
                    break
                case AVMetadataCommonKeyAuthor:
                    author = item.value as! String?
                    break
                case AVMetadataCommonKeyAlbumName:
                    album = item.value as! String?
                    break
                default:
                    break
                }
            }
        }
        
        title   = title     ?? ""
        artist  = artist    ?? ""
        author  = author    ?? ""
        album   = album     ?? ""
    }
    
    func duration(asset: AVAsset) {
        
        totalSeconds = Int(CMTimeGetSeconds(asset.duration))
        
        hours   = totalSeconds / 3600
        minutes = totalSeconds / 60
        seconds = totalSeconds % 60
    }
}
