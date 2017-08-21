//
//  VRViewController.swift
//  SimpleVR
//
//  Created by James Hughes on 8/17/17.
//  Copyright © 2017 James Hughes. All rights reserved.
//

import UIKit
import MobileCoreServices

class VRViewController: UIViewController, GVRRendererViewControllerDelegate {

    private let player: AVPlayer
    private let renderViewController: GVRRendererViewController
    private let sceneRenderer: GVRSceneRenderer
    private let videoRenderer: GVRVideoRenderer
    
    private var videoView: GVRRendererView {
        return self.renderViewController.view as! GVRRendererView
    }
    
    init(url: URL) {
        player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        
        videoRenderer = GVRVideoRenderer()
        videoRenderer.player = player
        videoRenderer.setSphericalMeshOfRadius(50, latitudes: 12, longitudes: 24, verticalFov: 180, horizontalFov: 360, meshType: .monoscopic)

        sceneRenderer = GVRSceneRenderer()
        sceneRenderer.renderList.add(videoRenderer)

        renderViewController = GVRRendererViewController(renderer: sceneRenderer)
        
        super.init(nibName: nil, bundle: nil)
        
        // set up a callback for looping the video
        let selector = #selector(playerItemDidReachEnd)
        let name = NSNotification.Name.AVPlayerItemDidPlayToEndTime
        let object = player.currentItem
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(renderViewController)
        renderViewController.didMove(toParentViewController: self)
        
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
        updateVideoPlayback()
    }
    
    // MARK: - AVPlayer
    
    private dynamic func playerItemDidReachEnd(notification: NSNotification) {
        guard let player = notification.object as? AVPlayerItem else {
            return
        }
        
        player.seek(to: kCMTimeZero)
    }
    
    // MARK: - GVRRendererViewControllerDelegate
    
    func didTapTriggerButton() {
        updateVideoPlayback()
    }
    
    func shouldHideTransitionView() -> Bool {
        return true
    }
    
    func renderer(for displayMode: GVRDisplayMode) -> GVRRenderer! {
        // Hide the reticle in embedded mode.
        sceneRenderer.hidesReticle = (displayMode == .embedded)

        return sceneRenderer
    }
    
    // MARK: - Actions
    
    private func updateVideoPlayback() {
        guard player.rate == 1.0 else {
            player.play()
            return
        }

        player.pause()
    }
}

