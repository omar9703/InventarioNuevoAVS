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
    var cargando = false
    var off = 0
    var deviceDes = true
    var devices = [movimiento]()
    var loading : LoadingView?
    var searchText = ""
    var filteredDevices = [movimiento]()
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tableReportes: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableReportes.backgroundColor = .clear
        tableReportes.register(UINib(nibName: "ProductoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        hideKeyboardWhenTappedAround()
        loading = LoadingView()
        self.view.addSubview(loading!)
        
        getData(offset: off)
        search.delegate = self
        // Do any additional setup after loading the view.
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deviceDes = false
        if searchText != ""
        {
            self.searchText = searchText
            cargando = false
            off=0
            getFilteredData(data : searchText)
        }
        else
        {
            self.searchText = ""
            off+=1
            deviceDes = true
        }
        
        self.tableReportes.reloadData()
    }
    
    func getFilteredData(data : String)
    {
        if !cargando
        {
            loading?.showLoadingView()
            cargando = true
            off+=1
            requestPetition(ofType: Historial.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/movimientos/filter/\(data)?offset=\(off)&limit=20") { (httpcode, dataResponse) in
                self.cargando = false
                if evaluateResponse(controller: self, httpCode: httpcode)
                {
                    self.filteredDevices = dataResponse?.data ?? [movimiento]()
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
    }
    @IBAction func CamreOpen(_ sender: UIButton) {
        let vc = QrReaderViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func getData(offset : Int)
    {
        if !cargando
        {
            loading?.showLoadingView()
            cargando = true
            off+=1
            requestPetition(ofType: Historial.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/movimientos?offset=\(off)&limit=20") { (httpcode, dataResponse) in
                self.cargando = false
                if evaluateResponse(controller: self, httpCode: httpcode)
                {
                    for x in dataResponse!.data!
                    {
                        self.devices.append(x)
                    }
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
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
            
            cell.marca.text = filteredDevices[indexPath.row].dispositivo?.codigo
            cell.modelo.text = filteredDevices[indexPath.row].lugar?.fechaAlta?.setDateProperly()
            cell.nombre.text = filteredDevices[indexPath.row].dispositivo?.producto
            cell.lugar.text = filteredDevices[indexPath.row].lugar?.lugar
        }
        else
        {
            cell.marca.text = devices[indexPath.row].dispositivo?.codigo
            cell.modelo.text = devices[indexPath.row].lugar?.fechaAlta?.setDateProperly()
            cell.nombre.text = devices[indexPath.row].dispositivo?.producto
            cell.lugar.text = devices[indexPath.row].lugar?.lugar
            
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
            vc.historia = filteredDevices[indexPath.row]
        }
        else
        {
            vc.historia = devices[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
            let contentYOffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYOffset

            if distanceFromBottom < height {
                if deviceDes
                {
                    self.getData(offset:off)
                    
                }
                else
                {
                    self.getFilteredData(data: self.searchText)
                }
            }
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
