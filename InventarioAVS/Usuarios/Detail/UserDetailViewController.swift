//
//  UserDetailViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 26/01/22.
//

import UIKit

class UserDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var device : loginUser? = nil
    
    @IBOutlet weak var tableDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDetail.register(UINib(nibName: "ProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        if let _ = device
        {
            tableDetail.reloadData()
        }
        tableDetail.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductDetailTableViewCell
        cell.backgroundColor = .clear
        if indexPath.row == 0
        {
            cell.titulo.text = "Nombre"
            cell.descripcion.text = device?.nombre ?? "" + " \(device?.apellidoPaterno) \(device?.apellidoMaterno) "
        }
        else if indexPath.row == 1
        {
            cell.titulo.text = "Tipo de usuario"
            cell.descripcion.text = device?.rol.nombre
        }
        else if indexPath.row == 2
        {
            cell.titulo.text = "Fecha de ingreso"
            cell.descripcion.text = device?.fechaAlta
        }
        else if indexPath.row == 3
        {
            cell.titulo.text = "Teléfono"
            cell.descripcion.text = device?.telefono
        }
        else if indexPath.row == 4
        {
            cell.titulo.text = "Correo"
            cell.descripcion.text = device?.correo
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    


}
