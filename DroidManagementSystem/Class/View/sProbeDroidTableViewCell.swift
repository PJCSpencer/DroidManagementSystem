//
//  sProbeDroidTableViewCell.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 04/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ProbeDroidTableViewCell: UITableViewCell
{
    // MARK: - Property(s)
    
    private(set) lazy var move: UIButton =
    { [unowned self] in
        
        let anObject = UIButton(frame: .zero)
        anObject.setTitle("move", for: .normal)
        anObject.setTitleColor(.black, for: .normal)
        
        self.contentView.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Initialisation
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Laying Out Subviews
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let size = CGSize(width: 70, height: 40)
        let offset: CGFloat = 12
        let dy: CGFloat = (self.contentView.bounds.height * 0.5) - (size.height * 0.5)
        
        self.move.frame = CGRect(origin: CGPoint(x: self.contentView.bounds.width - (size.width + offset), y: dy), size: size)
    }
}

