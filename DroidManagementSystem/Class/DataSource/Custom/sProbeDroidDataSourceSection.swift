//
//  sProbeDroidDataSourceSection.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 04/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ProbeDroidDataSourceSection: DataSourceSection<ProbeDroidDataSourceObject>
{
    // MARK: - Utility Action(s)
    
    @objc func touchUpInside(_ sender: Any)
    {
        guard let button = sender as? UIButton,
            button.titleLabel?.text == ProbeDroidCommand.move.rawValue,
            let object = self.objects.filter({ $0.probeDroid.index.tag == button.tag }).first else
        { return }
        
        button.isEnabled = false
        button.alpha = 0.3
        
        let userInfo: [String:Any] =
        [
            ProbeDroidIndex.Keys.index.rawValue : object.probeDroid.index,
            Location.Keys.location.rawValue     : Location.random(1000)
        ]
        
        NotificationCenter.default.post(name: ProbeDroidCRequestNotification,
                                        object: nil,
                                        userInfo: userInfo)
    }
}

extension ProbeDroidDataSourceSection: Countable
{
    func numberOfObjects() -> Int
    { return self.objects.count }
}

extension ProbeDroidDataSourceSection: DataSourceSectionRegister
{
    var cellClass: AnyClass
    { return ProbeDroidTableViewCell.self }
}

extension ProbeDroidDataSourceSection: DataSourceSectionPresenter
{
    func cell(_ cell: UIView, displayObjectAt index: Int)
    {
        guard let cell = cell as? ProbeDroidTableViewCell else
        { return }
        
        let probeDroid = self.objects[index].probeDroid
        let index = probeDroid.index.tag
        let status = ProbeDroidStatus(rawValue:probeDroid.status)?.string
        let location = probeDroid.location
        
        cell.textLabel?.text = String("\(index), \(status!), \(location.x):\(location.y)")
        
        cell.move.tag = index
        cell.move.addTarget(self,
                            action: #selector(ProbeDroidDataSourceSection.touchUpInside(_:)),
                            for: .touchUpInside)
    }
}

