//
//  sAppController.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 09/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class AppController: UIViewController
{
    // MARK: - Property(s)
    
    var scene: SceneController = SceneController()
    
    var speechController: SpeechController = SpeechController()
    
    var dataSource: ProbeDroidDataSource?
    {
        didSet
        {
            guard let dataSource = dataSource else
            { return }
            
            dataSource.refreshDelegate = self.scene.probeDroidScene
            self.dataSource?.dms = MockedDMS()
            self.dataSource?.dms?.numberOfProbeDroids()
        }
    }
    
    
    // MARK: - Responding to View Events
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        let section = ProbeDroidDataSourceSection()
        self.dataSource = ProbeDroidDataSource(with: [section])
        
        self.view.addSubview(self.scene.view)
        self.scene.run
        {
            self.speechController.view.alpha = 0.0
            self.view.addSubview(self.speechController.view)
            
            UIView.animate(withDuration: 0.5,
                           delay: 6.0,
                           options: [],
                           animations: { self.speechController.view.alpha = 1.0 },
                           completion: nil)
        }
    }
}

