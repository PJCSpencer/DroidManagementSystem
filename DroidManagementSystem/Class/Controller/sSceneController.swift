//
//  sSceneController.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 10/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit
import SceneKit


class SceneController: UIViewController
{
    // MARK: - Property(s)
    
    private(set) lazy var introScene: IntroScene =
    { [unowned self] in
        
        let anObject = IntroScene()
        anObject.isBackgroundVisible = true
        return anObject
    }()
    
    var probeDroidScene: ProbeDroidScene = ProbeDroidScene()
    
    
    // MARK: - Managing the View
    
    override func loadView()
    { self.view = KorribanView(frame: UIScreen.main.bounds) }
}

extension SceneController
{
    func run(completion: @escaping () -> Void)
    {
        guard let view = self.view as? KorribanView else
        { return }
        
        view.sceneView.scene = self.introScene
        view.sceneView.pointOfView = self.introScene.camera
        
        self.introScene.run()
        {
            DispatchQueue.main.async
            {
                let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size,
                                                       format: UIGraphicsImageRendererFormat())
                
                let image = renderer.image
                { (context) in
                    
                    view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
                }
                
                let composite = renderer.image
                { (context) in
                    
                    view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
                    UIImage(named: "ProbeDroidSceneOverlay")?.draw(in: view.bounds)
                }
                
                view.sceneView.scene = self.probeDroidScene
                view.sceneView.pointOfView = self.probeDroidScene.camera
                view.background.image = image
                view.setOverlayImage(composite, animated: true)
                
                self.probeDroidScene.load()
                self.probeDroidScene.setNodesHidden(false, animated: true)
                
                completion()
            }
        }
    }
}

