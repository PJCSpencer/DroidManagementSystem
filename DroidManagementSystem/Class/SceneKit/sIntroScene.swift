//
//  sIntroScene.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 10/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import SceneKit


class IntroScene: SCNScene
{
    // MARK: - Property(s)
    
    // https://www.spacetelescope.org/images/archive/category/galaxies/
    var galaxyFarFarAway: [String] = ["left.jpg", "right.jpg", "top.jpg", "bottom.jpg", "front.jpg", "back.jpg"]
    
    var isBackgroundVisible: Bool = true
    {
        didSet
        { self.background.contents = isBackgroundVisible ? self.galaxyFarFarAway : [] }
    }
    
    private(set) lazy var camera: SCNNode =
    { [unowned self] in
        
        let anObject = SCNNode()
        anObject.camera = SCNCamera()
        anObject.camera?.zNear = 0.1
        anObject.camera?.zFar = 1000.0
        anObject.position = SCNVector3(0, 0, 17)
        
        self.rootNode.addChildNode(anObject)
        return anObject
    }()
    
    private(set) lazy var korriban: SCNNode =
    { [unowned self] in
        
        let sphere = SCNSphere(radius: 600.0)
        sphere.segmentCount = 72
        
        let anObject: SCNNode = SCNNode(geometry: sphere)
        anObject.position = SCNVector3(x: 200, y: 700, z: 100)
        anObject.rotation = SCNVector4(1, 1, 0, GLKMathDegreesToRadians(220))

        anObject.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Korriban.jpg")
        anObject.geometry?.firstMaterial?.ambient.contents = UIColor(red: 0.2, green: 0, blue: 0, alpha: 1.0)
        anObject.geometry?.firstMaterial?.emission.contents = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        
        self.rootNode.addChildNode(anObject)
        return anObject
    }()
    
    private(set) lazy var intro: IntroTextNode =
    { [unowned self] in
        
        let anObject = IntroTextNode()
        anObject.rotation = SCNVector4(1, 0, 0, GLKMathDegreesToRadians(-66))
        
        self.rootNode.addChildNode(anObject)
        return anObject
    }()
}

extension IntroScene
{
    func run(completion: @escaping () -> Void)
    {
        let _ = self.korriban
        
        guard let geometry = self.intro.text.geometry else
        { return }
        
        self.fogStartDistance = 0
        self.fogEndDistance = 30
        self.fogColor = UIColor.black.cgColor
        
        let animDuration: TimeInterval = 40
        let fadeDuration: TimeInterval = 2.0
        let dy: CGFloat = CGFloat(geometry.boundingBox.max.y * 1.25)
        
        let move = SCNAction.moveBy(x: 0, y: dy, z: 0, duration: animDuration)
        self.intro.text.runAction(move)
        
        let wait = SCNAction.wait(duration: animDuration - fadeDuration)
        let fade = SCNAction.fadeOpacity(to: 0.0, duration: fadeDuration)
        self.intro.text.runAction(SCNAction.sequence([wait, fade]))
        {
            self.fogStartDistance = 0
            self.fogEndDistance = 0
        }
        
        let w1 = SCNAction.wait(duration: animDuration + 1)
        let rotate = SCNAction.rotateBy(x: CGFloat(GLKMathDegreesToRadians(80)),
                                        y: 0,
                                        z: CGFloat(GLKMathDegreesToRadians(-15)),
                                        duration: 10)
        rotate.timingMode = .easeInEaseOut
        self.camera.runAction(SCNAction.sequence([w1, rotate])) { completion() }
    }
}

