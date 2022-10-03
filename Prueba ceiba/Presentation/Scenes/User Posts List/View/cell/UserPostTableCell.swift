//
//  UserPostTableCell.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 2/10/22.
//

import Foundation
import UIKit



class UserPostTableCell : UITableViewCell {
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var postTitle: String? {
        set (name) { titleLabel.text = name }
        get { return titleLabel.text }
    }
    
    var postBody: String? {
        set (phone) { bodyLabel.text = phone }
        get { return bodyLabel.text }
    }
}
