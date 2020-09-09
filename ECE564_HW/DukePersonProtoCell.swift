//
//  DukePersonProtoCell.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/9/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class DukePersonProtoCell: UITableViewCell {
    
    @IBOutlet weak var pImageView: UIImageView!
    
    @IBOutlet weak var pNameLabel: UILabel!
    
    @IBOutlet weak var pDescriptionLabel: UILabel!
    
    func setCell(person: DukePerson){
        self.pImageView.image = UIImage(systemName: "person.crop.circle.fill.badge.exclam")
        self.pNameLabel.text = "\(person.firstName!) \(person.lastName!)"
        self.pDescriptionLabel.text = person.description
    }
}
