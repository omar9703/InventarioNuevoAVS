//
//  UsuariosViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 12/01/22.
//

import UIKit

class UsuariosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var userdes = true
    @IBOutlet weak var tableUsers: UITableView!
    var usuarios = Users()
    var usuariosFiltered = Users()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableUsers.register(UINib(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        getData()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    func getData()
    {
        requestPetition(ofType: Users.self, typeRequest: .GET, url: urlAVSuser.users) { (httpCode, data) in
            if evaluateResponse(controller: self, httpCode: httpCode)
            {
                
                    self.usuarios = data!
                    DispatchQueue.main.async {
                        self.tableUsers.reloadData()
                    }
                
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        userdes = false
        if searchText != ""
        {
            usuariosFiltered = searchText.isEmpty ? usuarios : usuarios.filter{(item: User) ->Bool in
                return (item.nombre! + " " + item.apellido_paterno!).lowercased().range(of: searchText.lowercased(), options: .caseInsensitive, range: nil,locale: nil) != nil
            }
        }
        else
        {
            userdes = true
            usuariosFiltered.removeAll()
        }
        
        self.tableUsers.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userdes
        {
            return usuarios.count
        }
        else
        {
            return usuariosFiltered.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersTableViewCell
        if userdes
        {
        
        cell.nombre.text = usuarios[indexPath.row].nombre! + " \(usuarios[indexPath.row].apellido_paterno!)"
        cell.tipoUsuario.text = usuarios[indexPath.row].rol!
        
        }
        else
        {
            cell.nombre.text = usuariosFiltered[indexPath.row].nombre! + " \(usuariosFiltered[indexPath.row].apellido_paterno!)"
            cell.tipoUsuario.text = usuariosFiltered[indexPath.row].rol!
            
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.nombre.textColor = .white
        cell.tipoUsuario.textColor = .white
        return cell
    }

}
