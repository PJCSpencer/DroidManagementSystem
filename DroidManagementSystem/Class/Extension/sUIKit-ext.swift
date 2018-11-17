//
//  sUIKit-ext.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 08/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


protocol Geometry
{
    static var fixedSize: CGSize { get }
}

protocol DynamicGeometry
{
    func calculatedSize() -> CGSize
}

protocol GeometrySpacing
{
    static var marginSize: CGSize { get }
}

protocol GeometryLayout
{
    func updateLayout(_ container: UIView?)
}

extension UIBezierPath
{
    static func triangle(with size: CGSize) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0.0, y: size.height))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: size.width * 0.5, y: 0.0))
        path.close()
        
        return path
    }
}

