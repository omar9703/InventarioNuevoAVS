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
    var usuarios = [loginUser]()
    var loading : LoadingView?
    var usuariosFiltered = [loginUser]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableUsers.register(UINib(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        loading = LoadingView()
        self.view.addSubview(loading!)
        getData()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    func getData()
    {
        self.loading?.showLoadingView()
        requestPetition(ofType: UserRespose.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/usuarios") { (httpCode, data) in
            DispatchQueue.main.async {
                self.loading?.hideLoadingView()
            }
            if evaluateResponse(controller: self, httpCode: httpCode)
            {
                
                self.usuarios = data!.data
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
            usuariosFiltered = searchText.isEmpty ? usuarios : usuarios.filter{(item: loginUser) ->Bool in
                return (item.nombre + " " + item.apellidoPaterno).lowercased().range(of: searchText.lowercased(), options: .caseInsensitive, range: nil,locale: nil) != nil
            }
        }
        else
        {
            userdes = true
            usuariosFiltered.removeAll()
        }
        
        self.tableUsers.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserDetailViewController()
        if userdes
        {
            vc.device = usuarios[indexPath.row]
        }
        else
        {
            vc.device = usuariosFiltered[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
        
            cell.nombre.text = usuarios[indexPath.row].nombre + " \(usuarios[indexPath.row].apellidoPaterno)"
            cell.tipoUsuario.text = usuarios[indexPath.row].rol.nombre
        
        }
        else
        {
            cell.nombre.text = usuariosFiltered[indexPath.row].nombre + " \(usuariosFiltered[indexPath.row].apellidoPaterno)"
            cell.tipoUsuario.text = usuariosFiltered[indexPath.row].rol.nombre
            
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.nombre.textColor = .white
        cell.tipoUsuario.textColor = .white
        return cell
    }

}
