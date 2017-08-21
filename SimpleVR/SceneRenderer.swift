//
//  SceneRenderer.swift
//  SimpleVR
//
//  Created by James Hughes on 8/22/17.
//  Copyright © 2017 James Hughes. All rights reserved.
//

class SceneRenderer: GVRSceneRenderer {
    
    override func draw(_ headPose: GVRHeadPose!) {
        var pose = headPose.headTransform as! GLKMatrix4
        pose.m12 = -0.2
        pose.m21 =  0.2
        
        super.draw(headPose)
    }
    
    
    func printM4(_ m: GLKMatrix4) {
        print("⎡\(m.m00) \(m.m01) \(m.m02) \(m.m03)⎤")
        print("⎢\(m.m10) \(m.m11) \(m.m12) \(m.m13)⎥")
        print("⎢\(m.m20) \(m.m21) \(m.m22) \(m.m23)⎥")
        print("⎣\(m.m30) \(m.m31) \(m.m32) \(m.m33)⎦")
    }
}
