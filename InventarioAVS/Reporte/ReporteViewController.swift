//
//  ReporteViewController.swift
//  InventarioAVS
//
//  Created by Ruben  Omar Campos Vazquez on 05/02/22.
//

import UIKit

class ReporteViewController: UIViewController {

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tableReportes: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableReportes.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }


}
