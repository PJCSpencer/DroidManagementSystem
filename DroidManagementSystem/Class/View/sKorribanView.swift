//
//  sKorribanView.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 02/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import SceneKit


class KorribanView: UIView
{
    private(set) lazy var background: UIImageView =
    { [unowned self] in
        
        let anObject = UIImageView(frame: .zero)
        anObject.contentMode = .scaleAspectFill
        
        self.addSubview(anObject)
        return anObject
    }()
    
    private lazy var overlay: UIImageView =
    { [unowned self] in
        
        let anObject = UIImageView(frame: .zero)
        anObject.contentMode = .scaleAspectFill
        
        self.insertSubview(anObject, aboveSubview: self.background)
        return anObject
    }()
    
    private(set) lazy var sceneView: SCNView =
    { [unowned self] in
        
        let anObject = SCNView(frame: .zero, options: [:])
        anObject.autoenablesDefaultLighting = true
        anObject.antialiasingMode = .multisampling2X
        anObject.backgroundColor = UIColor.clear
        
        self.insertSubview(anObject, aboveSubview: self.overlay)
        return anObject
    }()
    
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.background.frame = self.bounds
        self.overlay.frame = self.bounds
        self.sceneView.frame = self.bounds
    }
}

extension KorribanView
{
    // NB:This was a last resort. https://github.com/lionheart/openradar-mirror/issues/7158
    
    func setOverlayImage(_ image: UIImage, animated: Bool)
    {
        self.overlay.alpha = 0.0
        self.overlay.image = image
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.0,
                       options: [],
                       animations: { self.overlay.alpha = 0.9 },
                       completion: nil)
    }
}

