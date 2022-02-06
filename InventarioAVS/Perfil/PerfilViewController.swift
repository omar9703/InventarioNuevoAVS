//
//  PerfilViewController.swift
//  InventarioAVS
//
//  Created by Ruben  Omar Campos Vazquez on 05/02/22.
//

import UIKit

class PerfilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var titulos = ["Nombre", "Telefono", "Correo", "Puesto","Fecha"]
    @IBOutlet weak var tablauser: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tablauser.register(UINib(nibName: "ProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tablauser.backgroundColor = .clear
        tablauser.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titulos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductDetailTableViewCell
        cell.titulo.text = titulos[indexPath.row]
        
        cell.titulo.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
