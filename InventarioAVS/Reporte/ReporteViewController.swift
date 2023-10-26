//
//  ReporteViewController.swift
//  InventarioAVS
//
//  Created by Ruben  Omar Campos Vazquez on 05/02/22.
//

import UIKit

class ReporteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, qrReaderProtocol {
    func qrReadit(qr: String) {
        self.loading?.showLoadingView()
        search.text = qr
        search.delegate?.searchBar?(search, textDidChange: qr)
//        getFilteredData(data: qr)
    }
    
    var deviceDes = true
    var devices : Historial?
    var loading : LoadingView?
    var filteredDevices : Historial?
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
        search.delegate = self
        // Do any additional setup after loading the view.
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deviceDes = false
        if searchText != ""
        {
            getFilteredData(data : searchText)
        }
        else
        {
            deviceDes = true
        }
        
        self.tableReportes.reloadData()
    }
    
    func getFilteredData(data : String)
    {
        requestPetition(ofType: Historial.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/movimientos/filter/\(data)?offset=1&limit=20") { (httpcode, dataResponse) in
            if evaluateResponse(controller: self, httpCode: httpcode)
            {
                self.filteredDevices = dataResponse
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
    @IBAction func CamreOpen(_ sender: UIButton) {
        let vc = QrReaderViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func getData()
    {
        self.loading?.showLoadingView()
        requestPetition(ofType: Historial.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/movimientos?offset=1&limit=20") { (httpcode, dataResponse) in
            if evaluateResponse(controller: self, httpCode: httpcode)
            {
                self.devices = dataResponse
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !deviceDes
        {
            return filteredDevices?.data?.count ?? 0
        }
        else
        {
            return devices?.data?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductoTableViewCell
        if !deviceDes
        {
            
            cell.marca.text = filteredDevices?.data?[indexPath.row].dispositivo?.codigo
            cell.modelo.text = filteredDevices?.data?[indexPath.row].lugar?.fechaAlta?.setDateProperly()
            cell.nombre.text = filteredDevices?.data?[indexPath.row].dispositivo?.producto
            cell.lugar.text = filteredDevices?.data?[indexPath.row].lugar?.lugar
        }
        else
        {
            cell.marca.text = devices?.data?[indexPath.row].dispositivo?.codigo
            cell.modelo.text = devices?.data?[indexPath.row].lugar?.fechaAlta?.setDateProperly()
            cell.nombre.text = devices?.data?[indexPath.row].dispositivo?.producto
            cell.lugar.text = devices?.data?[indexPath.row].lugar?.lugar
            
        }
        cell.backgroundColor = .clear
        cell.marca.textColor = .white
        cell.modelo.textColor = .white
        cell.nombre.textColor = .white
        cell.lugar.textColor = .white
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if !deviceDes
        {
            vc.historia = filteredDevices?.data?[indexPath.row]
        }
        else
        {
            vc.historia = devices?.data?[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension String
{
    func setDateProperly()->String
    {
        let index = self.index(self.startIndex, offsetBy: 10)
        let mySubstring = self[..<index] // Hello
        return String(mySubstring)
    }
}
