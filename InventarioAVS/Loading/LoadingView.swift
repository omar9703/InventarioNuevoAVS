//
//  LoadingView.swift
//  InventarioAVS
//
//  Created by Omar Campos on 03/03/22.
//

import Foundation
import UIKit

class LoadingView : UIView
{
    var contentView : UIView?
    
    public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        setUpView()
        }

        // #2
    public override init(frame: CGRect) {
            super.init(frame: frame)
        setUpView()
        }
    
    func setUpView() {
        let fullScreenRect = UIScreen.main.bounds

        self.frame = CGRect(x: 0, y: 0, width: fullScreenRect.size.width, height: fullScreenRect.size.height)
        backgroundColor = UIColor(white: 0.0, alpha: 0.0)

        let width: CGFloat = 200
        let height: CGFloat = 150
        let frame = CGRect(x: (self.frame.size.width - width) / 2, y: (self.frame.size.height - height - 64.0) / 2, width: width, height: height)
        contentView = UIView(frame: frame)
        contentView?.backgroundColor = .white.withAlphaComponent(0)
        var contentLayer = contentView?.layer
        contentLayer?.masksToBounds = true
        contentLayer?.cornerRadius = 5
        
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.frame = CGRect(x: contentView!.frame.size.width / 2 - 22.0, y: contentView!.frame.size.height / 2 - 44, width: 44.0, height: 44.0)
        contentView!.addSubview(spinner)
        spinner.startAnimating()
        
        let downloadLabel = UILabel(frame: CGRect(x: 0, y: spinner.frame.origin.y + spinner.frame.size.height, width: contentView!.frame.size.width, height: 44.0))
        downloadLabel.text = "Cargando..."
        downloadLabel.textColor = UIColor.white
        downloadLabel.textAlignment = .center
        contentView!.addSubview(downloadLabel)

        addSubview(contentView!)

        self.isHidden = true

    }
    func showLoadingView() {
        self.isHidden = false
        UIView.animate(withDuration: 0.3, animations: { [self] in
            contentView!.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        })
    }
    func hideLoadingView() {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            contentView!.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        })
        self.isHidden = true
    }
    
    
}
