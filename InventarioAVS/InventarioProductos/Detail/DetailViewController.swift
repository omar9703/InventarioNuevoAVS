//
//  DetailViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 13/01/22.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var device : Device? = nil
    var device2 : products? = nil
    @IBOutlet weak var tableDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDetail.register(UINib(nibName: "ProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableDetail.backgroundColor = .clear
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductDetailTableViewCell
        cell.backgroundColor = .clear
        if indexPath.row == 0
        {
            cell.titulo.text = "Nombre"
            cell.descripcion.text = device?.producto ?? device2?.producto
        }
        else if indexPath.row == 1
        {
            cell.titulo.text = "Marca"
            cell.descripcion.text = device?.marca ?? device2?.marca
        }
        else if indexPath.row == 2
        {
            cell.titulo.text = "Modelo"
            cell.descripcion.text = device?.modelo ?? device2?.modelo
        }
        else if indexPath.row == 3
        {
            cell.titulo.text = "Codigo"
            cell.descripcion.text = device?.codigo ?? device2?.codigo
        }
        else if indexPath.row == 4
        {
            cell.titulo.text = "Origen"
            cell.descripcion.text = device?.origen
        }
        else if indexPath.row == 5
        {
            cell.titulo.text = "Lugar actual"
            cell.descripcion.text = device?.descompostura ?? device2?.lugar
        }
        else if indexPath.row == 6
        {
            cell.titulo.text = "Compra"
            cell.descripcion.text = device?.compra
        }
        else if indexPath.row == 7
        {
            cell.titulo.text = "Observaciones"
            cell.descripcion.text = device?.observaciones
        }
        else if indexPath.row == 8
        {
            cell.titulo.text = "Costo"
            cell.descripcion.text = String(device?.costo ?? 0)
        }
        else if indexPath.row == 9
        {
            cell.titulo.text = "Accesorio de"
            cell.descripcion.text = device?.pertenece
        }
        else if indexPath.row == 10
        {
            cell.titulo.text = "Proveedor"
            cell.descripcion.text = device?.proveedor
        }
        else if indexPath.row == 11
        {
            cell.titulo.text = "Fecha"
            cell.descripcion.text = device?.fechaAlta
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    


}
