//
//  UserListTableCell.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 29/09/22.
//

import UIKit



class UserListTableCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var delegate: UserListTableCellDelegate?
    
    var viewModel: UserListCellViewModel? {
        didSet {
            nameLabel.text = viewModel?.name
            phoneLabel.text = viewModel?.phone
            emailLabel.text = viewModel?.email
        }
    }
    
   
    
    @IBAction func doShowPost(_ sender: Any) {
        delegate?.doShowPost(self)
    }
}



protocol UserListTableCellDelegate {
    func doShowPost(_ cell: UserListTableCell)
}
