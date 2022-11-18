//
//  ReporteViewController.swift
//  InventarioAVS
//
//  Created by Ruben  Omar Campos Vazquez on 05/02/22.
//

import UIKit

class ReporteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    var deviceDes = true
    var devices = [Datum]()
    var loading : LoadingView?
    var filteredDevices = [Datum]()
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tableReportes: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableReportes.backgroundColor = .clear
        tableReportes.register(UINib(nibName: "ProductoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        hideKeyboardWhenTappedAround()
        loading = LoadingView()
        self.view.addSubview(loading!)
        getData()
        // Do any additional setup after loading the view.
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deviceDes = false
        if searchText != ""
        {
            
            filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Datum) ->Bool in
                return item.dispositivo.codigo?.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
                }
        }
        else
        {
            deviceDes = true
            filteredDevices.removeAll()
        }
        
        self.tableReportes.reloadData()
    }
                
    func getData()
    {
        self.loading?.showLoadingView()
        requestPetition(ofType: Reportes.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/reportes") { (httpcode, dataResponse) in
            if evaluateResponse(controller: self, httpCode: httpcode)
            {
                self.devices.removeAll()
                self.devices = dataResponse!.data
                DispatchQueue.main.async {
                    self.loading?.hideLoadingView()
                    self.tableReportes.reloadData()
                }
                
            }
            else
            {
                DispatchQueue.main.async {
                    self.loading?.hideLoadingView()

                }
                
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !deviceDes
        {
        return filteredDevices.count
        }
        else
        {
            return devices.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductoTableViewCell
        if !deviceDes
        {
            
            cell.marca.text = filteredDevices[indexPath.row].dispositivo.marca
            cell.modelo.text = filteredDevices[indexPath.row].comentarios
            cell.nombre.text = filteredDevices[indexPath.row].dispositivo.producto
            cell.lugar.text = filteredDevices[indexPath.row].dispositivo.lugar?.lugar
        }
        else
        {
            cell.marca.text = devices[indexPath.row].dispositivo.marca
            cell.modelo.text = devices[indexPath.row].comentarios
            cell.nombre.text = devices[indexPath.row].dispositivo.producto
            cell.lugar.text = devices[indexPath.row].dispositivo.lugar?.lugar
            
        }
        cell.backgroundColor = .clear
        cell.marca.textColor = .white
        cell.modelo.textColor = .white
        cell.nombre.textColor = .white
        cell.lugar.textColor = .white
        return cell
    }

}
