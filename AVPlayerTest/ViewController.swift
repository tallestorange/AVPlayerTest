//
//  ViewController.swift
//  AVPlayerTest
//
//  Created by Yuhel Tanaka on 2019/09/05.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class ViewController: UIViewController {
    var player:AVPlayer!
    var playerItem:AVPlayerItem!
    var playerOutput:AVPlayerItemVideoOutput!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var seekBar: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeMovie] as [String]
        present(imagePicker, animated: true)
    }
    
    func getUIImage() -> UIImage? {
        guard let buffer = self.playerOutput.copyPixelBuffer(forItemTime: self.playerItem.currentTime(), itemTimeForDisplay: nil) else {return nil}
        
        let ciImage = CIImage(cvPixelBuffer: buffer)
        let uiImage = UIImage(ciImage: ciImage)
        return uiImage
    }
    
    @IBAction func moveSeekBar() {
        self.player.pause()
        let time = CMTime(seconds: self.playerItem.duration.seconds*Double(self.seekBar.value), preferredTimescale: CMTimeScale(1.0))
        self.player.seek(to: time)
        self.player.play()
    }
}

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let movieURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {return}
        dismiss(animated: true, completion: nil)
        
        let asset = AVAsset(url: movieURL)
        let videoTracks = asset.tracks(withMediaType: .video)
        
        if videoTracks.count > 0 {
            let videoTrack = videoTracks[0]
            
            print(videoTrack.naturalSize.width)
            print(videoTrack.naturalSize.height)
            print(videoTrack.nominalFrameRate)
            print(videoTrack.estimatedDataRate)
            
            playerItem = AVPlayerItem(asset: asset)
            playerOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA])
            playerItem.add(playerOutput)
            player = AVPlayer(playerItem: playerItem)
            player.play()
            
            let interval = CMTime(seconds: 0.5,
                                  preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            // Queue on which to invoke the callback
            let queue = DispatchQueue.global()
            // Add time observer
            player.addPeriodicTimeObserver(forInterval: interval, queue: queue) {
                    [weak self] time in
                    // update player transport UI
                let position = self!.playerItem.currentTime().seconds / self!.playerItem.duration.seconds
                let image = self!.getUIImage()
                DispatchQueue.main.sync {
                    self!.seekBar.value = Float(position)
                    self?.imageView.image = image
                }
            }
        }
    }
}

