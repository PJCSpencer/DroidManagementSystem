//
//  sProbeDroidNode.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 04/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import SceneKit


class ProbeDroidNode: SCNNode
{
    // MARK: - Constant(s)
    
    static let indexPrefix: String = "pd_"
    
    
    // MARK: - Property(s)
    
    var localGridSize: CGSize = CGSize(width: 10.0, height: 10.0)
    
    var globalGridSize: CGSize = CGSize(width: 1000.0, height: 1000.0)
    
    fileprivate var observation: NSKeyValueObservation?
    
    private(set) lazy var titleNode: SCNNode =
    { [unowned self] in
        
        let geometry = SCNText(string: self.name, extrusionDepth: 0.0)
        geometry.firstMaterial?.diffuse.contents = UIColor.white
        geometry.font = UIFont.boldSystemFont(ofSize: 0.5)
        geometry.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        geometry.isWrapped = false
        geometry.truncationMode = CATextLayerTruncationMode.end.rawValue
        
        let scale: CGFloat = 1.4
        let width: CGFloat = CGFloat(geometry.boundingBox.max.x + geometry.boundingBox.min.x) * scale
        let height: CGFloat = CGFloat(geometry.boundingBox.max.y + geometry.boundingBox.min.y) * scale
        geometry.containerFrame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        
        let anObject = SCNNode(geometry: geometry)
        anObject.position = SCNVector3(-(geometry.boundingBox.max.x*0.5), -2.75, 0)
        
        self.addChildNode(anObject)
        return anObject
    }()
    
    private(set) lazy var bodyNode: SCNNode =
    { [unowned self] in
        
        let scale: CGFloat = 0.4
        let shape = SCNShape(path: UIBezierPath.triangle(with: CGSize(width: scale, height: scale)),
                             extrusionDepth: 0)
        shape.firstMaterial?.diffuse.contents = UIColor.white
        
        let anObject = SCNNode(geometry: shape)
        anObject.position = SCNVector3(-(scale*0.5), 0, 0)
        
        self.addChildNode(anObject)
        return anObject
    }()


    // MARK: - Initialisation
    
    init(probeDroid: ProbeDroid)
    {
        super.init()
     
        self.name = String(probeDroid.index.tag)
        
        let _ = self.titleNode
        let _ = self.bodyNode
        
        self.observation = probeDroid.observe(\.location,
                                              options: [.new],
                                              changeHandler: self.locate)
        
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = SCNBillboardAxis.all
        self.constraints = [constraint]
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    deinit
    { self.observation?.invalidate() }
}

// MARK: - KVO Support
extension ProbeDroidNode
{
    func locate(_ probeDroid: ProbeDroid,
                 _ change: NSKeyValueObservedChange<Location>)
    {
        guard let location = change.newValue else
        { return }
        
        let xramp: Float = 1.0 / Float(self.globalGridSize.width) * Float(location.x)
        let yramp: Float = 1.0 / Float(self.globalGridSize.height) * Float(location.y)
        
        let vector = SCNVector3(x: Float(self.localGridSize.width) * xramp,
                                y: 0,
                                z: Float(self.localGridSize.height) * yramp)
        
        self.runAction(SCNAction.move(to: vector, duration: 0.3)) // TODO:Duration should be relative to distance travelled ...
    }
}

