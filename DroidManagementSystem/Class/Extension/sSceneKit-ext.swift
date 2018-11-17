//
//  sSceneKit-ext.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 02/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import SceneKit


class IntroTextNode: SCNNode
{
    private(set) lazy var text: SCNNode =
    { [unowned self] in
        
        let geometry = SCNText(string: String.intro, extrusionDepth: 0.0)
        geometry.font = UIFont.boldSystemFont(ofSize: 1)
        geometry.alignmentMode = CATextLayerAlignmentMode.justified.rawValue
        geometry.isWrapped = true
        geometry.containerFrame = CGRect(origin: .zero, size: CGSize(width: 16, height: 40))
        
        let anObject: SCNNode = SCNNode(geometry: geometry)
        anObject.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        anObject.position = SCNVector3(-(geometry.boundingBox.max.x*0.5),
                                       -(geometry.boundingBox.max.y*1.3), 0)
        
        self.addChildNode(anObject)
        return anObject
    }()
    
    
    override init()
    {
        super.init()
        
        let _ = self.text
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
}

