//
//  ProductDetailTableViewCell.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 26/01/22.
//

import UIKit

class ProductDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
