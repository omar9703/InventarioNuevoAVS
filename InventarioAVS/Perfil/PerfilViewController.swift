//
//  PerfilViewController.swift
//  InventarioAVS
//
//  Created by Ruben  Omar Campos Vazquez on 05/02/22.
//

import UIKit

class PerfilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var titulos = ["Nombre", "Apellido Paterno", "Apellido Materno", "Correo","Telefono"]
    var descripcion = [String]()
    @IBOutlet weak var tablauser: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tablauser.register(UINib(nibName: "ProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tablauser.backgroundColor = .clear
        if let usuario = UsuarioData.GetUser()
        {
            descripcion.append(usuario.nombre)
            descripcion.append(usuario.apellidoPaterno)
            descripcion.append(usuario.apellidoMaterno)
            descripcion.append(usuario.correo)
            descripcion.append(usuario.telefono)
            tablauser.reloadData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titulos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductDetailTableViewCell
        cell.titulo.text = titulos[indexPath.row]
        cell.descripcion.textColor = .white
        if descripcion.count > 0
        {
            cell.descripcion.text = descripcion[indexPath.row]
        }
        cell.titulo.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
