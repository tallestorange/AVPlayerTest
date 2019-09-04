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
    var openCV:CVWrapper!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var seekBar: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeMovie] as [String]
        openCV = CVWrapper()
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func moveSeekBar() {
        let position = Double(self.seekBar.value)
        self.openCV.seek(position)
        openCV.readFrame()
        let image = openCV.outputUIImage()
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let movieURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {return}
        dismiss(animated: true, completion: nil)
        
        openCV.readFile(movieURL.path)
        openCV.readFrame()
        let image = openCV.outputUIImage()
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}

