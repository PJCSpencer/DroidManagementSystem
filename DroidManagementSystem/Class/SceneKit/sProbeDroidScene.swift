//
//  sProbeDroidScene.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 10/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import SceneKit


class ProbeDroidScene: SCNScene
{
    private(set) lazy var camera: SCNNode =
    { [unowned self] in
        
        let constraint = SCNLookAtConstraint(target: self.target)
        constraint.isGimbalLockEnabled = true
        
        let anObject = SCNNode()
        anObject.camera = SCNCamera()
        anObject.camera?.zNear = 0.1
        anObject.camera?.zFar = 1000.0
        anObject.position = SCNVector3(0, 7, 7)
        anObject.constraints = [constraint]
        
        self.rootNode.addChildNode(anObject)
        return anObject
    }()
    
    private(set) lazy var target: SCNNode =
    { [unowned self] in
        
        let anObject = SCNNode()
        anObject.position = SCNVector3(0, 0, 1)
        
        self.rootNode.addChildNode(anObject)
        return anObject
    }()
    
    private(set) lazy var container: SCNNode =
    { [unowned self] in
        
        let anObject = SCNNode()
        anObject.position = SCNVector3(x: -5, y: 0, z: -5)
        
        self.rootNode.addChildNode(anObject)
        return anObject
    }()
    
    private lazy var grid: SCNNode =
    { [unowned self] in
        
        let anObject = SCNNode()
        anObject.position = SCNVector3(x: -5, y: 0, z: -5)
        
        self.rootNode.addChildNode(anObject)
        return anObject
    }()
    
    init(image: UIImage? = nil)
    {
        super.init()
        
        self.background.contents = image ?? nil
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
}

extension ProbeDroidScene
{
    func addNode(_ probeDroid: ProbeDroid)
    {
        let node = ProbeDroidNode(probeDroid: probeDroid)
        node.opacity = 0.0
        
        self.container.addChildNode(node)
    }
    
    func setNodesHidden(_ hidden: Bool, animated: Bool)
    {
        var dt: TimeInterval = 2.0
        let offset: TimeInterval = 0.3
        
        for node in self.container.childNodes
        {
            let wait = SCNAction.wait(duration: dt)
            let fade = SCNAction.fadeOpacity(to: hidden ? 0.0 : 1.0, duration: offset)
            fade.timingMode = .easeInEaseOut
            
            node.runAction(SCNAction.sequence([wait, fade]))
            
            dt += offset
        }
    }
}

extension ProbeDroidScene
{
    func load()
    {
        var wait = 0.0
        let dt: TimeInterval = 0.06
        
        let numberOfSegments: Int = 10
        var dx: Float = 0.0
        var dy: Float = 0.0 - 0.05
        
        let m0 = SCNAction.moveBy(x: 0, y: 6, z: 12, duration: 1.0)
        m0.timingMode = .easeInEaseOut
        
        let m1 = SCNAction.move(to: SCNVector3(x: 0, y: 8, z: 7), duration: 0.6)
        m1.timingMode = .easeInEaseOut
        
        self.camera.runAction(SCNAction.sequence([m0, m1]))
        
        let rotate = SCNAction.rotateBy(x: CGFloat(GLKMathDegreesToRadians(-90)),
                                        y: 0,
                                        z: 0,
                                        duration: 1.4)
        rotate.timingMode = .easeOut
        self.grid.runAction(rotate)
        
        for _ in 0...numberOfSegments
        {
            let node = self.createGridNode(SCNVector3(x: dx, y: -5, z: 0), thickness: 0.1, length: 10.0)
            self.grid.addChildNode(node)
            
            self.fadeNode(node, at: wait)
            
            dx += 1.0
            wait += dt
        }
        
        for _ in 0...numberOfSegments
        {
            let node = self.createGridNode(SCNVector3(x: 5.0, y: dy, z: 0), thickness: 10.0, length: 0.1)
            self.grid.addChildNode(node)
            
            self.fadeNode(node, at: wait)
            
            dy -= (1.0 - (0.1 / Float(numberOfSegments)))
            wait += dt
        }
    }
    
    func createGridNode(_ position: SCNVector3,
                        thickness: CGFloat,
                        length: CGFloat) -> SCNNode
    {
        let plane = SCNPlane(width: thickness, height: length)
        plane.firstMaterial?.diffuse.contents = UIColor(red: 206.0/255.0,
                                                        green: 217.0/255.0,
                                                        blue: 38.0/255.0,
                                                        alpha: 1.0)
        
        let node = SCNNode(geometry: plane)
        node.opacity = 0.0
        node .position = position
        
        return node
    }
    
    func fadeNode(_ node: SCNNode, at time: TimeInterval)
    {
        let wait = SCNAction.wait(duration: time)
        let fade = SCNAction.fadeOpacity(to: 1.0, duration: 0.08)
        fade.timingMode = .easeOut
        
        node.runAction(SCNAction.sequence([wait, fade]))
    }
}

// MARK: - DataSourceRefresh
extension ProbeDroidScene: DataSourceRefresh
{
    func dataSource(_ dataSource: DataSource, insert indexPaths: [IndexPath])
    {
        guard let dataSource = dataSource as? ProbeDroidDataSource,
            let section = dataSource.section(at: 0) as? ProbeDroidDataSourceSection else
        { return }
        
        for index in indexPaths
        {
            guard let object = section.objects.filter({ $0.probeDroid.index.tag == index.row }).first else
            { continue }
            
            self.addNode(object.probeDroid)
        }
    }
    
    func dataSource(_ dataSource: DataSource, reload indexPaths: [IndexPath]) {}
}

