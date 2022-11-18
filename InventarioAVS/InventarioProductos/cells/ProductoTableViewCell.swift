//
//  ProductoTableViewCell.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 11/01/22.
//

import UIKit

class ProductoTableViewCell: UITableViewCell {

    @IBOutlet weak var lugar: UILabel!
    @IBOutlet weak var modelo: UILabel!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var marca: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
