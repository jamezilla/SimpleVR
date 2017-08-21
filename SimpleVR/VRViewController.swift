//
//  VRViewController.swift
//  SimpleVR
//
//  Created by James Hughes on 8/17/17.
//  Copyright © 2017 James Hughes. All rights reserved.
//

import UIKit
import MobileCoreServices

class VRViewController: UIViewController, GVRVideoViewDelegate {

    private let videoView = GVRVideoView()
    
    var url: URL? {
        didSet {
            videoView.load(from: url, of: GVRVideoType.mono)
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        videoView.delegate = self
        videoView.displayMode = .fullscreenVR
        videoView.enableCardboardButton = false
        videoView.enableInfoButton = false
        videoView.enableFullscreenButton = false
        videoView.enableTouchTracking = true
        videoView.hidesTransitionView = true
        videoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoView)
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: view.topAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func rewind() {
        self.videoView.seek(to: 0)
        self.videoView.play()
    }
   
    // MARK: - GVRVideoViewDelegate
    func widgetViewDidTap(_ widgetView: GVRWidgetView) {
        rewind()
    }
   
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
}

