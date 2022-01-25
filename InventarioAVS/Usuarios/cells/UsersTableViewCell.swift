//
//  UsersTableViewCell.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 12/01/22.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var tipoUsuario: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
