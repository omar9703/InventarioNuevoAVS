//
//  DetailViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 13/01/22.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var device : Device? = nil
    @IBOutlet weak var tableDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDetail.register(UINib(nibName: "ProductoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        if let _ = device
        {
            tableDetail.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductoTableViewCell
        cell.modelo.isHidden = true
        if indexPath.row == 0
        {
            cell.nombre.text = "Nombre"
            cell.marca.text = device?.producto
        }
        else if indexPath.row == 1
        {
            cell.nombre.text = "Marca"
            cell.marca.text = device?.marca
        }
        else if indexPath.row == 2
        {
            cell.nombre.text = "Modelo"
            cell.marca.text = device?.modelo
        }
        else if indexPath.row == 3
        {
            cell.nombre.text = "Codigo"
            cell.marca.text = device?.codigo
        }
        else if indexPath.row == 4
        {
            cell.nombre.text = "Origen"
            cell.marca.text = device?.origen
        }
        else if indexPath.row == 5
        {
            cell.nombre.text = "Lugar actual"
            cell.marca.text = device?.lugar
        }
        else if indexPath.row == 6
        {
            cell.nombre.text = "Compra"
            cell.marca.text = device?.compra
        }
        else if indexPath.row == 7
        {
            cell.nombre.text = "Observaciones"
            cell.marca.text = device?.observaciones
        }
        else if indexPath.row == 8
        {
            cell.nombre.text = "Costo"
            cell.marca.text = device?.costo
        }
        else if indexPath.row == 9
        {
            cell.nombre.text = "Accesorio de"
            cell.marca.text = device?.origen
        }
        else if indexPath.row == 10
        {
            cell.nombre.text = "Proveedor"
            cell.marca.text = device?.proveedor
        }
        else if indexPath.row == 11
        {
            cell.nombre.text = "Fecha"
            cell.marca.text = device?.fecha
        }
        return cell
    }
    


}
