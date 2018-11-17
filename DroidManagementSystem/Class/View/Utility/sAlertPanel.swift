//
//  sAlertPanel.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 08/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class AlertPanel: UIView
{
    // MARK: - Property(s)
    
    private(set) lazy var imageView: UIImageView =
    { [unowned self] in
         
        let anObject = UIImageView(frame: .zero)
        anObject.contentMode = .center
        
        self.addSubview(anObject)
        return anObject
    }()
    
    private(set) lazy var titleLabel: UILabel =
    { [unowned self] in
        
        let anObject = UILabel(frame: .zero)
        anObject.font = UIFont.boldSystemFont(ofSize: 16)
        
        self.addSubview(anObject)
        return anObject
    }()
    
    private(set) lazy var messageLabel: UILabel =
    { [unowned self] in
        
        let anObject = UILabel(frame: .zero)
        anObject.font = UIFont.systemFont(ofSize: 16)
        
        self.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Creating a View Object
    
    override init(frame: CGRect)
    {
        let dx = (UIScreen.main.bounds.width*0.5) - (AlertPanel.fixedSize.width*0.5)
        let origin = CGPoint(x: dx, y: -100)
        let rect = CGRect(origin: origin, size: AlertPanel.fixedSize)
        
        super.init(frame: rect)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = rect.height * 0.5
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.6
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        self.updateLayout(nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Animation Support
extension AlertPanel
{
    func show() // TODO:Support animation protocol ...
    {
        let dx = (UIScreen.main.bounds.width * 0.5) - (AlertPanel.fixedSize.width * 0.5)
        var dy: CGFloat = -100
        if let height = self.imageView.image?.size.height
        { dy = height }

        self.alpha = 0.0
        self.frame = CGRect(origin: CGPoint(x: dx, y: -dy), size: AlertPanel.fixedSize)
        
        UIView.animate(withDuration: 0.3)
        {
            self.alpha = 1.0
            self.frame = CGRect(origin: CGPoint(x: dx, y: 35), size: AlertPanel.fixedSize)
        }
    }
    
    func dismiss(_ completion: @escaping () -> Void)
    {
        var dy: CGFloat = -100
        if let height = self.imageView.image?.size.height
        { dy = height }
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        
                        self.alpha = 0.0
                        self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: -dy),
                                            size: AlertPanel.fixedSize)
        },
                       completion: { finished in completion() })
    }
}

// MARK: - Geometry
extension AlertPanel: Geometry
{
    static var fixedSize: CGSize
    {
        let width: CGFloat = UIScreen.main.bounds.width * 0.5
        let height: CGFloat = 60.0
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - GeometryLayout
extension AlertPanel: GeometryLayout
{
    func updateLayout(_ container: UIView?)
    {
        let guide = self.layoutMarginsGuide
        let margin: CGFloat = 14.0
        let leading: CGFloat = 2.0
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.heightAnchor.constraint(equalTo: guide.heightAnchor, constant: 0).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: guide.heightAnchor, constant: 0).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 18.0).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: margin).isActive = true
        self.messageLabel.topAnchor.constraint(equalTo: guide.centerYAnchor, constant: leading).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: margin).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: guide.centerYAnchor, constant: -leading).isActive = true
    }
}

