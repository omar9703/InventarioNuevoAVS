//
//  DescripcionTableViewCell.swift
//  InventarioAVS
//
//  Created by Omar Campos on 14/03/22.
//

import UIKit
protocol textViewTextProtocol
{
    func getComentarios(comen : String)
}
class DescripcionTableViewCell: UITableViewCell, UITextViewDelegate {
    public var delegate : textViewTextProtocol?
    @IBOutlet weak var cometarios: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cometarios.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textViewDidChange(_ textView: UITextView) {
        delegate?.getComentarios(comen: textView.text)
    }
    
}
