//
//  ImagenTableViewCell.swift
//  InventarioAVS
//
//  Created by Omar Campos on 14/03/22.
//

import UIKit

class ImagenTableViewCell: UITableViewCell {
    @IBOutlet weak var imagen: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
