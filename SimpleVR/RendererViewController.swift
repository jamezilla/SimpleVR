//
//  RendererViewController.swift
//  SimpleVR
//
//  Created by James Hughes on 8/21/17.
//  Copyright © 2017 James Hughes. All rights reserved.
//

import Foundation
import MobileCoreServices

class RendererViewController: GVRRendererViewController, GVRRendererViewControllerDelegate {
    
    private let player: AVPlayer

    private lazy var sceneRenderer: GVRSceneRenderer = {
        let sr = GVRSceneRenderer()
        sr.hidesReticle = true
        sr.renderList.add(self.videoRenderer)
        sr.add(toHeadRotationYaw: 0, andPitch: -0.125)
        return sr
    }()
    
    private let videoRenderer: GVRVideoRenderer = {
        let vr = GVRVideoRenderer()
        vr.setSphericalMeshOfRadius(50, latitudes: 12, longitudes: 24, verticalFov: 180, horizontalFov: 360, meshType: .monoscopic)
        return vr
    }()

    init(url: URL) {
        player = AVPlayer(url: url)

        super.init(nibName: nil, bundle: nil)

        player.actionAtItemEnd = .none
        videoRenderer.player = player
        
        // set up a callback for looping the video
        let selector = #selector(playerItemDidReachEnd)
        let name = NSNotification.Name.AVPlayerItemDidPlayToEndTime
        let object = player.currentItem
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let renderView = GVRRendererView(renderer: sceneRenderer)
        renderView?.vrModeEnabled = true
        view = renderView
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
    
    func renderer(for displayMode: GVRDisplayMode) -> GVRRenderer! {
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
