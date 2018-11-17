//
//  sSpeechCommandsView.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 07/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class SpeechView: UIView
{
    // MARK: - Property(s)
    
    private(set) lazy var button: UIButton =
    { [unowned self] in
        
        let anObject = UIButton(frame: .zero)
        anObject.setBackgroundImage(UIImage(named: "Commlink"), for: .normal)
        
        self.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Initialisation
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.layoutMargins = .zero
        
        self.updateLayout(nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
}

// MARK: - GeometryLayout
extension SpeechView: GeometryLayout
{
    func updateLayout(_ container: UIView?)
    {
        let guide = self.layoutMarginsGuide
        let radius: CGFloat = 100
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.widthAnchor.constraint(equalToConstant: radius).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: radius).isActive = true
        self.button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0).isActive = true
        self.button.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: 0.0).isActive = true
        self.button.layer.cornerRadius = radius*0.5
    }
}

