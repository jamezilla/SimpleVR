//
//  VRViewController.swift
//  SimpleVR
//
//  Created by James Hughes on 8/17/17.
//  Copyright © 2017 James Hughes. All rights reserved.
//

import UIKit
import MobileCoreServices

//class ViewController: UIViewController, GVRVideoViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
class VRViewController: UIViewController, GVRVideoViewDelegate, UINavigationControllerDelegate {

//    private var isInitialized = false
    private let videoView = GVRVideoView()
    
    var url: URL? {
        didSet {
            videoView.load(from: url, of: GVRVideoType.mono)
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        videoView.delegate = self
        videoView.enableInfoButton = false
        videoView.enableFullscreenButton = false
        videoView.enableCardboardButton = false
        videoView.enableTouchTracking = true
        videoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoView)
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: view.topAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoView.displayMode = .fullscreenVR
        videoView.hidesTransitionView = true
    }

    private func rewind() {
        self.videoView.seek(to: 0)
        self.videoView.play()
    }
   
    // MARK: - GVRVideoViewDelegate
    func widgetViewDidTap(_ widgetView: GVRWidgetView) {
//        loadVideo()
        rewind()
    }
    
//    private func loadVideo() {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .photoLibrary
//            imagePicker.mediaTypes = [kUTTypeMovie as String]
//            imagePicker.allowsEditing = true
//            present(imagePicker, animated: true, completion: nil)
//        }
//    }
   
    func widgetView(_ widgetView: GVRWidgetView, didLoadContent content: Any) {
        print("Finished loading video")

    }
    
    func widgetView(_ widgetView: GVRWidgetView, didFailToLoadContent content: Any, withErrorMessage errorMessage: String) {
        print("Failed to load video: \(errorMessage)")
    }
    
    func videoView(_ videoView: GVRVideoView, didUpdatePosition position: TimeInterval) {
        // Loop the video when it reaches the end.
        if position == videoView.duration() {
            rewind()
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        defer {
//            dismiss(animated:true, completion: nil)
//        }
//       
//        guard let url = info[UIImagePickerControllerMediaURL] as? URL else {
//            print("couln't load url \(String(describing: info[UIImagePickerControllerMediaURL]))")
//            return
//        }
//        
//        videoView.load(from: url, of: GVRVideoType.mono)
//    }

}

